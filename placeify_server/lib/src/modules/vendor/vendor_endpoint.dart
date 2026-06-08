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

  Future<Vendor> createShop(
    Session session,
    String shopName, {
    String? description,
    String? logoUrl,
  }) {
    return _service.createShop(
      session,
      shopName,
      description: description,
      logoUrl: logoUrl,
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
    String? model3dUrl,
    String? thumbnailUrl,
  }) {
    return _service.createProduct(
      session,
      name,
      description,
      price,
      categoryId: categoryId,
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
}
