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
    String? shopCategory,
  }) {
    return _repository.createShop(
      session,
      shopName,
      description: description,
      logoUrl: logoUrl,
      phone: phone,
      address: address,
      shopCategory: shopCategory,
    );
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
    String fileName,
  ) {
    return _repository.uploadProductImage(session, fileData, fileName);
  }

  Future<Product> regenerateProductModel3d(
    Session session,
    int productId,
  ) {
    return _repository.regenerateProductModel3d(session, productId);
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
}
