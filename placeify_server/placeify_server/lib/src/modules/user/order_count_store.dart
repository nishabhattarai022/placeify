import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../refund/refund_repository.dart';

/// Shared order counting rules for dashboard stats and order list headers.
abstract final class OrderCountStore {
  static const _terminalStatuses = {
    OrderStatus.cancelled,
    OrderStatus.autoCancelled,
    OrderStatus.rejected,
  };

  static const _inProgressStatuses = {
    OrderStatus.pending,
    OrderStatus.confirmed,
    OrderStatus.accepted,
    OrderStatus.processing,
    OrderStatus.shipped,
  };

  static Future<UserOrderCounts> forUser(
    Session session,
    UuidValue userId, {
    RefundStore? refundStore,
  }) async {
    final refunds = refundStore ?? RefundStore();

    final totalOrders = await Order.db.count(
      session,
      where: (order) => order.userId.equals(userId),
    );

    final cancelledOrders = await Order.db.count(
      session,
      where: (order) {
        return order.userId.equals(userId) &
            (order.status.equals(OrderStatus.cancelled) |
                order.status.equals(OrderStatus.autoCancelled) |
                order.status.equals(OrderStatus.rejected));
      },
    );

    final deliveredOrders = await Order.db.count(
      session,
      where: (order) {
        return order.userId.equals(userId) &
            order.status.equals(OrderStatus.delivered);
      },
    );

    final inProgressOrders = await Order.db.count(
      session,
      where: (order) {
        Expression<dynamic>? statusMatch;
        for (final status in _inProgressStatuses) {
          final equals = order.status.equals(status);
          statusMatch = statusMatch == null ? equals : statusMatch | equals;
        }
        return order.userId.equals(userId) & statusMatch!;
      },
    );

    final returnOrders = await refunds.countForUser(session, userId);
    final activeOrders = totalOrders - cancelledOrders;

    return UserOrderCounts(
      totalOrders: totalOrders,
      activeOrders: activeOrders,
      cancelledOrders: cancelledOrders,
      deliveredOrders: deliveredOrders,
      inProgressOrders: inProgressOrders,
      returnOrders: returnOrders,
    );
  }

  static bool isTerminalStatus(OrderStatus status) {
    return _terminalStatuses.contains(status);
  }
}
