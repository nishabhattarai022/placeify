import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../order/order_lifecycle_store.dart';
import 'in_app_notification_store.dart';

/// Dispatches customer- and vendor-facing order events.
///
/// Persists in-app notifications and logs FCM integration hooks.
abstract final class OrderNotificationService {
  static final InAppNotificationStore _notifications = InAppNotificationStore();

  static Future<void> notifyVendorNewOrder(
    Session session, {
    required Order order,
    required UuidValue vendorId,
    required String customerName,
    required int itemCount,
  }) async {
    final vendorUserId = await _notifications.vendorUserId(session, vendorId);
    if (vendorUserId == null) return;

    final orderLabel = _orderLabel(order);
    final title = 'New order received';
    final body = 'New order #$orderLabel received from $customerName';

    await _notifications.create(
      session,
      userId: vendorUserId,
      title: title,
      message: body,
      type: InAppNotificationType.orderPlaced,
      referenceId: order.id,
    );

    session.log(
      'VendorNotification event=new_order vendorId=$vendorId '
      'orderId=${order.id} items=$itemCount',
      level: LogLevel.info,
    );
  }

  static Future<void> notifyOrderAccepted(
    Session session, {
    required Order order,
    required UuidValue vendorId,
  }) async {
    final orderLabel = _orderLabel(order);
    await _notifyCustomer(
      session,
      order: order,
      title: 'Order accepted',
      body: 'Your order #$orderLabel has been accepted by the vendor.',
      type: InAppNotificationType.orderAccepted,
      event: 'order_accepted',
    );
  }

  static Future<void> notifyOrderRejected(
    Session session, {
    required Order order,
    required String reason,
  }) async {
    final orderLabel = _orderLabel(order);
    await _notifyCustomer(
      session,
      order: order,
      title: 'Order update',
      body: 'Your order #$orderLabel was rejected. $reason',
      type: InAppNotificationType.orderCancelled,
      event: 'order_rejected',
    );
  }

  static Future<void> notifyOrderAutoCancelled(
    Session session, {
    required Order order,
    InAppNotificationStore? notifications,
  }) async {
    final store = notifications ?? _notifications;
    final orderLabel = _orderLabel(order);
    final userId = order.userId;
    if (userId == null) return;

    await store.create(
      session,
      userId: userId,
      title: 'Order cancelled',
      message:
          'Your order #$orderLabel has been automatically cancelled as the '
          'vendor did not respond in time.',
      type: InAppNotificationType.orderCancelled,
      referenceId: order.id,
    );

    session.log(
      'OrderNotification event=order_auto_cancelled orderId=${order.id}',
      level: LogLevel.info,
    );
  }

  static Future<void> notifyDeliveryStatus(
    Session session, {
    required Order order,
    required OrderDeliveryStatus status,
    required UuidValue vendorId,
  }) async {
    final orderLabel = _orderLabel(order);
    final statusLabel = OrderLifecycleStore.deliveryStatusLabel(status);

    await _notifyCustomer(
      session,
      order: order,
      title: 'Delivery update',
      body: 'Your order #$orderLabel is now $statusLabel.',
      type: InAppNotificationType.deliveryUpdate,
      event: 'delivery_${status.name}',
    );
  }

  static Future<void> notifyDeliveryStage(
    Session session, {
    required Order order,
    required DeliveryStage stage,
    required UuidValue vendorId,
  }) async {
    final deliveryStatus = OrderLifecycleStore.deliveryStatusForStage(stage);
    if (deliveryStatus == null) return;

    await notifyDeliveryStatus(
      session,
      order: order,
      status: deliveryStatus,
      vendorId: vendorId,
    );
  }

  static Future<void> notifyPaymentStatus(
    Session session, {
    required Order order,
    required OrderPaymentStatus status,
    required UuidValue vendorId,
  }) async {
    final orderLabel = _orderLabel(order);
    final body = status == OrderPaymentStatus.paymentConfirmed
        ? 'Payment for order #$orderLabel has been confirmed.'
        : 'Payment for order #$orderLabel has been received.';

    await _notifyCustomer(
      session,
      order: order,
      title: 'Payment update',
      body: body,
      type: InAppNotificationType.paymentUpdate,
      event: 'payment_${status.name}',
    );
  }

  static Future<void> notifyRefundDecision(
    Session session, {
    required RefundRequest refund,
    required bool approved,
  }) async {
    await _notifyCustomerByUserId(
      session,
      userId: refund.userId,
      title: approved ? 'Refund approved' : 'Refund update',
      body: approved
          ? 'Your refund request was approved.'
          : 'Your refund request was reviewed.',
      event: approved ? 'refund_approved' : 'refund_rejected',
    );
  }

  static Future<void> _notifyCustomer(
    Session session, {
    required Order order,
    required String title,
    required String body,
    required InAppNotificationType type,
    required String event,
  }) async {
    await _notifyCustomerByUserId(
      session,
      userId: order.userId,
      title: title,
      body: body,
      type: type,
      referenceId: order.id,
      event: event,
    );
  }

  static Future<void> _notifyCustomerByUserId(
    Session session, {
    required UuidValue? userId,
    required String title,
    required String body,
    required String event,
    InAppNotificationType? type,
    int? referenceId,
  }) async {
    if (userId == null) return;

    if (type != null) {
      await _notifications.create(
        session,
        userId: userId,
        title: title,
        message: body,
        type: type,
        referenceId: referenceId,
      );
    }

    session.log(
      'OrderNotification event=$event userId=$userId title=$title body=$body',
      level: LogLevel.info,
    );
  }

  static String _orderLabel(Order order) {
    final id = order.id;
    if (id == null) return 'pending';
    return id.toString().padLeft(5, '0');
  }
}
