import 'package:placeify_flutter/features/vendor/data/config/vendor_mock_config.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_product.dart';
import 'package:placeify_flutter/features/vendor/domain/repositories/vendor_product_repository.dart';

class VendorProductActionException implements Exception {
  VendorProductActionException(this.message);

  final String message;

  @override
  String toString() => message;
}

class MockVendorProductRepository implements VendorProductRepository {
  const MockVendorProductRepository();

  @override
  Future<List<VendorProduct>> getProducts(String vendorId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return VendorMockConfig.productsFor(vendorId);
  }

  @override
  Future<VendorProduct?> getProductById(String productId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return VendorMockConfig.productById(productId);
  }

  @override
  Future<void> deleteProducts(
    String vendorId,
    List<String> productIds,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    if (!VendorMockConfig.isKnownVendor(vendorId)) {
      throw VendorProductActionException('Vendor account not found.');
    }

    if (productIds.isEmpty) {
      throw VendorProductActionException('No products selected.');
    }

    final removed = VendorMockConfig.deleteProducts(productIds);
    if (removed == 0) {
      throw VendorProductActionException('Products could not be deleted.');
    }
  }

  @override
  Future<VendorProduct> createProduct(
    String vendorId,
    VendorProduct product,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (!VendorMockConfig.isKnownVendor(vendorId)) {
      throw VendorProductActionException('Vendor account not found.');
    }

    final created = product.copyWith(
      id: product.id.isEmpty ? VendorMockConfig.nextProductId() : product.id,
      vendorId: vendorId,
    );

    return VendorMockConfig.upsertProduct(created);
  }

  @override
  Future<VendorProduct> updateProduct(
    String vendorId,
    VendorProduct product,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (!VendorMockConfig.isKnownVendor(vendorId)) {
      throw VendorProductActionException('Vendor account not found.');
    }

    if (VendorMockConfig.productById(product.id) == null) {
      throw VendorProductActionException('Product not found.');
    }

    return VendorMockConfig.upsertProduct(product);
  }
}
