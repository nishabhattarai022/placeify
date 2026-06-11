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
  }) {
    return _service.createShop(
      session,
      shopName,
      description: description,
      logoUrl: logoUrl,
      phone: phone,
      address: address,
    );
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
    String fileName,
  ) {
    return _service.uploadProductImage(session, fileData, fileName);
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
}
