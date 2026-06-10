import 'package:placeify/features/vendor/data/config/vendor_mock_config.dart';
import 'package:placeify/features/vendor/domain/models/vendor_product.dart';
import 'package:placeify/features/vendor/domain/repositories/vendor_product_repository.dart';

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
}
