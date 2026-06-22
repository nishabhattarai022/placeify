import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'vendor_service.dart';

/// Vendor shop and product management.
class VendorEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final _service = VendorService();

  Future<Vendor> getMyShop(Session session) {
    return _service.getMyShop(session);
  }

  Future<VendorDashboard> getDashboard(Session session) {
    return _service.getDashboard(session);
  }

  Future<bool> hasShop(Session session) {
    return _service.hasShop(session);
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
    return _service.createShop(
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
    return _service.getMyBankDetails(session);
  }

  Future<VendorBankDetails> saveMyBankDetails(
    Session session,
    VendorBankDetailsInput input,
  ) {
    return _service.saveMyBankDetails(session, input);
  }

  Future<VendorProfileDetail> getMyProfile(Session session) {
    return _service.getMyProfile(session);
  }

  Future<VendorProfileDetail> updateMyProfile(
    Session session,
    VendorProfileUpdateInput input,
  ) {
    return _service.updateMyProfile(session, input);
  }

  Future<String> uploadShopLogo(
    Session session,
    ByteData fileData,
    String fileName,
  ) {
    return _service.uploadShopLogo(session, fileData, fileName);
  }

  Future<String> uploadShopBanner(
    Session session,
    ByteData fileData,
    String fileName,
  ) {
    return _service.uploadShopBanner(session, fileData, fileName);
  }

  Future<String> uploadShopCover(
    Session session,
    ByteData fileData,
    String fileName,
  ) {
    return _service.uploadShopCover(session, fileData, fileName);
  }

  Future<String> uploadDocument(
    Session session,
    VendorDocumentType documentType,
    ByteData fileData,
    String fileName,
  ) {
    return _service.uploadDocument(
      session,
      documentType,
      fileData,
      fileName,
    );
  }

  /// Alias for [uploadShopLogo].
  Future<String> uploadLogo(
    Session session,
    ByteData fileData,
    String fileName,
  ) {
    return _service.uploadLogo(session, fileData, fileName);
  }

  /// Alias for [uploadShopBanner].
  Future<String> uploadBanner(
    Session session,
    ByteData fileData,
    String fileName,
  ) {
    return _service.uploadBanner(session, fileData, fileName);
  }

  Future<Vendor> updateShop(
    Session session,
    String shopName, {
    String? description,
    String? logoUrl,
  }) {
    return _service.updateShop(
      session,
      shopName,
      description: description,
      logoUrl: logoUrl,
    );
  }

  Future<List<Product>> listMyProducts(Session session) {
    return _service.listMyProducts(session);
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
    return _service.createProduct(
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

  /// Creates a vendor product and stores the uploaded photo in one call.
  Future<Product> uploadProduct(
    Session session,
    VendorProductUploadInput input,
    ByteData imageData,
    String imageFileName,
  ) {
    return _service.uploadProduct(
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
    return _service.updateProductThumbnail(session, productId, thumbnailUrl);
  }

  Future<String> uploadProductImage(
    Session session,
    ByteData fileData,
    String fileName, {
    bool removeBackground = false,
  }) {
    return _service.uploadProductImage(
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
    return _service.regenerateProductModel3d(session, productId);
  }

  Future<List<VendorShopOrder>> listShopOrders(
    Session session, {
    int limit = 50,
    int offset = 0,
    OrderStatus? status,
  }) {
    return _service.listShopOrders(
      session,
      limit: limit,
      offset: offset,
      status: status,
    );
  }

  Future<VendorShopOrder> getShopOrder(Session session, int orderId) {
    return _service.getShopOrder(session, orderId);
  }

  Future<VendorShopOrder> acceptShopOrder(Session session, int orderId) {
    return _service.acceptShopOrder(session, orderId);
  }

  Future<VendorShopOrder> rejectShopOrder(
    Session session,
    int orderId,
    String reason,
  ) {
    return _service.rejectShopOrder(session, orderId, reason);
  }

  Future<List<OrderDeliveryUpdate>> listDeliveryUpdates(
    Session session,
    int orderId,
  ) {
    return _service.listDeliveryUpdates(session, orderId);
  }

  Future<OrderDeliveryUpdate> submitDeliveryUpdate(
    Session session,
    int orderId,
    DeliveryStage stage, {
    String? note,
    String? photoUrl,
  }) {
    return _service.submitDeliveryUpdate(
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
    return _service.uploadDeliveryProof(session, fileData, fileName);
  }
}
