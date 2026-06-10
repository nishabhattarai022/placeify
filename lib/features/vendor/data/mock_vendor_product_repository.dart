import 'package:placeify/features/vendor/data/config/vendor_mock_config.dart';
import 'package:placeify/features/vendor/domain/models/vendor_product.dart';
import 'package:placeify/features/vendor/domain/repositories/vendor_product_repository.dart';

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
}
