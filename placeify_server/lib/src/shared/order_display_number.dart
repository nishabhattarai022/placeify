/// Stable customer-facing order labels (not zero-padded DB ids).
abstract final class OrderDisplayNumber {
  static String format(int orderId) => 'ORD-$orderId';

  static String formatNullable(int? orderId) =>
      orderId == null ? 'ORD-unknown' : format(orderId);
}
