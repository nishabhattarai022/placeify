import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/server_static_paths.dart';
import '../../shared/session_service.dart';
import 'product_3d/product_3d_generation_result.dart';
import 'product_3d/product_3d_generator.dart';
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

    if (user.role != UserRole.vendor && user.role != UserRole.admin) {
      await User.db.updateRow(
        session,
        user.copyWith(role: UserRole.vendor),
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
      ),
    );

    return Vendor.db.insertRow(
      session,
      Vendor(
        userId: user.id!,
        shopName: trimmedName,
        description: trimmedDescription,
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
      ),
    );
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
        status: ProductStatus.active,
      ),
    );
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

    final generator = const Product3dGenerator();
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
        ),
      );
    }

    orders.sort((a, b) => b.placedAt.compareTo(a.placedAt));
    return orders;
  }
}
