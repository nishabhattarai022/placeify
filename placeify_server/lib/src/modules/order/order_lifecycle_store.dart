import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';

/// Persists order / delivery / payment audit rows.
abstract final class OrderLifecycleStore {
  static Future<void> appendHistory(
    Session session,
    int orderId, {
    required OrderStatusHistoryType statusType,
    required String newStatus,
    String? previousStatus,
    UuidValue? changedByUserId,
    String? note,
    Transaction? transaction,
  }) async {
    await OrderStatusHistory.db.insertRow(
      session,
      OrderStatusHistory(
        orderId: orderId,
        statusType: statusType,
        previousStatus: previousStatus,
        newStatus: newStatus,
        changedById: changedByUserId,
        note: note,
      ),
      transaction: transaction,
    );
  }

  static Future<Order> updateOrderWithVersion(
    Session session,
    Order order,
    Order Function(Order current) update, {
    Transaction? transaction,
  }) async {
    final orderId = order.id;

    if (orderId == null) {
      throw PlaceifyException(
        message: 'Order is missing an id.',
        code: 'INVALID_ORDER',
      );
    }

    final current = await Order.db.findById(
      session,
      orderId,
      transaction: transaction,
    );

    if (current == null) {
      throw PlaceifyException(
        message: 'Order not found.',
        code: 'NOT_FOUND',
      );
    }

    if (current.version != order.version) {
      throw PlaceifyException(
        message: 'Order was updated by another request. Refresh and try again.',
        code: 'ORDER_VERSION_CONFLICT',
      );
    }

    final next = update(current).copyWith(
      version: current.version + 1,
      updatedAt: DateTime.now(),
    );

    return Order.db.updateRow(
      session,
      next,
      transaction: transaction,
    );
  }

  /// Converts delivery stage into customer delivery status.
  ///
  /// Rejected is an order status, not a delivery status,
  /// therefore it returns null.
  static OrderDeliveryStatus? deliveryStatusForStage(
    DeliveryStage stage,
  ) {
    return switch (stage) {
      DeliveryStage.orderPlaced => null,
      DeliveryStage.packed => OrderDeliveryStatus.processing,
      DeliveryStage.shipped => OrderDeliveryStatus.shipped,
      DeliveryStage.outForDelivery => OrderDeliveryStatus.outForDelivery,
      DeliveryStage.delivered => OrderDeliveryStatus.delivered,
      DeliveryStage.rejected => null,
    };
  }

  static bool canAdvanceDeliveryStatus(
    OrderDeliveryStatus? current,
    OrderDeliveryStatus next,
  ) {
    if (current == null) {
      return next == OrderDeliveryStatus.processing;
    }

    const flow = [
      OrderDeliveryStatus.processing,
      OrderDeliveryStatus.shipped,
      OrderDeliveryStatus.outForDelivery,
      OrderDeliveryStatus.delivered,
    ];

    final currentIndex = flow.indexOf(current);
    final nextIndex = flow.indexOf(next);

    if (currentIndex < 0 || nextIndex < 0) {
      return false;
    }

    return nextIndex == currentIndex + 1;
  }

  static bool canAdvancePaymentStatus(
    OrderPaymentStatus current,
    OrderPaymentStatus next,
  ) {
    const flow = [
      OrderPaymentStatus.unpaid,
      OrderPaymentStatus.paymentReceived,
      OrderPaymentStatus.paymentConfirmed,
    ];

    final currentIndex = flow.indexOf(current);
    final nextIndex = flow.indexOf(next);

    if (currentIndex < 0 || nextIndex < 0) {
      return false;
    }

    return nextIndex == currentIndex + 1;
  }

  static OrderPaymentStatus paymentStatusAfterVendorMarkPaid(
    OrderPaymentStatus current,
  ) {
    return switch (current) {
      OrderPaymentStatus.unpaid => OrderPaymentStatus.paymentReceived,

      OrderPaymentStatus.paymentReceived => OrderPaymentStatus.paymentConfirmed,

      OrderPaymentStatus.paymentConfirmed =>
        OrderPaymentStatus.paymentConfirmed,
    };
  }

  static String deliveryStatusLabel(
    OrderDeliveryStatus status,
  ) {
    return switch (status) {
      OrderDeliveryStatus.processing => 'processing',
      OrderDeliveryStatus.shipped => 'shipped',
      OrderDeliveryStatus.outForDelivery => 'out for delivery',
      OrderDeliveryStatus.delivered => 'delivered',
    };
  }

  static OrderStatus orderStatusForDelivery(
    OrderDeliveryStatus deliveryStatus,
  ) {
    return switch (deliveryStatus) {
      OrderDeliveryStatus.processing => OrderStatus.processing,

      OrderDeliveryStatus.shipped => OrderStatus.shipped,

      OrderDeliveryStatus.outForDelivery => OrderStatus.shipped,

      OrderDeliveryStatus.delivered => OrderStatus.delivered,
    };
  }
}
