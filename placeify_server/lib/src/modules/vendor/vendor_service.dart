import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'vendor_repository.dart';

class VendorService {
  VendorService({VendorStore? repository})
      : _repository = repository ?? VendorStore();

  final VendorStore _repository;

  Future<Vendor> createShop(
    Session session,
    String shopName, {
    String? description,
    String? logoUrl,
  }) {
    return _repository.createShop(
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

  Future<List<Product>> listMyProducts(Session session) {
    return _repository.listMyProducts(session);
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
    return _repository.createProduct(
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
}
