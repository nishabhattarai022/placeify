import 'package:placeify_client/placeify_client.dart';

class ProductViewPhotoInput {
  const ProductViewPhotoInput({
    required this.bytes,
    required this.fileName,
  });

  final List<int> bytes;
  final String fileName;
}

abstract class VendorRepository {
  Future<VendorDashboard> getDashboard();

  Future<bool> hasShop();

  Future<Vendor> createShop(
    String shopName, {
    required String description,
    required String phone,
    required String address,
  });

  Future<Product> createProduct({
    required String name,
    required String description,
    required double price,
    required int categoryId,
    required String materials,
    required double widthCm,
    required double depthCm,
    required double heightCm,
    required String careInstructions,
    required List<int> imageBytes,
    required String imageFileName,
    List<ProductViewPhotoInput?> extraViewPhotos = const [],
    double? weightKg,
    String? assemblyNote,
    String? warranty,
  });

  Future<List<Product>> listMyProducts();

  Future<Product> regenerateProductModel3d(int productId);

  Future<List<VendorShopOrder>> listShopOrders({OrderStatus? status});

  Future<VendorShopOrder> getShopOrder(int orderId);
}

class VendorRepositoryException implements Exception {
  VendorRepositoryException(this.message, {this.code});

  final String message;
  final String? code;

  bool get isShopNotFound => code == 'SHOP_NOT_FOUND';

  @override
  String toString() => message;
}
