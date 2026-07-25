import '../../orders/domain/enums/consumer_order_status.dart';
import '../../orders/domain/models/order.dart';

/// Client-side refund order picker eligibility (server remains authoritative).
abstract final class RefundOrderEligibility {
  static const returnWindowDays = 14;

  /// Prefer delivery timestamp when known; fall back to [Order.placedAt].
  static DateTime windowStart(Order order) =>
      order.deliveredAt ?? order.placedAt;

  static bool isWithinReturnWindow(Order order, {DateTime? now}) {
    final deadline =
        windowStart(order).toUtc().add(const Duration(days: returnWindowDays));
    return !(now ?? DateTime.now()).toUtc().isAfter(deadline);
  }

  static String? exclusionReason(
    Order order, {
    required Set<int> blockedOrderIds,
    DateTime? now,
  }) {
    final orderId = int.tryParse(order.id);
    if (orderId == null) return 'invalid order id';
    if (order.status != ConsumerOrderStatus.delivered) {
      return 'status=${order.status.name} (need delivered)';
    }
    if (blockedOrderIds.contains(orderId)) {
      return 'open refund already exists';
    }
    if (!isWithinReturnWindow(order, now: now)) {
      final start = windowStart(order);
      final ageDays =
          (now ?? DateTime.now()).toUtc().difference(start.toUtc()).inDays;
      return 'outside ${returnWindowDays}d return window '
          '(${ageDays}d since ${order.deliveredAt != null ? 'delivery' : 'placement'})';
    }
    return null;
  }
}
