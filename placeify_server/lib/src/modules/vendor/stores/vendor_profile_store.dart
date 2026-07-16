import 'dart:typed_data';

import 'package:serverpod/serverpod.dart' hide Order;

import '../../../generated/protocol.dart';
import '../../../shared/placeify_exception.dart';
import '../../../shared/session_service.dart';
import '../../notification/in_app_notification_store.dart';
import '../../notification/notification_repository.dart';
import '../../product/product_catalog_policy.dart';
import '../vendor_bank_details_validation.dart';
import '../vendor_document_storage.dart';
import '../vendor_product_image_storage.dart';
import '../vendor_profile_audit_log.dart';
import '../vendor_profile_mapper.dart';
import '../vendor_profile_validation.dart';
import '../vendor_sales_metrics.dart';
import '../vendor_shop_category_codec.dart';
import 'vendor_access_guard.dart';
import 'vendor_order_support.dart';

/// Vendor shop profile, registration, dashboard, and public listings.
class VendorProfileStore {
  VendorProfileStore({
    VendorAccessGuard? access,
    VendorProductImageStorage? imageStorage,
  })  : _access = access ?? VendorAccessGuard(),
        _imageStorage = imageStorage ?? VendorProductImageStorage();

  final VendorAccessGuard _access;
  final VendorProductImageStorage _imageStorage;

  Future<VendorDashboard> getDashboard(Session session) async {
    final user = await SessionService.requireUser(session);
    final vendor = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(user.id!),
    );
    if (vendor == null) {
      throw PlaceifyException(
        message: 'Shop not found.',
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

    final orderItems =
        await VendorOrderSupport.loadVendorOrderItems(session, vendorId);
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

    // Awaiting vendor action only (accept/reject). Lifecycle continues on Orders page.
    final awaitingItems = [
      for (final item in orderItems)
        if (item.order != null &&
            (item.order!.status == OrderStatus.pending ||
                item.order!.status == OrderStatus.confirmed))
          item,
    ];
    final recentOrderItems = awaitingItems.take(6).toList();
    final recentOrderIds = recentOrderItems.map((item) => item.orderId).toSet();
    final deliveryStages = await VendorOrderSupport.latestDeliveryStagesForOrders(
      session,
      vendorId,
      recentOrderIds,
    );

    final recentOrders = <VendorOrderSummary>[
      for (final item in recentOrderItems)
        if (item.id != null && item.order != null)
          VendorOrderSummary(
            orderItemId: item.id!,
            productId: item.productId,
            orderId: item.orderId,
            orderNumber: item.orderId.toString().padLeft(5, '0'),
            productName: item.product?.name ?? 'Product',
            quantity: item.quantity,
            lineTotal: item.unitPrice * item.quantity,
            status: item.order!.status,
            currentDeliveryStage: deliveryStages[item.orderId],
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
          requestMeta: 'Request · ${request.user?.name ?? 'Customer'}',
        ),
      );
    }

    recentOrders.sort((a, b) => b.placedAt.compareTo(a.placedAt));

    final pendingRefundCount = await _countPendingRefunds(session, vendorId);

    return VendorDashboard(
      shop: vendor,
      productCount: products.length,
      activeProductCount: activeProducts,
      orderCount: sales.deliveredOrderCount,
      revenue: sales.netRevenue,
      pendingRefundCount: pendingRefundCount,
      recentOrders: recentOrders.take(6).toList(),
      topProducts: topProducts,
    );
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
      throw PlaceifyException(
        message: 'Vendor shop already exists.',
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

    try {
      await InAppNotificationStore().notifyActiveAdmins(
        session,
        title: 'New vendor application',
        message: '$trimmedName submitted a vendor application for review.',
        type: InAppNotificationType.vendorApplication,
        referenceKey: vendor.id!.uuid,
      );
    } catch (_) {}

    return vendor;
  }

  Future<VendorBankDetails?> getMyBankDetails(Session session) async {
    final vendor = await _access.requireOwnedVendor(session);
    return VendorBankDetails.db.findFirstRow(
      session,
      where: (row) => row.vendorId.equals(vendor.id!),
    );
  }

  Future<VendorBankDetails> saveMyBankDetails(
    Session session,
    VendorBankDetailsInput input,
  ) async {
    final vendor = await _access.requireOwnedVendor(session);
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
          message:
              'Upload all required verification documents before submitting.',
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
    final vendor = await _access.requireVendorProfile(session);
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
    final vendor =
        await _access.requireOwnedVendor(session, allowSuspended: true);
    return _loadProfileDetail(session, vendor, includeNotificationPrefs: true);
  }

  Future<VendorProfileDetail> submitSuspensionAppeal(
    Session session,
    String message,
  ) async {
    final vendor = await _access.requireSuspendedVendorForAppeal(session);
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) {
      throw PlaceifyException(
        message: 'Appeal message is required.',
        code: 'INVALID_APPEAL',
      );
    }

    if (vendor.appealSubmittedAt != null) {
      throw PlaceifyException(
        message:
            'You have already submitted an appeal. Please wait for admin review.',
        code: 'APPEAL_ALREADY_SUBMITTED',
      );
    }

    final now = DateTime.now();
    final updatedVendor = await Vendor.db.updateRow(
      session,
      vendor.copyWith(
        appealMessage: trimmedMessage,
        appealSubmittedAt: now,
        updatedAt: now,
      ),
    );

    return _loadProfileDetail(
      session,
      updatedVendor,
      includeNotificationPrefs: true,
    );
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
        !ProductCatalogPolicy.isConsumerVisibleShop(vendor, user: user)) {
      return null;
    }

    return _loadProfileDetail(session, vendor, user: user);
  }

  Future<VendorProfileDetail> updateMyProfile(
    Session session,
    VendorProfileUpdateInput input,
  ) async {
    final vendor = await _access.requireOwnedVendor(session);
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
    final vendor = await _access.requireOwnedVendor(session);
    final logoUrl = await _imageStorage.persistProductImage(
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
    final vendor = await _access.requireOwnedVendor(session);
    final bannerUrl = await _imageStorage.persistProductImage(
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
    final vendor = await _access.requireOwnedVendor(session);
    final coverUrl = await _imageStorage.persistProductImage(
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

  Future<int> _countPendingRefunds(
    Session session,
    UuidValue vendorId,
  ) async {
    final items = await OrderItem.db.find(
      session,
      where: (row) => row.vendorId.equals(vendorId),
    );
    final orderIds = items.map((item) => item.orderId).toSet();
    if (orderIds.isEmpty) return 0;

    final pending = await RefundRequest.db.find(
      session,
      where: (row) => row.status.equals(RequestStatus.pending),
    );
    return pending.where((row) => orderIds.contains(row.orderId)).length;
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
      where: (row) =>
          row.isDeleted.equals(false) & row.status.equals(ProductStatus.active),
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
      if (!ProductCatalogPolicy.isConsumerVisibleShop(vendor, user: user)) {
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
