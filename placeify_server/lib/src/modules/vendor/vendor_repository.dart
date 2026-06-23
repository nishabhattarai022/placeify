import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/server_static_paths.dart';
import '../../shared/session_service.dart';
import '../notification/in_app_notification_store.dart';
import '../notification/notification_repository.dart';
import '../notification/order_notification_service.dart';
import '../order/order_lifecycle_store.dart';
import 'product_3d/product_3d_generation_result.dart';
import 'product_3d/product_3d_generator.dart';
import 'product_3d/product_3d_views.dart';
import 'product_image_processor.dart';
import 'vendor_bank_details_validation.dart';
import 'vendor_document_storage.dart';
import 'vendor_profile_audit_log.dart';
import 'vendor_profile_mapper.dart';
import 'vendor_profile_validation.dart';
import 'vendor_sales_metrics.dart';
import 'vendor_shop_category_codec.dart';

class VendorStore {
  VendorStore({InAppNotificationStore? notifications})
      : _notifications = notifications ?? InAppNotificationStore();

  final InAppNotificationStore _notifications;
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
    final deliveredOrderIds = VendorSalesMetricsCalculator.deliveredItems(
      orderItems,
    ).map((item) => item.orderId).toSet();
    final refundedOrderIds =
        await _loadCompletedRefundOrderIds(session, deliveredOrderIds);
    final sales = VendorSalesMetricsCalculator.compute(
      orderItems: orderItems,
      completedRefundOrderIds: refundedOrderIds,
    );

    final productSales = <int, ({String name, int units, double revenue})>{};
    for (final item in sales.deliveredItems) {
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
      orderCount: sales.deliveredOrderCount,
      revenue: sales.netRevenue,
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
    String? city,
    String? country,
    String? shopCategory,
    String? contactEmail,
    VendorBankDetailsInput? bankDetails,
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
      throw PlaceifyException(
        message: 'Shop name is required.',
        code: 'INVALID_SHOP_NAME',
      );
    }
    if (trimmedDescription == null || trimmedDescription.isEmpty) {
      throw PlaceifyException(
        message: 'Shop description is required.',
        code: 'INVALID_DESCRIPTION',
      );
    }

    final trimmedPhone = phone?.trim();
    if (trimmedPhone == null || trimmedPhone.isEmpty) {
      throw PlaceifyException(
        message: 'Phone number is required.',
        code: 'INVALID_PHONE',
      );
    }

    final trimmedAddress = address?.trim();
    if (trimmedAddress == null || trimmedAddress.isEmpty) {
      throw PlaceifyException(
        message: 'Shop address is required.',
        code: 'MISSING_REQUIRED_FIELD',
      );
    }

    final trimmedCategory = shopCategory?.trim();
    if (trimmedCategory == null || trimmedCategory.isEmpty) {
      throw PlaceifyException(
        message: 'A shop category is required.',
        code: 'MISSING_REQUIRED_FIELD',
      );
    }
    if (VendorShopCategoryCodec.decode(trimmedCategory).isEmpty) {
      throw PlaceifyException(
        message: 'A shop category is required.',
        code: 'MISSING_REQUIRED_FIELD',
      );
    }
    final normalizedCategory = VendorShopCategoryCodec.normalize(trimmedCategory);

    final trimmedContactEmail = contactEmail?.trim();
    if (trimmedContactEmail != null && trimmedContactEmail.isNotEmpty) {
      VendorProfileValidation.validateEmail(trimmedContactEmail);
    }

    VendorProfileValidation.validateUpdate(
      businessName: trimmedName,
      phone: trimmedPhone,
      address: trimmedAddress,
      city: city,
      country: country,
      bio: trimmedDescription,
    );

    await _requireRegistrationDocuments(session, user.id!);

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

    final vendor = await Vendor.db.insertRow(
      session,
      Vendor(
        userId: user.id!,
        shopName: trimmedName,
        description: trimmedDescription,
        businessAddress: trimmedAddress,
        city: _nullableTrim(city),
        country: _nullableTrim(country),
        shopCategory: normalizedCategory,
        contactEmail: _nullableTrim(contactEmail),
        logoUrl: logoUrl?.trim(),
      ),
    );

    await _linkPendingDocuments(session, user.id!, vendor.id!);
    if (bankDetails != null) {
      await _upsertBankDetails(session, vendor.id!, bankDetails);
    }
    return vendor;
  }

  Future<VendorBankDetails?> getMyBankDetails(Session session) async {
    final vendor = await requireOwnedVendor(session);
    return VendorBankDetails.db.findFirstRow(
      session,
      where: (row) => row.vendorId.equals(vendor.id!),
    );
  }

  Future<VendorBankDetails> saveMyBankDetails(
    Session session,
    VendorBankDetailsInput input,
  ) async {
    final vendor = await requireOwnedVendor(session);
    return _upsertBankDetails(session, vendor.id!, input);
  }

  Future<VendorBankDetails> _upsertBankDetails(
    Session session,
    UuidValue vendorId,
    VendorBankDetailsInput input,
  ) async {
    VendorBankDetailsValidation.validateInput(input);

    final now = DateTime.now();
    final normalized = VendorBankDetails(
      vendorId: vendorId,
      accountHolderName: input.accountHolderName.trim(),
      bankName: input.bankName.trim(),
      accountNumber: input.accountNumber.trim(),
      branchCode: input.branchCode.trim(),
      updatedAt: now,
    );

    final existing = await VendorBankDetails.db.findFirstRow(
      session,
      where: (row) => row.vendorId.equals(vendorId),
    );

    if (existing != null) {
      return VendorBankDetails.db.updateRow(
        session,
        existing.copyWith(
          accountHolderName: normalized.accountHolderName,
          bankName: normalized.bankName,
          accountNumber: normalized.accountNumber,
          branchCode: normalized.branchCode,
          updatedAt: now,
        ),
      );
    }

    return VendorBankDetails.db.insertRow(
      session,
      normalized.copyWith(createdAt: now),
    );
  }

  /// Uploads a verification document for the logged-in user (before or after shop creation).
  Future<String> uploadDocument(
    Session session,
    VendorDocumentType documentType,
    ByteData fileData,
    String fileName,
  ) async {
    final user = await SessionService.requireUser(session);
    final vendor = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(user.id!),
    );

    if (vendor != null && vendor.userId != user.id) {
      throw PlaceifyException(
        message: 'You can only upload documents for your own shop.',
        code: 'UNAUTHORIZED',
      );
    }

    final ownerSegment =
        vendor?.id?.toString() ?? 'user_${user.id.toString()}';
    final fileUrl = await VendorDocumentStorage.persist(
      session: session,
      ownerSegment: ownerSegment,
      fileData: fileData,
      fileName: fileName,
    );

    final existing = await VendorDocument.db.findFirstRow(
      session,
      where: (row) =>
          row.userId.equals(user.id!) &
          row.documentType.equals(documentType),
    );

    if (existing != null) {
      await VendorDocument.db.updateRow(
        session,
        existing.copyWith(
          fileUrl: fileUrl,
          vendorId: vendor?.id ?? existing.vendorId,
        ),
      );
    } else {
      await VendorDocument.db.insertRow(
        session,
        VendorDocument(
          userId: user.id!,
          vendorId: vendor?.id,
          documentType: documentType,
          fileUrl: fileUrl,
        ),
      );
    }

    session.log(
      'vendor_document_upload userId=${user.id} type=$documentType',
      level: LogLevel.info,
    );

    return fileUrl;
  }

  Future<void> _linkPendingDocuments(
    Session session,
    UuidValue userId,
    UuidValue vendorId,
  ) async {
    final documents = await VendorDocument.db.find(
      session,
      where: (row) => row.userId.equals(userId),
    );

    for (final document in documents) {
      if (document.vendorId == vendorId) continue;
      await VendorDocument.db.updateRow(
        session,
        document.copyWith(vendorId: vendorId),
      );
    }
  }

  Future<void> _requireRegistrationDocuments(
    Session session,
    UuidValue userId,
  ) async {
    const requiredTypes = [
      VendorDocumentType.businessLicense,
      VendorDocumentType.governmentId,
    ];

    for (final type in requiredTypes) {
      final document = await VendorDocument.db.findFirstRow(
        session,
        where: (row) =>
            row.userId.equals(userId) & row.documentType.equals(type),
      );
      if (document == null || document.fileUrl.trim().isEmpty) {
        throw PlaceifyException(
          message: 'Upload all required verification documents before submitting.',
          code: 'MISSING_REQUIRED_FIELD',
        );
      }
    }
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
    return _loadProfileDetail(session, vendor, includeNotificationPrefs: true);
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

    return _loadProfileDetail(session, vendor, user: user);
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
    final phone = input.phone?.trim();
    final address = input.address?.trim();
    final city = input.city?.trim();
    final country = input.country?.trim();
    final bio = input.bio?.trim();
    final email = input.email?.trim();

    VendorProfileValidation.validateUpdate(
      businessName: businessName,
      phone: phone,
      address: address,
      city: city,
      country: country,
      bio: bio,
    );
    if (email != null) {
      VendorProfileValidation.validateEmail(email);
    }

    String? normalizedCategory;
    if (input.category != null) {
      final trimmedCategory = input.category!.trim();
      if (trimmedCategory.isEmpty) {
        throw PlaceifyException(
          message: 'A shop category is required.',
          code: 'MISSING_REQUIRED_FIELD',
        );
      }
      if (VendorShopCategoryCodec.decode(trimmedCategory).isEmpty) {
        throw PlaceifyException(
          message: 'A shop category is required.',
          code: 'MISSING_REQUIRED_FIELD',
        );
      }
      normalizedCategory = VendorShopCategoryCodec.normalize(trimmedCategory);
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
        description: bio ?? vendor.description,
        businessAddress: address ?? vendor.businessAddress,
        city: city ?? vendor.city,
        country: country ?? vendor.country,
        shopCategory: normalizedCategory ?? vendor.shopCategory,
        contactEmail: email ?? vendor.contactEmail,
        logoUrl: _nullableTrim(input.logoUrl) ?? vendor.logoUrl,
        bannerUrl: _nullableTrim(input.bannerUrl) ?? vendor.bannerUrl,
        coverUrl: _nullableTrim(input.coverUrl) ?? vendor.coverUrl,
        instagramHandle:
            input.instagramHandle?.trim() ?? vendor.instagramHandle,
        facebookHandle: input.facebookHandle?.trim() ?? vendor.facebookHandle,
        operatingHours: input.operatingHours?.trim() ?? vendor.operatingHours,
        isOpen: input.isOpen ?? vendor.isOpen,
        updatedAt: now,
      ),
    );

    VendorProfileAuditLog.profileUpdated(
      session,
      vendorId: updatedVendor.id!,
      action: 'profile_update',
    );

    return _loadProfileDetail(
      session,
      updatedVendor,
      user: updatedUser,
      includeNotificationPrefs: true,
    );
  }

  Future<String> uploadShopLogo(
    Session session,
    ByteData fileData,
    String fileName,
  ) async {
    final vendor = await requireOwnedVendor(session);
    final logoUrl = await _persistProductImage(
      session,
      fileData,
      fileName,
      removeBackground: false,
    );
    await Vendor.db.updateRow(
      session,
      vendor.copyWith(logoUrl: logoUrl, updatedAt: DateTime.now()),
    );
    VendorProfileAuditLog.logoUploaded(session, vendor.id!);
    return logoUrl;
  }

  Future<String> uploadShopBanner(
    Session session,
    ByteData fileData,
    String fileName,
  ) async {
    final vendor = await requireOwnedVendor(session);
    final bannerUrl = await _persistProductImage(
      session,
      fileData,
      fileName,
      removeBackground: false,
    );
    await Vendor.db.updateRow(
      session,
      vendor.copyWith(bannerUrl: bannerUrl, updatedAt: DateTime.now()),
    );
    VendorProfileAuditLog.bannerUploaded(session, vendor.id!);
    return bannerUrl;
  }

  /// Stores the shop cover image and updates the vendor profile record.
  Future<String> uploadShopCover(
    Session session,
    ByteData fileData,
    String fileName,
  ) async {
    final vendor = await requireOwnedVendor(session);
    final coverUrl = await _persistProductImage(
      session,
      fileData,
      fileName,
      removeBackground: false,
    );
    await Vendor.db.updateRow(
      session,
      vendor.copyWith(coverUrl: coverUrl, updatedAt: DateTime.now()),
    );
    VendorProfileAuditLog.coverUploaded(session, vendor.id!);
    return coverUrl;
  }

  Future<VendorProfileDetail> _loadProfileDetail(
    Session session,
    Vendor vendor, {
    User? user,
    bool includeNotificationPrefs = false,
  }) async {
    final resolvedUser =
        user ?? await User.db.findById(session, vendor.userId);
    if (resolvedUser == null) {
      throw PlaceifyException(
        message: 'User account not found.',
        code: 'USER_NOT_FOUND',
      );
    }

    final metrics = await _loadVendorMetrics(session, vendor.id!);
    NotificationPreference? notificationPreferences;
    if (includeNotificationPrefs) {
      notificationPreferences =
          await NotificationStore().getPreferences(session);
    }

    return VendorProfileMapper.toDetail(
      vendor: vendor,
      user: resolvedUser,
      metrics: metrics,
      notificationPreferences: notificationPreferences,
    );
  }

  /// Loads product and delivered-order sales aggregates for profile metrics.
  Future<VendorProfileMetrics> _loadVendorMetrics(
    Session session,
    UuidValue vendorId,
  ) async {
    final totalProducts = await Product.db.count(
      session,
      where: (row) => row.vendorId.equals(vendorId),
    );

    final sales = await _loadVendorSalesMetrics(session, vendorId);

    return (
      totalProducts: totalProducts,
      totalOrders: sales.deliveredOrderCount,
      totalRevenue: sales.netRevenue,
    );
  }

  /// Loads vendor order lines with parent order status in a single query.
  Future<VendorSalesMetrics> _loadVendorSalesMetrics(
    Session session,
    UuidValue vendorId,
  ) async {
    final orderItems = await OrderItem.db.find(
      session,
      where: (row) => row.vendorId.equals(vendorId),
      include: OrderItem.include(order: Order.include()),
    );

    final deliveredOrderIds = VendorSalesMetricsCalculator.deliveredItems(
      orderItems,
    ).map((item) => item.orderId).toSet();

    final refundedOrderIds =
        await _loadCompletedRefundOrderIds(session, deliveredOrderIds);

    return VendorSalesMetricsCalculator.compute(
      orderItems: orderItems,
      completedRefundOrderIds: refundedOrderIds,
    );
  }

  /// Returns order IDs with completed refunds that belong to [orderIds].
  Future<Set<int>> _loadCompletedRefundOrderIds(
    Session session,
    Set<int> orderIds,
  ) async {
    if (orderIds.isEmpty) return {};

    final refunds = await RefundRequest.db.find(
      session,
      where: (row) => row.status.equals(RequestStatus.completed),
    );

    return refunds
        .where((refund) => orderIds.contains(refund.orderId))
        .map((refund) => refund.orderId)
        .toSet();
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
        viewImageUrls: _normalizeViewImageUrls(viewImageUrls),
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
      removeBackground: true,
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
        removeBackground: true,
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
        viewImageUrls: input.viewImageUrls != null
            ? _normalizeViewImageUrls(input.viewImageUrls)
            : product.viewImageUrls,
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
    String fileName, {
    bool removeBackground = false,
  }) async {
    await requireOwnedVendor(session);
    return _persistProductImage(
      session,
      fileData,
      fileName,
      removeBackground: removeBackground,
    );
  }

  Future<String> _persistProductImage(
    Session session,
    ByteData fileData,
    String fileName, {
    required bool removeBackground,
  }) async {
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
    final uploadsDir = Directory(ServerStaticPaths.uploadsDir());
    if (!uploadsDir.existsSync()) {
      uploadsDir.createSync(recursive: true);
    }

    final baseName = sanitized.replaceAll(RegExp(r'\.[^.]+$'), '');
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    if (removeBackground) {
      final processed = await processor.processForVendorUpload(
        session,
        bytes,
        sanitized,
        fileExtension: extension,
      );

      final storedName = '${timestamp}_$baseName${processed.catalog.extension}';
      final tripoStoredName =
          '${timestamp}_${baseName}_tripo${processed.tripoSource.extension}';

      await File(
        '${uploadsDir.path}${Platform.pathSeparator}$storedName',
      ).writeAsBytes(processed.catalog.bytes);
      await File(
        '${uploadsDir.path}${Platform.pathSeparator}$tripoStoredName',
      ).writeAsBytes(processed.tripoSource.bytes);

      session.log(
        'Stored catalog thumbnail $storedName and Tripo raw $tripoStoredName',
        level: LogLevel.info,
      );
      return '/uploads/$storedName';
    }

    final storedName = '${timestamp}_$baseName$extension';
    await File(
      '${uploadsDir.path}${Platform.pathSeparator}$storedName',
    ).writeAsBytes(bytes);
    session.log(
      'Stored raw product photo $storedName (${bytes.length} bytes, no bg removal)',
      level: LogLevel.info,
    );
    return '/uploads/$storedName';
  }

  /// Keeps Tripo view order [left, back, right].
  List<String>? _normalizeViewImageUrls(List<String>? urls) {
    if (urls == null || urls.isEmpty) return null;

    final normalized = urls
        .take(Product3dViews.extraSlotCount)
        .map((url) => url.trim())
        .toList(growable: false);
    if (normalized.every((url) => url.isEmpty)) return null;

    final trimmed = List<String>.from(normalized);
    while (trimmed.isNotEmpty && trimmed.last.isEmpty) {
      trimmed.removeLast();
    }
    return trimmed.isEmpty ? null : trimmed;
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
    final user = await SessionService.requireUser(session);
    final order = await _requireMutableVendorOrder(session, vendor.id!, orderId);

    if (order.status != OrderStatus.pending &&
        order.status != OrderStatus.confirmed) {
      throw PlaceifyException(
        message: 'Only pending orders can be accepted.',
        code: 'INVALID_ORDER_STATUS',
      );
    }

    await session.db.transaction((transaction) async {
      final accepted = await OrderLifecycleStore.updateOrderWithVersion(
        session,
        order,
        (current) => current.copyWith(
          status: OrderStatus.accepted,
          rejectionReason: null,
        ),
        transaction: transaction,
      );

      await OrderLifecycleStore.appendHistory(
        session,
        orderId,
        statusType: OrderStatusHistoryType.order,
        previousStatus: order.status.name,
        newStatus: OrderStatus.accepted.name,
        changedByUserId: user.id,
        transaction: transaction,
      );

      final existingUpdates = await OrderDeliveryUpdate.db.find(
        session,
        where: (row) =>
            row.orderId.equals(orderId) & row.vendorId.equals(vendor.id!),
        transaction: transaction,
      );
      if (existingUpdates.isEmpty) {
        await OrderDeliveryUpdate.db.insertRow(
          session,
          OrderDeliveryUpdate(
            orderId: orderId,
            vendorId: vendor.id!,
            stage: DeliveryStage.orderPlaced,
            note: 'Order confirmed by vendor.',
          ),
          transaction: transaction,
        );
      }

      await OrderNotificationService.notifyOrderAccepted(
        session,
        order: accepted,
        vendorId: vendor.id!,
      );
    });

    return getShopOrder(session, orderId);
  }

  Future<VendorShopOrder> rejectShopOrder(
    Session session,
    int orderId,
    String reason,
  ) async {
    final vendor = await requireOwnedVendor(session);
    final user = await SessionService.requireUser(session);
    final trimmedReason = reason.trim();
    if (trimmedReason.isEmpty) {
      throw PlaceifyException(
        message: 'A rejection reason is required.',
        code: 'INVALID_REJECTION_REASON',
      );
    }

    final order = await _requireMutableVendorOrder(session, vendor.id!, orderId);
    if (order.status != OrderStatus.pending &&
        order.status != OrderStatus.confirmed) {
      throw PlaceifyException(
        message: 'Only pending orders can be rejected.',
        code: 'INVALID_ORDER_STATUS',
      );
    }

    await session.db.transaction((transaction) async {
      final rejected = await OrderLifecycleStore.updateOrderWithVersion(
        session,
        order,
        (current) => current.copyWith(
          status: OrderStatus.rejected,
          rejectionReason: trimmedReason,
        ),
        transaction: transaction,
      );

      await OrderLifecycleStore.appendHistory(
        session,
        orderId,
        statusType: OrderStatusHistoryType.order,
        previousStatus: order.status.name,
        newStatus: OrderStatus.rejected.name,
        changedByUserId: user.id,
        note: trimmedReason,
        transaction: transaction,
      );

      await OrderNotificationService.notifyOrderRejected(
        session,
        order: rejected,
        reason: trimmedReason,
      );
    });

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
    final user = await SessionService.requireUser(session);
    final order = await _requireMutableVendorOrder(session, vendor.id!, orderId);

    if (order.status == OrderStatus.pending ||
        order.status == OrderStatus.confirmed) {
      throw PlaceifyException(
        message: 'Accept the order before posting delivery updates.',
        code: 'ORDER_NOT_ACCEPTED',
      );
    }

    if (order.status == OrderStatus.rejected ||
        order.status == OrderStatus.cancelled ||
        order.status == OrderStatus.autoCancelled) {
      throw PlaceifyException(
        message: 'Delivery updates are not available for this order.',
        code: 'INVALID_ORDER_STATUS',
      );
    }

    if (order.deliveryStatus == OrderDeliveryStatus.delivered) {
      throw PlaceifyException(
        message: 'This order is already delivered.',
        code: 'ORDER_ALREADY_DELIVERED',
      );
    }

    final nextDeliveryStatus = OrderLifecycleStore.deliveryStatusForStage(stage);
    if (nextDeliveryStatus == null) {
      throw PlaceifyException(
        message: 'This delivery stage cannot be applied.',
        code: 'INVALID_DELIVERY_STAGE',
      );
    }

    if (!OrderLifecycleStore.canAdvanceDeliveryStatus(
      order.deliveryStatus,
      nextDeliveryStatus,
    )) {
      throw PlaceifyException(
        message:
            'Delivery status can only move forward one step at a time.',
        code: 'INVALID_DELIVERY_STAGE',
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

    OrderDeliveryUpdate? update;
    await session.db.transaction((transaction) async {
      update = await OrderDeliveryUpdate.db.insertRow(
        session,
        OrderDeliveryUpdate(
          orderId: orderId,
          vendorId: vendor.id!,
          stage: stage,
          note: note?.trim(),
          photoUrl: photoUrl?.trim(),
        ),
        transaction: transaction,
      );

      final nextOrderStatus =
          OrderLifecycleStore.orderStatusForDelivery(nextDeliveryStatus);
      final updatedOrder = await OrderLifecycleStore.updateOrderWithVersion(
        session,
        order,
        (current) => current.copyWith(
          deliveryStatus: nextDeliveryStatus,
          status: nextOrderStatus,
        ),
        transaction: transaction,
      );

      await OrderLifecycleStore.appendHistory(
        session,
        orderId,
        statusType: OrderStatusHistoryType.delivery,
        previousStatus: order.deliveryStatus?.name,
        newStatus: nextDeliveryStatus.name,
        changedByUserId: user.id,
        note: note?.trim(),
        transaction: transaction,
      );

      if (order.status != nextOrderStatus) {
        await OrderLifecycleStore.appendHistory(
          session,
          orderId,
          statusType: OrderStatusHistoryType.order,
          previousStatus: order.status.name,
          newStatus: nextOrderStatus.name,
          changedByUserId: user.id,
          note: note?.trim(),
          transaction: transaction,
        );
      }

      await OrderNotificationService.notifyDeliveryStatus(
        session,
        order: updatedOrder,
        status: nextDeliveryStatus,
        vendorId: vendor.id!,
      );
    });

    return update!;
  }

  Future<String> uploadDeliveryProof(
    Session session,
    ByteData fileData,
    String fileName,
  ) async {
    await requireOwnedVendor(session);
    return _persistProductImage(
      session,
      fileData,
      fileName,
      removeBackground: false,
    );
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
          orderPaymentStatus: order.paymentStatus,
        ),
      );
    }

    orders.sort((a, b) => b.placedAt.compareTo(a.placedAt));
    return orders;
  }

  Future<List<VendorNotificationSummary>> listNotifications(
    Session session, {
    int limit = 50,
  }) async {
    final user = await SessionService.requireUser(session);
    final rows = await _notifications.listForUser(session, user.id!, limit: limit);

    return [
      for (final row in rows)
        VendorNotificationSummary(
          id: row.id.toString(),
          type: _vendorNotificationType(row.type),
          title: row.title,
          body: row.message,
          isRead: row.isRead,
          createdAt: row.createdAt,
          relatedId: row.referenceId?.toString(),
        ),
    ];
  }

  Future<void> markNotificationRead(Session session, int notificationId) async {
    final user = await SessionService.requireUser(session);
    await _notifications.markRead(session, user.id!, notificationId);
  }

  Future<void> markAllNotificationsRead(Session session) async {
    final user = await SessionService.requireUser(session);
    await _notifications.markAllRead(session, user.id!);
  }

  VendorNotificationType _vendorNotificationType(InAppNotificationType type) {
    return switch (type) {
      InAppNotificationType.orderPlaced => VendorNotificationType.order,
      InAppNotificationType.orderAccepted => VendorNotificationType.order,
      InAppNotificationType.orderCancelled => VendorNotificationType.order,
      InAppNotificationType.deliveryUpdate => VendorNotificationType.order,
      InAppNotificationType.paymentUpdate => VendorNotificationType.payment,
    };
  }

  Future<List<ShopListingSummary>> listApprovedShops(
    Session session, {
    String? query,
  }) async {
    final normalizedQuery = query?.trim().toLowerCase();
    final vendors = await Vendor.db.find(
      session,
      include: Vendor.include(user: User.include()),
      orderBy: (row) => row.shopName,
    );

    final activeProducts = await Product.db.find(
      session,
      where: (row) => row.status.equals(ProductStatus.active),
    );
    final productCountByVendor = <UuidValue, int>{};
    for (final product in activeProducts) {
      productCountByVendor.update(
        product.vendorId,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    final listings = <ShopListingSummary>[];
    for (final vendor in vendors) {
      final user = vendor.user;
      final vendorId = vendor.id;
      if (user == null || vendorId == null) continue;
      if (user.role != UserRole.vendor ||
          user.status != UserAccountStatus.approved ||
          !user.isActive) {
        continue;
      }

      final productCount = productCountByVendor[vendorId] ?? 0;

      final locality = vendor.city?.trim().isNotEmpty == true
          ? vendor.city!.trim()
          : _localityFromAddress(vendor.businessAddress);
      final tags = VendorShopCategoryCodec.decode(vendor.shopCategory);

      final listing = ShopListingSummary(
        vendorId: vendorId,
        businessName: vendor.shopName,
        locality: locality,
        tags: tags,
        logoUrl: vendor.logoUrl,
        bannerUrl: vendor.bannerUrl,
        productCount: productCount,
        averageRating: vendor.rating,
      );

      if (normalizedQuery != null && normalizedQuery.isNotEmpty) {
        final haystack =
            '${listing.businessName} ${listing.locality} ${tags.join(' ')}'
                .toLowerCase();
        if (!haystack.contains(normalizedQuery)) continue;
      }

      listings.add(listing);
    }

    return listings;
  }

  String _localityFromAddress(String? address) {
    if (address == null || address.trim().isEmpty) return '';
    final parts = address.split(',');
    if (parts.length >= 2) {
      return parts[parts.length - 2].trim();
    }
    return parts.first.trim();
  }
}
