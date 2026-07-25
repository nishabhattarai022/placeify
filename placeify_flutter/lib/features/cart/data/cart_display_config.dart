/// Mockup-aligned labels and unit prices for cart line items.
abstract final class CartDisplayConfig {
  static const defaultProductIds = ['p4', 'p5', 'p6', 'p1'];

  static const Map<String, String> displayNames = {
    'p4': 'Red Velvet',
    'p5': 'Desert chair',
    'p6': 'Luna chair',
    'p1': 'Orbit Seat',
  };

  static const Map<String, double> unitPrices = {
    'p4': 199,
    'p5': 239,
    'p6': 399,
    'p1': 245,
  };

  /// Promo discount rate applied to subtotal.
  static const double discountRate = 566 / 2930;

  static String nameFor(String productId, String fallback) =>
      displayNames[productId] ?? fallback;

  static double priceFor(String productId, double productPrice) =>
      unitPrices[productId] ?? productPrice;
}
