import 'enums/order_status.dart';

/// Whether the vendor may manually update payment for this order status.
///
/// Confirmed maps to [OrderStatus.pending] in the Flutter mapper, so both
/// pending and confirmed are excluded here.
bool canVendorUpdatePayment(OrderStatus status) {
  return switch (status) {
    OrderStatus.accepted ||
    OrderStatus.processing ||
    OrderStatus.shipped ||
    OrderStatus.delivered =>
      true,
    OrderStatus.pending ||
    OrderStatus.rejected ||
    OrderStatus.cancelled =>
      false,
  };
}
