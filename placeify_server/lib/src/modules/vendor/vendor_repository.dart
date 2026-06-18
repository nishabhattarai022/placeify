import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/server_static_paths.dart';
import '../../shared/session_service.dart';
import 'product_3d/product_3d_generation_result.dart';
import 'product_3d/product_3d_generator.dart';
import 'product_3d/product_3d_image_paths.dart';
import 'product_image_processor.dart';

class VendorStore {
  Future<VendorDashboard> getDashboard(Session session) async {
    final user = await SessionService.requireUser(session);
    final vendor = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(user.id!),
    );
    if (vendor == null) {
      throw PlaceifyException(message: 'Shop not found.',
        code: 'SHOP_NOT_FOUND',
      );
    }

    final vendorId = vendor.id!;
    final products = await Product.db.find(
      session,
      where: (row) => row.vendorId.equals(vendorId),
    );
    final activeProducts =
        products.where((p) => p.status == ProductStatus.active).length;

    final orderItems = await _loadVendorOrderItems(session, vendorId);

    final revenue = orderItems.fold<double>(
      0,
      (sum, item) => sum + item.unitPrice * item.quantity,
    );

    final productSales = <int, ({String name, int units, double revenue})>{};
    for (final item in orderItems) {
      final productId = item.productId;
      final name = item.product?.name ?? 'Product';
      final lineRevenue = item.unitPrice * item.quantity;
      final existing = productSales[productId];
      if (existing == null) {
        productSales[productId] = (
          name: name,
          units: item.quantity,
          revenue: lineRevenue,
        );
      } else {
        productSales[productId] = (
          name: existing.name,
          units: existing.units + item.quantity,
          revenue: existing.revenue + lineRevenue,
        );
      }
    }

    final topProductEntries = productSales.entries.toList()
      ..sort((a, b) => b.value.revenue.compareTo(a.value.revenue));

    final topProducts = [
      for (final entry in topProductEntries.take(3))
        VendorProductStat(
          productId: entry.key,
          name: entry.value.name,
          unitsSold: entry.value.units,
          revenue: entry.value.revenue,
        ),
    ];

    final recentOrderItems = orderItems.take(6).toList();
    final recentOrders = <VendorOrderSummary>[
      for (final item in recentOrderItems)
        if (item.id != null && item.order != null)
          VendorOrderSummary(
            orderItemId: item.id!,
            orderId: item.orderId,
            orderNumber: item.orderId.toString().padLeft(5, '0'),
            productName: item.product?.name ?? 'Product',
            quantity: item.quantity,
            lineTotal: item.unitPrice * item.quantity,
            status: item.order!.status,
            placedAt: item.order!.placedAt,
            customerName: item.order!.user?.name,
          ),
    ];

    final customizationRequests = await CustomizationRequest.db.find(
      session,
      where: (row) => row.vendorId.equals(vendorId),
      include: CustomizationRequest.include(
        user: User.include(),
        product: Product.include(),
      ),
      orderDescending: true,
      orderBy: (row) => row.createdAt,
      limit: 3,
    );

    for (final request in customizationRequests) {
      if (request.id == null) continue;
      recentOrders.add(
        VendorOrderSummary(
          orderItemId: request.id!,
          orderId: request.id!,
          orderNumber: '',
          productName: request.product?.name ?? 'Custom request',
          quantity: 1,
          lineTotal: 0,
          status: OrderStatus.pending,
          placedAt: request.createdAt,
          isCustomizationRequest: true,
          requestMeta:
              'Request · ${request.user?.name ?? 'Customer'}',
        ),
      );
    }

    recentOrders.sort((a, b) => b.placedAt.compareTo(a.placedAt));

    return VendorDashboard(
      shop: vendor,
      productCount: products.length,
      activeProductCount: activeProducts,
      orderCount: orderItems.length,
      revenue: revenue,
      recentOrders: recentOrders.take(6).toList(),
      topProducts: topProducts,
    );
  }

  Future<Vendor> requireVendorProfile(Session session) async {
    final user = await SessionService.requireRole(
      session,
      {UserRole.vendor, UserRole.admin},
    );

    final vendor = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(user.id!),
    );
    if (vendor == null) {
      throw PlaceifyException(message: 'Vendor profile not found.',
        code: 'VENDOR_NOT_FOUND',
      );
    }
    return vendor;
  }

  /// Resolves the vendor shop for the logged-in user without requiring a
  /// pre-set vendor role (upgrades role when a shop already exists).
  Future<Vendor> requireOwnedVendor(Session session) async {
    var user = await SessionService.requireUser(session);
    final vendor = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(user.id!),
    );
    if (vendor == null) {
      throw PlaceifyException(message: 'Shop not found.',
        code: 'SHOP_NOT_FOUND',
      );
    }

    if (user.role != UserRole.vendor && user.role != UserRole.admin) {
      user = await User.db.updateRow(
        session,
        user.copyWith(role: UserRole.vendor),
      );
    }

    if (user.role != UserRole.admin &&
        user.status != UserAccountStatus.approved) {
      throw PlaceifyException(
        message: 'Vendor account is pending admin approval.',
        code: 'VENDOR_NOT_APPROVED',
      );
    }

    if (!user.isActive) {
      throw PlaceifyException(
        message: 'Vendor account is deactivated.',
        code: 'ACCOUNT_INACTIVE',
      );
    }

    return vendor;
  }

  Future<bool> hasShop(Session session) async {
    final user = await SessionService.requireUser(session);
    final existing = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(user.id!),
    );
    return existing != null;
  }

  Future<Vendor> createShop(
    Session session,
    String shopName, {
    String? description,
    String? logoUrl,
    String? phone,
    String? address,
    String? shopCategory,
  }) async {
    final user = await SessionService.requireUser(session);
    final existing = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(user.id!),
    );
    if (existing != null) {
      throw PlaceifyException(message: 'Vendor shop already exists.',
        code: 'VENDOR_EXISTS',
      );
    }

    final trimmedName = shopName.trim();
    final trimmedDescription = description?.trim();
    if (trimmedName.isEmpty) {
      throw PlaceifyException(message: 'Shop name is required.',
        code: 'INVALID_SHOP_NAME',
      );
    }
    if (trimmedDescription == null || trimmedDescription.isEmpty) {
      throw PlaceifyException(message: 'Shop description is required.',
        code: 'INVALID_SHOP_DESCRIPTION',
      );
    }

    final trimmedPhone = phone?.trim();
    if (trimmedPhone == null || trimmedPhone.isEmpty) {
      throw PlaceifyException(message: 'Phone number is required.',
        code: 'INVALID_PHONE',
      );
    }

    final trimmedAddress = address?.trim();
    if (trimmedAddress == null || trimmedAddress.isEmpty) {
      throw PlaceifyException(message: 'Shop address is required.',
        code: 'INVALID_ADDRESS',
      );
    }

    await User.db.updateRow(
      session,
      user.copyWith(
        role: UserRole.vendor,
        phone: trimmedPhone,
        address: trimmedAddress,
        status: UserAccountStatus.pending,
        updatedAt: DateTime.now(),
      ),
    );

    return Vendor.db.insertRow(
      session,
      Vendor(
        userId: user.id!,
        shopName: trimmedName,
        description: trimmedDescription,
        businessAddress: trimmedAddress,
        shopCategory: shopCategory?.trim(),
        logoUrl: logoUrl?.trim(),
      ),
    );
  }

  Future<Vendor> updateShop(
    Session session,
    String shopName, {
    String? description,
    String? logoUrl,
  }) async {
    final vendor = await requireVendorProfile(session);
    return Vendor.db.updateRow(
      session,
      vendor.copyWith(
        shopName: shopName.trim(),
        description: description?.trim(),
        logoUrl: logoUrl?.trim(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<VendorProfileDetail> getMyProfile(Session session) async {
    final vendor = await requireOwnedVendor(session);
    return _loadProfileDetail(session, vendor);
  }

  Future<VendorProfileDetail?> getShopProfile(
    Session session,
    UuidValue vendorId,
  ) async {
    final vendor = await Vendor.db.findById(
      session,
      vendorId,
      include: Vendor.include(user: User.include()),
    );
    if (vendor == null) return null;

    final user = vendor.user;
    if (user == null ||
        user.role != UserRole.vendor ||
        user.status != UserAccountStatus.approved ||
        !user.isActive) {
      return null;
    }

    return _mapProfileDetail(vendor, user);
  }

  Future<VendorProfileDetail> updateMyProfile(
    Session session,
    VendorProfileUpdateInput input,
  ) async {
    final vendor = await requireOwnedVendor(session);
    final user = await User.db.findById(session, vendor.userId);
    if (user == null) {
      throw PlaceifyException(
        message: 'User account not found.',
        code: 'USER_NOT_FOUND',
      );
    }

    final businessName = input.businessName?.trim();
    if (businessName != null && businessName.isEmpty) {
      throw PlaceifyException(
        message: 'Business name is required.',
        code: 'INVALID_BUSINESS_NAME',
      );
    }

    final phone = input.phone?.trim();
    if (phone != null && phone.isEmpty) {
      throw PlaceifyException(
        message: 'Phone number is required.',
        code: 'INVALID_PHONE',
      );
    }

    final address = input.address?.trim();
    if (address != null && address.isEmpty) {
      throw PlaceifyException(
        message: 'Address is required.',
        code: 'INVALID_ADDRESS',
      );
    }

    final now = DateTime.now();
    final updatedUser = await User.db.updateRow(
      session,
      user.copyWith(
        phone: phone ?? user.phone,
        address: address ?? user.address,
        updatedAt: now,
      ),
    );

    final updatedVendor = await Vendor.db.updateRow(
      session,
      vendor.copyWith(
        shopName: businessName ?? vendor.shopName,
        description: input.bio?.trim() ?? vendor.description,
        businessAddress: address ?? vendor.businessAddress,
        shopCategory: input.category?.trim() ?? vendor.shopCategory,
        logoUrl: _nullableTrim(input.logoUrl) ?? vendor.logoUrl,
        bannerUrl: _nullableTrim(input.bannerUrl) ?? vendor.bannerUrl,
        instagramHandle:
            input.instagramHandle?.trim() ?? vendor.instagramHandle,
        facebookHandle: input.facebookHandle?.trim() ?? vendor.facebookHandle,
        operatingHours: input.operatingHours?.trim() ?? vendor.operatingHours,
        updatedAt: now,
      ),
    );

    return _mapProfileDetail(updatedVendor, updatedUser);
  }

  Future<String> uploadShopLogo(
    Session session,
    ByteData fileData,
    String fileName,
  ) async {
    final vendor = await requireOwnedVendor(session);
    final logoUrl = await _persistProductImage(session, fileData, fileName);
    await Vendor.db.updateRow(
      session,
      vendor.copyWith(logoUrl: logoUrl, updatedAt: DateTime.now()),
    );
    return logoUrl;
  }

  Future<String> uploadShopBanner(
    Session session,
    ByteData fileData,
    String fileName,
  ) async {
    final vendor = await requireOwnedVendor(session);
    final bannerUrl = await _persistProductImage(session, fileData, fileName);
    await Vendor.db.updateRow(
      session,
      vendor.copyWith(bannerUrl: bannerUrl, updatedAt: DateTime.now()),
    );
    return bannerUrl;
  }

  Future<VendorProfileDetail> _loadProfileDetail(
    Session session,
    Vendor vendor,
  ) async {
    final user = await User.db.findById(session, vendor.userId);
    if (user == null) {
      throw PlaceifyException(
        message: 'User account not found.',
        code: 'USER_NOT_FOUND',
      );
    }
    return _mapProfileDetail(vendor, user);
  }

  VendorProfileDetail _mapProfileDetail(Vendor vendor, User user) {
    return VendorProfileDetail(
      id: vendor.id!,
      businessName: vendor.shopName,
      email: user.email ?? '',
      phone: user.phone ?? '',
      address: vendor.businessAddress ?? user.address ?? '',
      category: vendor.shopCategory ?? '',
      logoUrl: vendor.logoUrl,
      bio: vendor.description ?? '',
      bannerUrl: vendor.bannerUrl,
      instagramHandle: vendor.instagramHandle ?? '',
      facebookHandle: vendor.facebookHandle ?? '',
      operatingHours: vendor.operatingHours ?? '',
      createdAt: vendor.createdAt,
    );
  }

  String? _nullableTrim(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<List<Product>> listMyProducts(Session session) async {
    final vendor = await requireOwnedVendor(session);
    return Product.db.find(
      session,
      where: (row) => row.vendorId.equals(vendor.id!),
      include: Product.include(category: Category.include()),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
    );
  }

  Future<Product> createProduct(
    Session session,
    String name,
    String description,
    double price, {
    int? categoryId,
    String? materials,
    double? widthCm,
    double? depthCm,
    double? heightCm,
    double? weightKg,
    String? assemblyNote,
    String? careInstructions,
    String? warranty,
    String? model3dUrl,
    String? thumbnailUrl,
    List<String>? viewImageUrls,
  }) async {
    final vendor = await requireOwnedVendor(session);
    if (name.trim().isEmpty || description.trim().isEmpty) {
      throw PlaceifyException(message: 'Name and description are required.',
        code: 'INVALID_PRODUCT',
      );
    }
    if (price <= 0) {
      throw PlaceifyException(message: 'Price must be positive.', code: 'INVALID_PRICE');
    }

    final trimmedMaterials = materials?.trim();
    if (trimmedMaterials == null || trimmedMaterials.isEmpty) {
      throw PlaceifyException(message: 'Materials are required.',
        code: 'INVALID_MATERIALS',
      );
    }

    if (widthCm == null || depthCm == null || heightCm == null) {
      throw PlaceifyException(message: 'Product dimensions are required.',
        code: 'INVALID_DIMENSIONS',
      );
    }
    if (widthCm <= 0 || depthCm <= 0 || heightCm <= 0) {
      throw PlaceifyException(message: 'Dimensions must be positive.',
        code: 'INVALID_DIMENSIONS',
      );
    }

    final trimmedCare = careInstructions?.trim();
    if (trimmedCare == null || trimmedCare.isEmpty) {
      throw PlaceifyException(message: 'Care instructions are required.',
        code: 'INVALID_CARE',
      );
    }

    var resolvedCategoryId = categoryId;
    if (resolvedCategoryId == null) {
      final defaultCategory = await Category.db.findFirstRow(
        session,
        where: (row) => row.name.equals('chairs'),
      );
      resolvedCategoryId = defaultCategory?.id;
    }

    return Product.db.insertRow(
      session,
      Product(
        vendorId: vendor.id!,
        categoryId: resolvedCategoryId,
        name: name.trim(),
        description: description.trim(),
        price: price,
        materials: trimmedMaterials,
        widthCm: widthCm,
        depthCm: depthCm,
        heightCm: heightCm,
        weightKg: weightKg,
        assemblyNote: assemblyNote?.trim(),
        careInstructions: trimmedCare,
        warranty: warranty?.trim(),
        model3dUrl: model3dUrl?.trim(),
        thumbnailUrl: thumbnailUrl?.trim(),
        viewImageUrls: viewImageUrls,
        status: ProductStatus.active,
      ),
    );
  }

  /// Creates or updates a product. When [input.productId] is set, updates that
  /// product; a photo is optional on update (empty [imageData] keeps the current
  /// thumbnail). New products require a photo.
  Future<Product> uploadProduct(
    Session session,
    VendorProductUploadInput input,
    ByteData imageData,
    String imageFileName,
  ) async {
    await requireOwnedVendor(session);

    final existingProductId = input.productId;
    if (existingProductId != null) {
      return _updateExistingProduct(
        session,
        existingProductId,
        input,
        imageData,
        imageFileName,
      );
    }

    if (imageData.lengthInBytes == 0) {
      throw PlaceifyException(
        message: 'Product photo is required.',
        code: 'INVALID_FILE',
      );
    }

    final thumbnailUrl = await _persistProductImage(
      session,
      imageData,
      imageFileName,
    );

    var product = await createProduct(
      session,
      input.name,
      input.description,
      input.price,
      categoryId: input.categoryId,
      materials: input.materials,
      widthCm: input.widthCm,
      depthCm: input.depthCm,
      heightCm: input.heightCm,
      weightKg: input.weightKg,
      assemblyNote: input.assemblyNote,
      careInstructions: input.careInstructions,
      warranty: input.warranty,
      thumbnailUrl: thumbnailUrl,
    );

    if (input.generateModel3d) {
      product = await _generateAndStoreModel3d(
        session,
        product,
        skipIfExists: false,
        throwOnFailure: false,
      );
    }

    return _loadProductWithCategory(session, product);
  }

  Future<Product> _updateExistingProduct(
    Session session,
    int productId,
    VendorProductUploadInput input,
    ByteData imageData,
    String imageFileName,
  ) async {
    final vendor = await requireOwnedVendor(session);
    final product = await Product.db.findById(session, productId);
    if (product == null || product.vendorId != vendor.id) {
      throw PlaceifyException(
        message: 'Product not found.',
        code: 'PRODUCT_NOT_FOUND',
      );
    }

    if (input.name.trim().isEmpty || input.description.trim().isEmpty) {
      throw PlaceifyException(
        message: 'Name and description are required.',
        code: 'INVALID_PRODUCT',
      );
    }
    if (input.price <= 0) {
      throw PlaceifyException(message: 'Price must be positive.', code: 'INVALID_PRICE');
    }

    final trimmedMaterials = input.materials.trim();
    if (trimmedMaterials.isEmpty) {
      throw PlaceifyException(
        message: 'Materials are required.',
        code: 'INVALID_MATERIALS',
      );
    }

    if (input.widthCm <= 0 || input.depthCm <= 0 || input.heightCm <= 0) {
      throw PlaceifyException(
        message: 'Dimensions must be positive.',
        code: 'INVALID_DIMENSIONS',
      );
    }

    final trimmedCare = input.careInstructions.trim();
    if (trimmedCare.isEmpty) {
      throw PlaceifyException(
        message: 'Care instructions are required.',
        code: 'INVALID_CARE',
      );
    }

    var resolvedCategoryId = input.categoryId ?? product.categoryId;
    if (resolvedCategoryId == null) {
      final defaultCategory = await Category.db.findFirstRow(
        session,
        where: (row) => row.name.equals('chairs'),
      );
      resolvedCategoryId = defaultCategory?.id;
    }

    var thumbnailUrl = product.thumbnailUrl;
    if (imageData.lengthInBytes > 0) {
      thumbnailUrl = await _persistProductImage(
        session,
        imageData,
        imageFileName,
      );
    }

    var updated = await Product.db.updateRow(
      session,
      product.copyWith(
        categoryId: resolvedCategoryId,
        name: input.name.trim(),
        description: input.description.trim(),
        price: input.price,
        materials: trimmedMaterials,
        widthCm: input.widthCm,
        depthCm: input.depthCm,
        heightCm: input.heightCm,
        weightKg: input.weightKg,
        assemblyNote: input.assemblyNote?.trim(),
        careInstructions: trimmedCare,
        warranty: input.warranty?.trim(),
        thumbnailUrl: thumbnailUrl?.trim(),
        status: input.isActive ? ProductStatus.active : ProductStatus.removed,
        removedReason: input.isActive
            ? (product.removedById == null ? null : product.removedReason)
            : 'Hidden by vendor',
        removedById: input.isActive ? product.removedById : null,
        removedAt: input.isActive
            ? (product.removedById == null ? null : product.removedAt)
            : DateTime.now(),
      ),
    );

    if (input.generateModel3d) {
      updated = await _generateAndStoreModel3d(
        session,
        updated,
        skipIfExists: false,
        throwOnFailure: false,
      );
    }

    return _loadProductWithCategory(session, updated);
  }

  Future<Product> _loadProductWithCategory(
    Session session,
    Product product,
  ) async {
    final productId = product.id;
    if (productId == null) return product;

    final loaded = await Product.db.findById(
      session,
      productId,
      include: Product.include(category: Category.include()),
    );
    return loaded ?? product;
  }

  Future<Product> _generateAndStoreModel3d(
    Session session,
    Product product, {
    bool skipIfExists = true,
    bool throwOnFailure = false,
  }) async {
    if (skipIfExists &&
        product.model3dUrl != null &&
        product.model3dUrl!.trim().isNotEmpty) {
      return product;
    }

    final generator = Product3dGenerator();
    final result = await generator.generateForProduct(
      session,
      product: product,
    );

    if (result is Product3dGenerationSuccess) {
      return Product.db.updateRow(
        session,
        product.copyWith(model3dUrl: result.modelUrl),
      );
    }
    if (result is Product3dGenerationFailure) {
      if (throwOnFailure) {
        throw PlaceifyException(
          message: result.message,
          code: result.code,
        );
      }
      session.log(
        '3D generation skipped for product ${product.id}: ${result.code}',
        level: LogLevel.warning,
      );
      return product;
    }

    if (throwOnFailure) {
      throw PlaceifyException(
        message: '3D model generation returned an unknown result.',
        code: 'MODEL3D_GENERATION_FAILED',
      );
    }
    return product;
  }

  /// Generates a 3D model for an existing vendor product via Tripo API.
  Future<Product> regenerateProductModel3d(
    Session session,
    int productId,
  ) async {
    final vendor = await requireOwnedVendor(session);
    final product = await Product.db.findById(session, productId);
    if (product == null || product.vendorId != vendor.id) {
      throw PlaceifyException(
        message: 'Product not found.',
        code: 'PRODUCT_NOT_FOUND',
      );
    }
    return _generateAndStoreModel3d(
      session,
      product,
      skipIfExists: false,
      throwOnFailure: true,
    );
  }

  Future<Product> updateProductThumbnail(
    Session session,
    int productId,
    String thumbnailUrl,
  ) async {
    final vendor = await requireVendorProfile(session);
    final product = await Product.db.findById(session, productId);
    if (product == null || product.vendorId != vendor.id) {
      throw PlaceifyException(message: 'Product not found.', code: 'PRODUCT_NOT_FOUND');
    }

    return Product.db.updateRow(
      session,
      product.copyWith(thumbnailUrl: thumbnailUrl.trim()),
    );
  }

  Future<String> uploadProductImage(
    Session session,
    ByteData fileData,
    String fileName,
  ) async {
    await requireOwnedVendor(session);
    return _persistProductImage(session, fileData, fileName);
  }

  Future<String> _persistProductImage(
    Session session,
    ByteData fileData,
    String fileName,
  ) async {
    final bytes = fileData.buffer.asUint8List(
      fileData.offsetInBytes,
      fileData.lengthInBytes,
    );
    if (bytes.isEmpty) {
      throw PlaceifyException(message: 'Image file is empty.', code: 'INVALID_FILE');
    }
    if (bytes.length > 8 * 1024 * 1024) {
      throw PlaceifyException(message: 'Image must be 8 MB or smaller.',
        code: 'FILE_TOO_LARGE',
      );
    }

    final sanitized = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final extension =
        _imageExtension(sanitized) ?? _imageExtensionFromBytes(bytes);
    if (extension == null) {
      throw PlaceifyException(
        message: 'Use a JPG, PNG, or WEBP image.',
        code: 'INVALID_FILE_TYPE',
      );
    }

    final processor = ProductImageProcessor();
    final processed = await processor.processForCatalog(
      session,
      bytes,
      sanitized,
    );

    final uploadsDir = Directory(ServerStaticPaths.uploadsDir());
    if (!uploadsDir.existsSync()) {
      uploadsDir.createSync(recursive: true);
    }

    final baseName = sanitized.replaceAll(RegExp(r'\.[^.]+$'), '');
    final storedName =
        '${DateTime.now().millisecondsSinceEpoch}_$baseName${processed.extension}';
    final file = File(
      '${uploadsDir.path}${Platform.pathSeparator}$storedName',
    );
    await file.writeAsBytes(processed.bytes);
    session.log(
      'Stored catalog image $storedName (white background, '
      'bgRemoved=${processed.backgroundRemoved})',
      level: LogLevel.info,
    );

    final tripoRelativePath = Product3dImagePaths.tripoStoragePathForCatalog(
      catalogStoragePath: '/uploads/$storedName',
      originalExtension: extension,
    );
    if (tripoRelativePath.isNotEmpty) {
      final tripoFile = ServerStaticPaths.fileFromUrlPath(tripoRelativePath);
      await tripoFile.parent.create(recursive: true);
      await tripoFile.writeAsBytes(bytes);
      session.log(
        'Stored Tripo source ${tripoFile.uri.pathSegments.last} '
        '(${bytes.length} bytes, original upload)',
        level: LogLevel.info,
      );
    }

    return '/uploads/$storedName';
  }

  String? _imageExtension(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return '.jpg';
    if (lower.endsWith('.png')) return '.png';
    if (lower.endsWith('.webp')) return '.webp';
    if (lower.endsWith('.heic')) return '.heic';
    return null;
  }

  String? _imageExtensionFromBytes(Uint8List bytes) {
    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      return '.jpg';
    }
    if (bytes.length >= 4 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return '.png';
    }
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return '.webp';
    }
    return null;
  }

  Future<List<VendorShopOrder>> listShopOrders(
    Session session, {
    int limit = 50,
    int offset = 0,
    OrderStatus? status,
  }) async {
    final vendor = await requireOwnedVendor(session);
    final orderItems = await _loadVendorOrderItems(session, vendor.id!);
    final orders = _groupVendorShopOrders(orderItems);

    final filtered = status == null
        ? orders
        : orders.where((order) => order.status == status).toList();

    if (offset >= filtered.length) return [];
    final end = offset + limit;
    return filtered.sublist(
      offset,
      end > filtered.length ? filtered.length : end,
    );
  }

  Future<VendorShopOrder> getShopOrder(Session session, int orderId) async {
    final vendor = await requireOwnedVendor(session);
    final orderItems = await OrderItem.db.find(
      session,
      where: (row) =>
          row.vendorId.equals(vendor.id!) & row.orderId.equals(orderId),
      include: OrderItem.include(
        order: Order.include(user: User.include()),
        product: Product.include(),
      ),
      orderBy: (row) => row.id,
    );

    if (orderItems.isEmpty) {
      throw PlaceifyException(message: 'Order not found.', code: 'ORDER_NOT_FOUND');
    }

    final orders = _groupVendorShopOrders(orderItems);
    if (orders.isEmpty) {
      throw PlaceifyException(message: 'Order not found.', code: 'ORDER_NOT_FOUND');
    }
    return orders.first;
  }

  Future<VendorShopOrder> acceptShopOrder(Session session, int orderId) async {
    final vendor = await requireOwnedVendor(session);
    final order = await _requireMutableVendorOrder(session, vendor.id!, orderId);

    if (order.status != OrderStatus.pending) {
      throw PlaceifyException(
        message: 'Only pending orders can be accepted.',
        code: 'INVALID_ORDER_STATUS',
      );
    }

    final now = DateTime.now();
    await Order.db.updateRow(
      session,
      order.copyWith(
        status: OrderStatus.accepted,
        rejectionReason: null,
        updatedAt: now,
      ),
    );

    final existingUpdates = await _deliveryUpdatesFor(session, vendor.id!, orderId);
    if (existingUpdates.isEmpty) {
      await OrderDeliveryUpdate.db.insertRow(
        session,
        OrderDeliveryUpdate(
          orderId: orderId,
          vendorId: vendor.id!,
          stage: DeliveryStage.orderPlaced,
          note: 'Order confirmed by vendor.',
          createdAt: now,
        ),
      );
    }

    return getShopOrder(session, orderId);
  }

  Future<VendorShopOrder> rejectShopOrder(
    Session session,
    int orderId,
    String reason,
  ) async {
    final vendor = await requireOwnedVendor(session);
    final trimmedReason = reason.trim();
    if (trimmedReason.isEmpty) {
      throw PlaceifyException(
        message: 'A rejection reason is required.',
        code: 'INVALID_REJECTION_REASON',
      );
    }

    final order = await _requireMutableVendorOrder(session, vendor.id!, orderId);
    if (order.status != OrderStatus.pending) {
      throw PlaceifyException(
        message: 'Only pending orders can be rejected.',
        code: 'INVALID_ORDER_STATUS',
      );
    }

    await Order.db.updateRow(
      session,
      order.copyWith(
        status: OrderStatus.rejected,
        rejectionReason: trimmedReason,
        updatedAt: DateTime.now(),
      ),
    );

    return getShopOrder(session, orderId);
  }

  Future<List<OrderDeliveryUpdate>> listDeliveryUpdates(
    Session session,
    int orderId,
  ) async {
    final vendor = await requireOwnedVendor(session);
    await _assertVendorOwnsOrder(session, vendor.id!, orderId);
    return _deliveryUpdatesFor(session, vendor.id!, orderId);
  }

  Future<OrderDeliveryUpdate> submitDeliveryUpdate(
    Session session,
    int orderId,
    DeliveryStage stage, {
    String? note,
    String? photoUrl,
  }) async {
    final vendor = await requireOwnedVendor(session);
    final order = await _requireMutableVendorOrder(session, vendor.id!, orderId);

    if (order.status == OrderStatus.pending) {
      throw PlaceifyException(
        message: 'Accept the order before posting delivery updates.',
        code: 'ORDER_NOT_ACCEPTED',
      );
    }

    if (order.status == OrderStatus.rejected ||
        order.status == OrderStatus.cancelled) {
      throw PlaceifyException(
        message: 'Delivery updates are not available for this order.',
        code: 'INVALID_ORDER_STATUS',
      );
    }

    if (order.status == OrderStatus.delivered) {
      throw PlaceifyException(
        message: 'This order is already delivered.',
        code: 'ORDER_ALREADY_DELIVERED',
      );
    }

    final existing = await _deliveryUpdatesFor(session, vendor.id!, orderId);
    final expected = _nextDeliveryStage(existing);
    if (expected == null) {
      throw PlaceifyException(
        message: 'All delivery stages are complete.',
        code: 'DELIVERY_COMPLETE',
      );
    }

    if (stage != expected) {
      throw PlaceifyException(
        message:
            'Updates must advance one stage at a time. Next stage: ${_stageLabel(expected)}.',
        code: 'INVALID_DELIVERY_STAGE',
      );
    }

    if (existing.any((update) => update.stage == stage)) {
      throw PlaceifyException(
        message: 'This delivery stage was already recorded.',
        code: 'DUPLICATE_DELIVERY_STAGE',
      );
    }

    final now = DateTime.now();
    final update = await OrderDeliveryUpdate.db.insertRow(
      session,
      OrderDeliveryUpdate(
        orderId: orderId,
        vendorId: vendor.id!,
        stage: stage,
        note: note?.trim(),
        photoUrl: photoUrl?.trim(),
        createdAt: now,
      ),
    );

    await Order.db.updateRow(
      session,
      order.copyWith(
        status: _statusForDeliveryStage(stage),
        updatedAt: now,
      ),
    );

    return update;
  }

  Future<String> uploadDeliveryProof(
    Session session,
    ByteData fileData,
    String fileName,
  ) async {
    await requireOwnedVendor(session);
    return _persistProductImage(session, fileData, fileName);
  }

  Future<Order> _requireMutableVendorOrder(
    Session session,
    UuidValue vendorId,
    int orderId,
  ) async {
    await _assertVendorOwnsOrder(session, vendorId, orderId);
    final order = await Order.db.findById(session, orderId);
    if (order == null) {
      throw PlaceifyException(message: 'Order not found.', code: 'ORDER_NOT_FOUND');
    }
    return order;
  }

  Future<void> _assertVendorOwnsOrder(
    Session session,
    UuidValue vendorId,
    int orderId,
  ) async {
    final ownsOrder = await OrderItem.db.findFirstRow(
      session,
      where: (row) =>
          row.vendorId.equals(vendorId) & row.orderId.equals(orderId),
    );
    if (ownsOrder == null) {
      throw PlaceifyException(message: 'Order not found.', code: 'ORDER_NOT_FOUND');
    }
  }

  Future<List<OrderDeliveryUpdate>> _deliveryUpdatesFor(
    Session session,
    UuidValue vendorId,
    int orderId,
  ) {
    return OrderDeliveryUpdate.db.find(
      session,
      where: (row) =>
          row.vendorId.equals(vendorId) & row.orderId.equals(orderId),
      orderBy: (row) => row.createdAt,
    );
  }

  DeliveryStage? _nextDeliveryStage(List<OrderDeliveryUpdate> existing) {
    if (existing.isEmpty) return DeliveryStage.orderPlaced;

    var maxIndex = -1;
    for (final update in existing) {
      final index = DeliveryStage.values.indexOf(update.stage);
      if (index > maxIndex) maxIndex = index;
    }

    final nextIndex = maxIndex + 1;
    if (nextIndex >= DeliveryStage.values.length) return null;
    return DeliveryStage.values[nextIndex];
  }

  OrderStatus _statusForDeliveryStage(DeliveryStage stage) {
    return switch (stage) {
      DeliveryStage.orderPlaced => OrderStatus.accepted,
      DeliveryStage.packed => OrderStatus.processing,
      DeliveryStage.shipped => OrderStatus.shipped,
      DeliveryStage.outForDelivery => OrderStatus.shipped,
      DeliveryStage.delivered => OrderStatus.delivered,
    };
  }

  String _stageLabel(DeliveryStage stage) {
    return switch (stage) {
      DeliveryStage.orderPlaced => 'Order placed',
      DeliveryStage.packed => 'Packed',
      DeliveryStage.shipped => 'Shipped',
      DeliveryStage.outForDelivery => 'Out for delivery',
      DeliveryStage.delivered => 'Delivered',
    };
  }

  Future<List<OrderItem>> _loadVendorOrderItems(
    Session session,
    UuidValue vendorId,
  ) {
    return OrderItem.db.find(
      session,
      where: (row) => row.vendorId.equals(vendorId),
      include: OrderItem.include(
        order: Order.include(user: User.include()),
        product: Product.include(),
      ),
      orderDescending: true,
      orderBy: (row) => row.id,
    );
  }

  List<VendorShopOrder> _groupVendorShopOrders(List<OrderItem> orderItems) {
    final grouped = <int, List<OrderItem>>{};
    for (final item in orderItems) {
      grouped.putIfAbsent(item.orderId, () => []).add(item);
    }

    final orders = <VendorShopOrder>[];
    for (final entry in grouped.entries) {
      final items = entry.value;
      final order = items.first.order;
      if (order == null) continue;

      final lineItems = <VendorOrderLineItem>[
        for (final item in items)
          if (item.id != null)
            VendorOrderLineItem(
              orderItemId: item.id!,
              productId: item.productId,
              productName: item.product?.name ?? 'Product',
              quantity: item.quantity,
              unitPrice: item.unitPrice,
              lineTotal: item.unitPrice * item.quantity,
              thumbnailUrl: item.product?.thumbnailUrl,
            ),
      ];

      final vendorTotal = lineItems.fold<double>(
        0,
        (sum, item) => sum + item.lineTotal,
      );
      final itemCount = lineItems.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );

      orders.add(
        VendorShopOrder(
          orderId: entry.key,
          orderNumber: entry.key.toString().padLeft(5, '0'),
          status: order.status,
          placedAt: order.placedAt,
          customerName: order.user?.name ?? 'Customer',
          shippingAddress: order.shippingAddress,
          vendorTotal: vendorTotal,
          itemCount: itemCount,
          items: lineItems,
          rejectionReason: order.rejectionReason,
        ),
      );
    }

    orders.sort((a, b) => b.placedAt.compareTo(a.placedAt));
    return orders;
  }
}
