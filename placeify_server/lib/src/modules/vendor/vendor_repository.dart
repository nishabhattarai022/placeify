import 'dart:typed_data';

import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../marketplace/marketplace_events.dart';
import '../notification/in_app_notification_store.dart';
import '../review/review_repository.dart';
import 'stores/vendor_access_guard.dart';
import 'stores/vendor_delivery_store.dart';
import 'stores/vendor_notification_store.dart';
import 'stores/vendor_order_store.dart';
import 'stores/vendor_product_store.dart';
import 'stores/vendor_profile_store.dart';
import 'stores/vendor_refund_store.dart';
import 'vendor_product_image_storage.dart';

class VendorStore {
  VendorStore({
    InAppNotificationStore? notifications,
    VendorAccessGuard? access,
    MarketplaceEventDispatcher? events,
    VendorNotificationStore? vendorNotifications,
    VendorOrderStore? orders,
    VendorDeliveryStore? delivery,
    VendorProductStore? products,
    VendorProfileStore? profile,
    VendorRefundStore? refunds,
    VendorProductImageStorage? imageStorage,
    ReviewStore? reviews,
  })  : _notifications = notifications ?? InAppNotificationStore(),
        _access = access ?? VendorAccessGuard(),
        _events = events ?? marketplaceEventDispatcher,
        _imageStorage = imageStorage ?? VendorProductImageStorage(),
        _vendorNotifications = vendorNotifications ??
            VendorNotificationStore(notifications: notifications),
        _orders = orders ??
            VendorOrderStore(
              access: access ?? VendorAccessGuard(),
              events: events ?? marketplaceEventDispatcher,
            ),
        _delivery = delivery ??
            VendorDeliveryStore(
              access: access ?? VendorAccessGuard(),
              events: events ?? marketplaceEventDispatcher,
              persistImage: (session, fileData, fileName,
                      {required removeBackground}) =>
                  (imageStorage ?? VendorProductImageStorage())
                      .persistProductImage(
                    session,
                    fileData,
                    fileName,
                    removeBackground: removeBackground,
                  ),
            ),
        _products = products ??
            VendorProductStore(
              events: events ?? marketplaceEventDispatcher,
              access: access ?? VendorAccessGuard(),
              imageStorage: imageStorage ?? VendorProductImageStorage(),
            ),
        _profile = profile ??
            VendorProfileStore(
              access: access ?? VendorAccessGuard(),
              imageStorage: imageStorage ?? VendorProductImageStorage(),
            ),
        _refunds = refunds ?? VendorRefundStore(access: access),
        _reviews = reviews ?? ReviewStore();

  final InAppNotificationStore _notifications;
  final VendorAccessGuard _access;
  final MarketplaceEventDispatcher _events;
  final VendorProductImageStorage _imageStorage;
  final VendorNotificationStore _vendorNotifications;
  final VendorOrderStore _orders;
  final VendorDeliveryStore _delivery;
  final VendorProductStore _products;
  final VendorProfileStore _profile;
  final VendorRefundStore _refunds;
  final ReviewStore _reviews;

  Future<VendorDashboard> getDashboard(Session session) =>
      _profile.getDashboard(session);

  Future<Vendor> requireVendorProfile(Session session) =>
      _access.requireVendorProfile(session);

  Future<Vendor> requireOwnedVendor(Session session) =>
      _access.requireOwnedVendor(session);

  Future<bool> hasShop(Session session) => _access.hasShop(session);

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
  }) =>
      _profile.createShop(
        session,
        shopName,
        description: description,
        logoUrl: logoUrl,
        phone: phone,
        address: address,
        city: city,
        country: country,
        shopCategory: shopCategory,
        contactEmail: contactEmail,
        bankDetails: bankDetails,
      );

  Future<VendorBankDetails?> getMyBankDetails(Session session) =>
      _profile.getMyBankDetails(session);

  Future<VendorBankDetails> saveMyBankDetails(
    Session session,
    VendorBankDetailsInput input,
  ) =>
      _profile.saveMyBankDetails(session, input);

  Future<String> uploadDocument(
    Session session,
    VendorDocumentType documentType,
    ByteData fileData,
    String fileName,
  ) =>
      _profile.uploadDocument(session, documentType, fileData, fileName);

  Future<Vendor> updateShop(
    Session session,
    String shopName, {
    String? description,
    String? logoUrl,
  }) =>
      _profile.updateShop(session, shopName,
          description: description, logoUrl: logoUrl);

  Future<VendorProfileDetail> getMyProfile(Session session) =>
      _profile.getMyProfile(session);

  Future<VendorProfileDetail> submitSuspensionAppeal(
    Session session,
    String message,
  ) =>
      _profile.submitSuspensionAppeal(session, message);

  Future<VendorProfileDetail?> getShopProfile(
    Session session,
    UuidValue vendorId,
  ) =>
      _profile.getShopProfile(session, vendorId);

  Future<VendorProfileDetail> updateMyProfile(
    Session session,
    VendorProfileUpdateInput input,
  ) =>
      _profile.updateMyProfile(session, input);

  Future<String> uploadShopLogo(
    Session session,
    ByteData fileData,
    String fileName,
  ) =>
      _profile.uploadShopLogo(session, fileData, fileName);

  Future<String> uploadShopBanner(
    Session session,
    ByteData fileData,
    String fileName,
  ) =>
      _profile.uploadShopBanner(session, fileData, fileName);

  Future<String> uploadShopCover(
    Session session,
    ByteData fileData,
    String fileName,
  ) =>
      _profile.uploadShopCover(session, fileData, fileName);

  Future<List<Product>> listMyProducts(Session session) =>
      _products.listMyProducts(session);

  Future<Product> createProduct(
    Session session,
    String name,
    String description,
    double price, {
    double? discountPrice,
    double? discountPercentage,
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
  }) =>
      _products.createProduct(
        session,
        name,
        description,
        price,
        discountPrice: discountPrice,
        discountPercentage: discountPercentage,
        categoryId: categoryId,
        materials: materials,
        widthCm: widthCm,
        depthCm: depthCm,
        heightCm: heightCm,
        weightKg: weightKg,
        assemblyNote: assemblyNote,
        careInstructions: careInstructions,
        warranty: warranty,
        model3dUrl: model3dUrl,
        thumbnailUrl: thumbnailUrl,
        viewImageUrls: viewImageUrls,
      );

  Future<Product> uploadProduct(
    Session session,
    VendorProductUploadInput input,
    ByteData imageData,
    String imageFileName,
  ) =>
      _products.uploadProduct(session, input, imageData, imageFileName);

  Future<Product> regenerateProductModel3d(
    Session session,
    int productId,
  ) =>
      _products.regenerateProductModel3d(session, productId);

  Future<Product> updateProductThumbnail(
    Session session,
    int productId,
    String thumbnailUrl,
  ) =>
      _products.updateProductThumbnail(session, productId, thumbnailUrl);

  Future<String> uploadProductImage(
    Session session,
    ByteData fileData,
    String fileName, {
    bool removeBackground = false,
  }) =>
      _products.uploadProductImage(
        session,
        fileData,
        fileName,
        removeBackground: removeBackground,
      );

  Future<List<VendorShopOrder>> listShopOrders(
    Session session, {
    int limit = 50,
    int offset = 0,
    OrderStatus? status,
  }) =>
      _orders.listShopOrders(
        session,
        limit: limit,
        offset: offset,
        status: status,
      );

  Future<VendorShopOrder> getShopOrder(Session session, int orderId) =>
      _orders.getShopOrder(session, orderId);

  Future<VendorShopOrder> acceptShopOrder(Session session, int orderId) =>
      _orders.acceptShopOrder(session, orderId);

  Future<VendorShopOrder> rejectShopOrder(
    Session session,
    int orderId,
    String reason,
  ) =>
      _orders.rejectShopOrder(session, orderId, reason);

  Future<List<OrderDeliveryUpdate>> listDeliveryUpdates(
    Session session,
    int orderId,
  ) =>
      _delivery.listDeliveryUpdates(session, orderId);

  Future<OrderDeliveryUpdate> submitDeliveryUpdate(
    Session session,
    int orderId,
    DeliveryStage stage, {
    String? note,
    String? photoUrl,
  }) =>
      _delivery.submitDeliveryUpdate(
        session,
        orderId,
        stage,
        note: note,
        photoUrl: photoUrl,
      );

  Future<String> uploadDeliveryProof(
    Session session,
    ByteData fileData,
    String fileName,
  ) =>
      _delivery.uploadDeliveryProof(session, fileData, fileName);

  Future<List<VendorNotificationSummary>> listNotifications(
    Session session, {
    int limit = 50,
  }) =>
      _vendorNotifications.listNotifications(session, limit: limit);

  Future<void> markNotificationRead(Session session, int notificationId) =>
      _vendorNotifications.markNotificationRead(session, notificationId);

  Future<void> markAllNotificationsRead(Session session) =>
      _vendorNotifications.markAllNotificationsRead(session);

  Future<List<ShopListingSummary>> listApprovedShops(
    Session session, {
    String? query,
  }) =>
      _profile.listApprovedShops(session, query: query);

  Future<Product> deleteProduct(Session session, int productId) =>
      _products.deleteProduct(session, productId);

  Future<Product> restoreProduct(Session session, int productId) =>
      _products.restoreProduct(session, productId);

  Future<Product> archiveProduct(Session session, int productId) =>
      _products.archiveProduct(session, productId);

  Future<List<RefundRequestSummary>> listPendingRefundRequests(
    Session session,
  ) =>
      _refunds.listPending(session);

  Future<RefundRequestSummary> approveRefundRequest(
    Session session,
    int refundId,
  ) =>
      _refunds.approve(session, refundId);

  Future<RefundRequestSummary> rejectRefundRequest(
    Session session,
    int refundId, {
    String? reason,
  }) =>
      _refunds.reject(session, refundId, reason: reason);

  Future<List<VendorReviewSummary>> listShopReviews(
    Session session, {
    int limit = 20,
    int offset = 0,
  }) async {
    final vendor = await _access.requireOwnedVendor(session);
    return _reviews.listVendorReviews(
      session,
      vendor.id!,
      limit: limit,
      offset: offset,
    );
  }
}
