import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';

/// Dispatches customer-facing order events (push notifications hook).
///
/// Wire Firebase Cloud Messaging here once device tokens are stored. The vendor
/// order workflow calls these helpers so notification delivery stays decoupled
/// from repository transaction logic.
abstract final class OrderNotificationService {
  static Future<void> notifyOrderAccepted(
    Session session, {
    required Order order,
    required UuidValue vendorId,
  }) async {
    await _notifyCustomer(
      session,
      order: order,
      title: 'Order accepted',
      body: 'Your order #${_orderLabel(order)} was confirmed by the shop.',
      event: 'order_accepted',
    );
  }

  static Future<void> notifyDeliveryStage(
    Session session, {
    required Order order,
    required DeliveryStage stage,
    required UuidValue vendorId,
  }) async {
    final body = switch (stage) {
      DeliveryStage.orderPlaced => 'Your order was confirmed.',
      DeliveryStage.packed => 'Your order has been packed.',
      DeliveryStage.shipped => 'Your order is on the way.',
      DeliveryStage.outForDelivery => 'Your order is out for delivery.',
      DeliveryStage.delivered => 'Your order was delivered.',
    };

    await _notifyCustomer(
      session,
      order: order,
      title: 'Delivery update',
      body: body,
      event: 'delivery_${stage.name}',
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
    required String event,
  }) async {
    await _notifyCustomerByUserId(
      session,
      userId: order.userId,
      title: title,
      body: body,
      event: event,
    );
  }

  static Future<void> _notifyCustomerByUserId(
    Session session, {
    required UuidValue userId,
    required String title,
    required String body,
    required String event,
  }) async {
    // FCM integration point: look up device tokens for [userId] and publish.
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
