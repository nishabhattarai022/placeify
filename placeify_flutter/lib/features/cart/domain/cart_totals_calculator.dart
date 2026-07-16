import '../../home/domain/models/product.dart';
import 'cart_line_item.dart';
import 'cart_totals.dart';

/// Pure cart total calculation — safe to call from providers and notifiers.
abstract final class CartTotalsCalculator {
  static CartTotals compute(
    List<CartLineItem> items,
    Product? Function(String productId) resolveProduct,
  ) {
    var subtotal = 0.0;
    for (final item in items) {
      final product = resolveProduct(item.productId);
      if (product == null) continue;
      subtotal += product.price * item.quantity;
    }

    final rounded = _roundMoney(subtotal);
    return CartTotals(subtotal: rounded, discount: 0, total: rounded);
  }

  static double _roundMoney(double value) {
    return (value * 100).roundToDouble() / 100;
  }
}
