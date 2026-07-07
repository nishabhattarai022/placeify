import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../marketplace/marketplace_events.dart';
import '../order/order_lifecycle_store.dart';

class OrderAutoCancelResult {
  const OrderAutoCancelResult({
    required this.scanned,
    required this.cancelled,
  });

  final int scanned;
  final int cancelled;
}

/// Cancels pending orders whose vendor response window has expired.
class OrderAutoCancelService {
  OrderAutoCancelService();

  Future<OrderAutoCancelResult> cancelExpiredPendingOrders(
    Session session, {
    DateTime? now,
  }) async {
    final effectiveNow = now ?? DateTime.now();

    final pending = await Order.db.find(
      session,
      where: (order) => order.status.equals(OrderStatus.pending),
    );

    final expired = pending.where((order) {
      final expiresAt = order.autoExpiresAt;
      if (expiresAt == null) return false;
      return !expiresAt.isAfter(effectiveNow);
    }).toList();

    var cancelled = 0;
    for (final order in expired) {
      final orderId = order.id;
      if (orderId == null) continue;

      await session.db.transaction((transaction) async {
        final updated = await OrderLifecycleStore.updateOrderWithVersion(
          session,
          order,
          (current) => current.copyWith(
            status: OrderStatus.autoCancelled,
            rejectionReason: 'Vendor did not respond within 30 days',
          ),
          transaction: transaction,
        );

        await OrderLifecycleStore.appendHistory(
          session,
          orderId,
          statusType: OrderStatusHistoryType.order,
          previousStatus: order.status.name,
          newStatus: OrderStatus.autoCancelled.name,
          note: 'Vendor did not respond within 30 days',
          transaction: transaction,
        );

        await marketplaceEventDispatcher.dispatch(
          session,
          OrderAutoCancelledEvent(order: updated),
        );
      });

      cancelled++;
    }

    return OrderAutoCancelResult(
      scanned: expired.length,
      cancelled: cancelled,
    );
  }

  /// Visible for tests.
  Future<bool> shouldCancel(Order order, DateTime now) async {
    if (order.status != OrderStatus.pending) return false;
    final expiresAt = order.autoExpiresAt;
    if (expiresAt == null) return false;
    return !expiresAt.isAfter(now);
  }
}
