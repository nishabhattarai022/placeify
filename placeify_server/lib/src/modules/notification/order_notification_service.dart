import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/order_display_number.dart';
import 'in_app_notification_store.dart';

abstract final class OrderNotificationService {
  static final InAppNotificationStore _notifications = InAppNotificationStore();

  static String _orderLabel(Order order) {
    return OrderDisplayNumber.formatNullable(order.id);
  }

  static Future<void> notifyVendorNewOrder(
    Session session, {
    required Order order,
    required UuidValue vendorId,
    required String customerName,
    required int itemCount,
  }) async {
    final vendorUserId = await _notifications.vendorUserId(session, vendorId);

    if (vendorUserId == null) return;

    await _notifications.create(
      session,
      userId: vendorUserId,
      title: 'New order received',
      message:
          'New order #${_orderLabel(order)} received from $customerName ($itemCount items).',
      type: InAppNotificationType.orderPlaced,
      referenceId: order.id,
    );
  }

  static Future<void> notifyCustomerOrderPlaced(
    Session session, {
    required Order order,
  }) async {
    await _notifyCustomer(
      session,
      order,
      title: 'Order placed',
      message:
          'Your order #${_orderLabel(order)} has been placed successfully.',
      type: InAppNotificationType.orderPlaced,
      event: 'order_placed',
    );
  }

  static Future<void> notifyOrderAccepted(
    Session session, {
    required Order order,
    required UuidValue vendorId,
  }) async {
    await _notifyCustomer(
      session,
      order,
      title: 'Order accepted',
      message:
          'Your order #${_orderLabel(order)} has been accepted by the vendor.',
      type: InAppNotificationType.orderAccepted,
      event: 'order_accepted',
    );
  }

  static Future<void> notifyOrderRejected(
    Session session, {
    required Order order,
    String? reason,
  }) async {
    await _notifyCustomer(
      session,
      order,
      title: 'Order rejected',
      message:
          'Your order #${_orderLabel(order)} was rejected.'
          '${reason == null ? '' : ' Reason: $reason'}',
      type: InAppNotificationType.orderCancelled,
      event: 'order_rejected',
    );
  }

  static Future<void> notifyDeliveryStage(
    Session session, {
    required Order order,
    required UuidValue vendorId,
    required DeliveryStage stage,
  }) async {
    await _notifyCustomer(
      session,
      order,
      title: 'Delivery update',
      message: 'Your order #${_orderLabel(order)} is now ${stage.name}.',
      type: InAppNotificationType.deliveryUpdate,
      event: 'delivery_${stage.name}',
    );
  }

  static Future<void> notifyPaymentStatus(
    Session session, {
    required Order order,
    required UuidValue vendorId,
    required OrderPaymentStatus status,
  }) async {
    await _notifyCustomer(
      session,
      order,
      title: 'Payment update',
      message:
          'Payment status for order #${_orderLabel(order)} is ${status.name}.',
      type: InAppNotificationType.paymentUpdate,
      event: 'payment_${status.name}',
    );
  }

  static Future<void> notifyOrderAutoCancelled(
    Session session, {
    required Order order,
  }) async {
    await _notifyCustomer(
      session,
      order,
      title: 'Order cancelled',
      message: 'Your order #${_orderLabel(order)} was automatically cancelled.',
      type: InAppNotificationType.orderCancelled,
      event: 'order_auto_cancelled',
    );
  }

  static Future<void> notifyVendorOrderCancelled(
    Session session, {
    required Order order,
    required UuidValue vendorId,
    required String reason,
  }) async {
    final vendorUserId = await _notifications.vendorUserId(session, vendorId);

    if (vendorUserId == null) return;

    await _notifications.create(
      session,
      userId: vendorUserId,
      title: 'Order cancelled',
      message: 'Order #${_orderLabel(order)} cancelled. Reason: $reason',
      type: InAppNotificationType.orderCancelled,
      referenceId: order.id,
    );
  }

  static Future<void> notifyCustomerPaymentAllocation(
    Session session, {
    required Order order,
    required PaymentTransactionStatus allocationStatus,
    required String note,
  }) async {
    await _notifyCustomer(
      session,
      order,
      title: 'Payment update',
      message: note.isEmpty
          ? 'Payment status for order #${_orderLabel(order)} is ${allocationStatus.name}.'
          : note,
      type: InAppNotificationType.paymentUpdate,
      event: 'payment_${allocationStatus.name}',
    );
  }

  static Future<void> notifyRefundCreated(
    Session session, {
    required RefundRequest refund,
    required Order order,
  }) async {
    final orderLabel = _orderLabel(order);
    final amount = refund.refundAmount.toStringAsFixed(2);

    await _notifyCustomerByUserId(
      session,
      userId: refund.userId,
      title: 'Refund requested',
      body:
          'Your refund request for order #$orderLabel (NPR $amount) is pending review.',
      type: InAppNotificationType.refundUpdate,
      referenceId: refund.id,
      event: 'refund_created',
    );

    await _notifyVendorsForOrder(
      session,
      orderId: order.id!,
      title: 'Refund requested',
      message:
          'Customer requested a refund on order #$orderLabel (NPR $amount).',
      referenceId: refund.id,
    );

    try {
      await _notifications.notifyActiveAdmins(
        session,
        title: 'Refund requested',
        message: 'Order #$orderLabel has a new refund request (NPR $amount).',
        type: InAppNotificationType.refundUpdate,
        referenceId: refund.id,
      );
    } catch (_) {}
  }

  static Future<void> notifyRefundDecision(
    Session session, {
    required RefundRequest refund,
    required bool approved,
    String? reason,
    bool completed = false,
  }) async {
    final orderLabel = OrderDisplayNumber.format(refund.orderId);
    final title = !approved
        ? 'Refund rejected'
        : completed
            ? 'Refund completed'
            : 'Refund approved';
    final body = !approved
        ? 'Your refund request for order #$orderLabel was rejected.'
            '${reason == null || reason.isEmpty ? '' : ' Reason: $reason'}'
        : completed
            ? 'Your refund for order #$orderLabel has been completed.'
            : 'Your refund for order #$orderLabel was approved and is processing.';

    await _notifyCustomerByUserId(
      session,
      userId: refund.userId,
      title: title,
      body: body,
      type: InAppNotificationType.refundUpdate,
      referenceId: refund.id,
      event: !approved
          ? 'refund_rejected'
          : completed
              ? 'refund_completed'
              : 'refund_approved',
    );

    await _notifyVendorsForOrder(
      session,
      orderId: refund.orderId,
      title: title,
      message: body,
      referenceId: refund.id,
    );

    try {
      await _notifications.notifyActiveAdmins(
        session,
        title: title,
        message: body,
        type: InAppNotificationType.refundUpdate,
        referenceId: refund.id,
      );
    } catch (_) {}
  }

  static Future<void> _notifyVendorsForOrder(
    Session session, {
    required int orderId,
    required String title,
    required String message,
    int? referenceId,
  }) async {
    final items = await OrderItem.db.find(
      session,
      where: (row) => row.orderId.equals(orderId),
    );
    final vendorIds = items.map((item) => item.vendorId).toSet();
    for (final vendorId in vendorIds) {
      final vendorUserId = await _notifications.vendorUserId(session, vendorId);
      if (vendorUserId == null) continue;
      await _notifications.create(
        session,
        userId: vendorUserId,
        title: title,
        message: message,
        type: InAppNotificationType.refundUpdate,
        referenceId: referenceId,
      );
    }
  }

  static Future<void> notifyConsumersNewProduct(
    Session session, {
    required Product product,
    required String vendorName,
  }) async {
    final users = await User.db.find(
      session,
      where: (u) => u.role.equals(UserRole.consumer),
      limit: 500,
    );

    for (final user in users) {
      if (user.id == null) continue;

      await _notifications.create(
        session,
        userId: user.id!,
        title: 'New product added',
        message: '$vendorName added ${product.name}',
        type: InAppNotificationType.productUpdate,
        referenceId: product.id,
      );
    }
  }

  static Future<void> notifyConsumersSpecialOffer(
    Session session, {
    required Product product,
    required String vendorName,
  }) async {
    await notifyConsumersNewProduct(
      session,
      product: product,
      vendorName: vendorName,
    );
  }

  static Future<void> _notifyCustomer(
    Session session,
    Order order, {
    required String title,
    required String message,
    required InAppNotificationType type,
    required String event,
  }) async {
    await _notifyCustomerByUserId(
      session,
      userId: order.userId,
      title: title,
      body: message,
      type: type,
      referenceId: order.id,
      event: event,
    );
  }

  static Future<void> _notifyCustomerByUserId(
    Session session, {
    required UuidValue userId,
    required String title,
    required String body,
    required InAppNotificationType type,
    required int? referenceId,
    required String event,
  }) async {
    await _notifications.create(
      session,
      userId: userId,
      title: title,
      message: body,
      type: type,
      referenceId: referenceId,
    );

    session.log(
      'Notification event=$event user=$userId',
      level: LogLevel.info,
    );
  }
}
