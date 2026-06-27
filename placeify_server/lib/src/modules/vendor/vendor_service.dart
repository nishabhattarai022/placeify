import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'vendor_repository.dart';

class VendorService {
  VendorService({VendorStore? repository})
      : _repository = repository ?? VendorStore();

  final VendorStore _repository;

  Future<bool> hasShop(Session session) {
    return _repository.hasShop(session);
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
  }) {
    return _repository.createShop(
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
  }

  Future<VendorBankDetails?> getMyBankDetails(Session session) {
    return _repository.getMyBankDetails(session);
  }

  Future<VendorBankDetails> saveMyBankDetails(
    Session session,
    VendorBankDetailsInput input,
  ) {
    return _repository.saveMyBankDetails(session, input);
  }

  Future<VendorProfileDetail> getMyProfile(Session session) {
    return _repository.getMyProfile(session);
  }

  Future<VendorProfileDetail?> getShopProfile(
    Session session,
    UuidValue vendorId,
  ) {
    return _repository.getShopProfile(session, vendorId);
  }

  Future<List<ShopListingSummary>> listApprovedShops(
    Session session, {
    String? query,
  }) {
    return _repository.listApprovedShops(session, query: query);
  }

  Future<VendorProfileDetail> updateMyProfile(
    Session session,
    VendorProfileUpdateInput input,
  ) {
    return _repository.updateMyProfile(session, input);
  }

  Future<String> uploadShopLogo(
    Session session,
    ByteData fileData,
    String fileName,
  ) {
    return _repository.uploadShopLogo(session, fileData, fileName);
  }

  Future<String> uploadShopBanner(
    Session session,
    ByteData fileData,
    String fileName,
  ) {
    return _repository.uploadShopBanner(session, fileData, fileName);
  }

  Future<String> uploadShopCover(
    Session session,
    ByteData fileData,
    String fileName,
  ) {
    return _repository.uploadShopCover(session, fileData, fileName);
  }

  Future<String> uploadDocument(
    Session session,
    VendorDocumentType documentType,
    ByteData fileData,
    String fileName,
  ) {
    return _repository.uploadDocument(
      session,
      documentType,
      fileData,
      fileName,
    );
  }

  /// Alias for [uploadShopLogo] — matches client API naming.
  Future<String> uploadLogo(
    Session session,
    ByteData fileData,
    String fileName,
  ) {
    return uploadShopLogo(session, fileData, fileName);
  }

  /// Alias for [uploadShopBanner].
  Future<String> uploadBanner(
    Session session,
    ByteData fileData,
    String fileName,
  ) {
    return uploadShopBanner(session, fileData, fileName);
  }

  Future<Vendor> updateShop(
    Session session,
    String shopName, {
    String? description,
    String? logoUrl,
  }) {
    return _repository.updateShop(
      session,
      shopName,
      description: description,
      logoUrl: logoUrl,
    );
  }

  Future<Vendor> getMyShop(Session session) {
    return _repository.requireVendorProfile(session);
  }

  Future<VendorDashboard> getDashboard(Session session) {
    return _repository.getDashboard(session);
  }

  Future<List<Product>> listMyProducts(Session session) {
    return _repository.listMyProducts(session);
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
  }) {
    return _repository.createProduct(
      session,
      name,
      description,
      price,
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
  }

  Future<Product> uploadProduct(
    Session session,
    VendorProductUploadInput input,
    ByteData imageData,
    String imageFileName,
  ) {
    return _repository.uploadProduct(
      session,
      input,
      imageData,
      imageFileName,
    );
  }

  Future<Product> updateProductThumbnail(
    Session session,
    int productId,
    String thumbnailUrl,
  ) {
    return _repository.updateProductThumbnail(
      session,
      productId,
      thumbnailUrl,
    );
  }

  Future<String> uploadProductImage(
    Session session,
    ByteData fileData,
    String fileName, {
    bool removeBackground = false,
  }) {
    return _repository.uploadProductImage(
      session,
      fileData,
      fileName,
      removeBackground: removeBackground,
    );
  }

  Future<Product> regenerateProductModel3d(
    Session session,
    int productId,
  ) {
    return _repository.regenerateProductModel3d(session, productId);
  }

  Future<Product> deleteProduct(Session session, int productId) {
    return _repository.deleteProduct(session, productId);
  }

  Future<Product> restoreProduct(Session session, int productId) {
    return _repository.restoreProduct(session, productId);
  }

  Future<Product> archiveProduct(Session session, int productId) {
    return _repository.archiveProduct(session, productId);
  }

  Future<List<VendorShopOrder>> listShopOrders(
    Session session, {
    int limit = 50,
    int offset = 0,
    OrderStatus? status,
  }) {
    return _repository.listShopOrders(
      session,
      limit: limit,
      offset: offset,
      status: status,
    );
  }

  Future<VendorShopOrder> getShopOrder(Session session, int orderId) {
    return _repository.getShopOrder(session, orderId);
  }

  Future<VendorShopOrder> acceptShopOrder(Session session, int orderId) {
    return _repository.acceptShopOrder(session, orderId);
  }

  Future<VendorShopOrder> rejectShopOrder(
    Session session,
    int orderId,
    String reason,
  ) {
    return _repository.rejectShopOrder(session, orderId, reason);
  }

  Future<List<OrderDeliveryUpdate>> listDeliveryUpdates(
    Session session,
    int orderId,
  ) {
    return _repository.listDeliveryUpdates(session, orderId);
  }

  Future<OrderDeliveryUpdate> submitDeliveryUpdate(
    Session session,
    int orderId,
    DeliveryStage stage, {
    String? note,
    String? photoUrl,
  }) {
    return _repository.submitDeliveryUpdate(
      session,
      orderId,
      stage,
      note: note,
      photoUrl: photoUrl,
    );
  }

  Future<String> uploadDeliveryProof(
    Session session,
    ByteData fileData,
    String fileName,
  ) {
    return _repository.uploadDeliveryProof(session, fileData, fileName);
  }

  Future<List<VendorNotificationSummary>> listNotifications(
    Session session, {
    int limit = 50,
  }) {
    return _repository.listNotifications(session, limit: limit);
  }

  Future<void> markNotificationRead(Session session, int notificationId) {
    return _repository.markNotificationRead(session, notificationId);
  }

  Future<void> markAllNotificationsRead(Session session) {
    return _repository.markAllNotificationsRead(session);
  }

  Future<List<RefundRequestSummary>> listPendingRefundRequests(
    Session session,
  ) {
    return _repository.listPendingRefundRequests(session);
  }

  Future<RefundRequestSummary> approveRefundRequest(
    Session session,
    int refundId,
  ) {
    return _repository.approveRefundRequest(session, refundId);
  }

  Future<RefundRequestSummary> rejectRefundRequest(
    Session session,
    int refundId, {
    String? reason,
  }) {
    return _repository.rejectRefundRequest(session, refundId, reason: reason);
  }
}
