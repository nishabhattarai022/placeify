import 'package:flutter_test/flutter_test.dart';
import 'package:placeify_flutter/features/cart/domain/cart_line_item.dart';
import 'package:placeify_flutter/features/cart/domain/cart_totals_calculator.dart';
import 'package:placeify_flutter/features/home/domain/constants/product_categories.dart';
import 'package:placeify_flutter/features/home/domain/models/product.dart';

void main() {
  test('product categories are defined for catalog browsing', () {
    expect(ProductCategories.all.length, greaterThanOrEqualTo(6));
    expect(ProductCategories.byId('chairs'), isNotNull);
  });

  test('cart totals calculator sums line item prices', () {
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

    final totals = CartTotalsCalculator.compute(
      const [CartLineItem(productId: 'sale-1', quantity: 2)],
      (id) => id == product.id ? product : null,
    );

    expect(product.isOnSale, isTrue);
    expect(totals.subtotal, 1600);
    expect(totals.discount, 0);
    expect(totals.total, 1600);
  });
}
