import 'package:placeify_flutter/features/vendor/domain/models/vendor_product.dart';

abstract interface class VendorProductRepository {
  Future<List<VendorProduct>> getProducts(String vendorId);

  Future<VendorProduct?> getProductById(String productId);

  Future<void> deleteProducts(String vendorId, List<String> productIds);

  Future<VendorProduct> createProduct(
    String vendorId,
    VendorProduct product,
  );

  Future<VendorProduct> updateProduct(
    String vendorId,
    VendorProduct product,
  );

  Future<VendorProduct> regenerateProductModel3d(
    String vendorId,
    String productId, {
    List<String>? imageSources,
  });
}
