import '../generated/protocol.dart';

/// Server-side refund/return eligibility (never trust the client alone).
abstract final class RefundEligibility {
  /// Days after delivery (or [Order.placedAt] fallback) during which returns
  /// are accepted.
  static const returnWindowDays = 14;

  /// Start of the return window: delivery timestamp when known, else placedAt.
  static DateTime windowStart({
    required Order order,
    DateTime? deliveredAt,
  }) {
    return deliveredAt ?? order.placedAt;
  }

  static bool isWithinReturnWindow({
    required Order order,
    DateTime? deliveredAt,
    DateTime? now,
  }) {
    final start = windowStart(order: order, deliveredAt: deliveredAt);
    final deadline = start.add(const Duration(days: returnWindowDays));
    return !(now ?? DateTime.now()).toUtc().isAfter(deadline.toUtc());
  }

  static void ensureEligible({
    required User user,
    required Order order,
    required RefundRequest? existingOpen,
    DateTime? deliveredAt,
  }) {
    if (order.userId != user.id) {
      throw PlaceifyException(
        message: 'Order not found.',
        code: 'ORDER_NOT_FOUND',
      );
    }

    if (order.status == OrderStatus.cancelled ||
        order.status == OrderStatus.autoCancelled) {
      throw PlaceifyException(
        message: 'Cancelled orders cannot be refunded.',
        code: 'ORDER_CANCELLED',
      );
    }

    if (order.status == OrderStatus.refunded) {
      throw PlaceifyException(
        message: 'This order has already been refunded.',
        code: 'ORDER_REFUNDED',
      );
    }

    if (order.status != OrderStatus.delivered) {
      throw PlaceifyException(
        message: 'Only delivered orders can be refunded.',
        code: 'ORDER_NOT_DELIVERED',
      );
    }

    if (existingOpen != null) {
      throw PlaceifyException(
        message: 'A pending refund request already exists for this order.',
        code: 'REFUND_EXISTS',
      );
    }

    if (!isWithinReturnWindow(order: order, deliveredAt: deliveredAt)) {
      throw PlaceifyException(
        message:
            'The return window of $returnWindowDays days has expired for this order.',
        code: 'RETURN_WINDOW_EXPIRED',
      );
    }
  }
}
