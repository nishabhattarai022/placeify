/// Legacy display helpers kept for call-site compatibility.
/// Live catalog prices and names are used directly from [Product].
abstract final class CartDisplayConfig {
  static String nameFor(String productId, String fallback) => fallback;

  static double priceFor(String productId, double productPrice) => productPrice;
}
