import 'package:flutter_test/flutter_test.dart';
import 'package:placeify/features/home/data/mock_product_repository.dart';
import 'package:placeify/features/vendor/data/mock_vendor_repository.dart';

void main() {
  test('mock product repository has catalog data', () {
    expect(MockProductRepository.categories.length, 6);
    expect(MockProductRepository.products.length, 18);
    expect(
      MockProductRepository.products.firstWhere((p) => p.id == 'p4').name,
      'Harmony Chair',
    );
  });

  test('mock vendor repository has dashboard data', () {
    expect(MockVendorRepository.orders.length, 4);
    expect(MockVendorRepository.topProducts.length, 3);
    expect(MockVendorRepository.revenue, 8400);
  });
}
