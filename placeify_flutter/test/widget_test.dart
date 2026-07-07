import 'package:flutter_test/flutter_test.dart';
import 'package:placeify_flutter/features/cart/presentation/providers/cart_provider.dart';
import 'package:placeify_flutter/features/home/data/mock_product_repository.dart';
import 'package:placeify_flutter/features/home/domain/models/product.dart';
import 'package:placeify_flutter/features/vendor/data/mock_vendor_repository.dart';

void main() {
  test('mock product repository has catalog data', () {
    expect(MockProductRepository.categories.length, 6);
    expect(MockProductRepository.products.length, 18);
    expect(
      MockProductRepository.products.firstWhere((p) => p.id == 'p4').name,
      'Harmony Chair',
    );
  });

  test('computeCartTotals applies product discounts to summary', () {
    const product = Product(
      id: 'sale-1',
      name: 'Sale Chair',
      brand: 'Vendor',
      sku: 'SKU1',
      price: 800,
      originalPrice: 1000,
      imageUrl: 'assets/images/categories/chair.jpg',
      svgIconPath: 'assets/icons/ic_chair.svg',
      hasArView: false,
      categoryId: 'chairs',
      dimensions: ProductDimensions(widthCm: 70, depthCm: 68, heightCm: 85),
    );

    final totals = computeCartTotals([(product: product, quantity: 2)]);

    expect(product.isOnSale, isTrue);
    expect(totals.subtotal, 2000);
    expect(totals.discount, 400);
    expect(totals.total, 1600);
  });

  test('mock vendor repository has dashboard data', () {
    expect(MockVendorRepository.orders.length, 9);
    expect(MockVendorRepository.topProducts.length, 3);
    expect(MockVendorRepository.revenue, 8400);
  });
}
