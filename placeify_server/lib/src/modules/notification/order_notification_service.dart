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

  static Future<void> notifyCustomerOrderPlaced(
    Session session, {
    required Order order,
  }) async {
    final orderLabel = _orderLabel(order);
    await _notifyCustomer(
      session,
      order: order,
      title: 'Order placed',
      body: 'Your order #$orderLabel has been placed successfully.',
      type: InAppNotificationType.orderPlaced,
      event: 'order_placed',
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

    final orderLabel = _orderLabel(order);
    await _notifications.create(
      session,
      userId: vendorUserId,
      title: 'Order cancelled',
      message:
          'Order #$orderLabel was cancelled by the customer. Reason: $reason',
      type: InAppNotificationType.orderCancelled,
      referenceId: order.id,
    );

    session.log(
      'VendorNotification event=order_cancelled vendorId=$vendorId '
      'orderId=${order.id}',
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
    final body = switch (status) {
      OrderPaymentStatus.unpaid =>
        'Payment for order #$orderLabel is pending.',
      OrderPaymentStatus.paymentReceived =>
        'Payment for order #$orderLabel has been received.',
      OrderPaymentStatus.paymentConfirmed =>
        'Payment for order #$orderLabel has been confirmed.',
    };

    await _notifyCustomer(
      session,
      order: order,
      title: 'Payment update',
      body: body,
      type: InAppNotificationType.paymentUpdate,
      event: 'payment_${status.name}',
    );

    // Best-effort vendor notify so Orders/Payments/Dashboard refresh via
    // existing inAppNotificationEvents. Must never fail the payment response.
    if (status != OrderPaymentStatus.paymentReceived &&
        status != OrderPaymentStatus.paymentConfirmed) {
      return;
    }

    try {
      final vendorUserId = await _notifications.vendorUserId(session, vendorId);
      if (vendorUserId == null) return;

      final vendorBody = status == OrderPaymentStatus.paymentReceived
          ? 'Customer has completed payment for Order #$orderLabel.'
          : 'Payment for order #$orderLabel has been confirmed.';
      await _notifications.create(
        session,
        userId: vendorUserId,
        title: 'Payment received',
        message: vendorBody,
        type: InAppNotificationType.paymentUpdate,
        referenceId: order.id,
      );
      session.log(
        'VendorNotification event=payment_${status.name} '
        'vendorId=$vendorId orderId=${order.id}',
        level: LogLevel.info,
      );
    } catch (error, stackTrace) {
      session.log(
        'VendorNotification failed event=payment_${status.name} '
        'vendorId=$vendorId orderId=${order.id} error=$error',
        level: LogLevel.warning,
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  static Future<void> notifyCustomerPaymentAllocation(
    Session session, {
    required Order order,
    required PaymentTransactionStatus allocationStatus,
    required String note,
  }) async {
    final orderLabel = _orderLabel(order);
    final body = switch (allocationStatus) {
      PaymentTransactionStatus.failed =>
        'Payment for order #$orderLabel could not be processed.',
      PaymentTransactionStatus.refunded =>
        'Payment for order #$orderLabel has been refunded.',
      PaymentTransactionStatus.pending =>
        'Payment for order #$orderLabel is pending.',
      PaymentTransactionStatus.paid =>
        note.isNotEmpty ? note : 'Payment for order #$orderLabel was updated.',
      PaymentTransactionStatus.cancelled =>
        'Payment for order #$orderLabel was cancelled.',
    };

    await _notifyCustomer(
      session,
      order: order,
      title: 'Payment update',
      body: body,
      type: InAppNotificationType.paymentUpdate,
      event: 'payment_allocation_${allocationStatus.name}',
    );
  }

  static Future<void> notifyCustomerRefundSubmitted(
    Session session, {
    required RefundRequest refund,
  }) async {
    if (!await _allowsRefundStatus(session, refund.userId)) return;

    final orderLabel = refund.orderId.toString().padLeft(5, '0');
    await _notifyCustomerByUserId(
      session,
      userId: refund.userId,
      title: 'Refund request submitted',
      body:
          'We received your refund request for order #$orderLabel. '
          'The vendor will review it shortly.',
      type: InAppNotificationType.refundUpdate,
      referenceId: refund.id,
      event: 'refund_submitted',
    );
  }

  static Future<void> notifyConsumersNewProduct(
    Session session, {
    required Product product,
    required String vendorName,
  }) async {
    final title = 'New product added';
    final body = '$vendorName added ${product.name}.';
    final consumers = await User.db.find(
      session,
      where: (row) => row.role.equals(UserRole.consumer),
      limit: 500,
    );

    for (final consumer in consumers) {
      final userId = consumer.id;
      if (userId == null) continue;
      if (!await _allowsPromotions(session, userId)) continue;

      await _notifications.create(
        session,
        userId: userId,
        title: title,
        message: body,
        type: InAppNotificationType.productUpdate,
        referenceId: product.id,
      );
    }

    session.log(
      'MarketplaceNotification event=new_product productId=${product.id} '
      'recipients=${consumers.length}',
      level: LogLevel.info,
    );
  }

  static Future<void> notifyConsumersSpecialOffer(
    Session session, {
    required Product product,
    required String vendorName,
  }) async {
    final title = 'Special Offer available';
    final body = '${product.name} from $vendorName is now on sale.';
    final consumers = await User.db.find(
      session,
      where: (row) => row.role.equals(UserRole.consumer),
      limit: 500,
    );

    for (final consumer in consumers) {
      final userId = consumer.id;
      if (userId == null) continue;
      if (!await _allowsPromotions(session, userId)) continue;

      await _notifications.create(
        session,
        userId: userId,
        title: title,
        message: body,
        type: InAppNotificationType.promotionUpdate,
        referenceId: product.id,
      );
    }

    session.log(
      'MarketplaceNotification event=special_offer productId=${product.id} '
      'recipients=${consumers.length}',
      level: LogLevel.info,
    );
  }

  static Future<void> notifyVendorRefundRequest(
    Session session, {
    required RefundRequest refund,
    required UuidValue vendorId,
    required String customerName,
  }) async {
    final vendorUserId = await _notifications.vendorUserId(session, vendorId);
    if (vendorUserId == null) return;

    final orderLabel = refund.orderId.toString().padLeft(5, '0');
    await _notifications.create(
      session,
      userId: vendorUserId,
      title: 'Refund request',
      message:
          '$customerName requested a refund for order #$orderLabel.',
      type: InAppNotificationType.refundUpdate,
      referenceId: refund.id,
    );

    session.log(
      'VendorNotification event=refund_request vendorId=$vendorId '
      'refundId=${refund.id}',
      level: LogLevel.info,
    );
  }

  static Future<void> notifyRefundDecision(
    Session session, {
    required RefundRequest refund,
    required bool approved,
    String? reason,
  }) async {
    final trimmedReason = reason?.trim();
    final body = approved
        ? 'Your refund request for order '
            '#${refund.orderId.toString().padLeft(5, '0')} was approved. '
            'Payment has been marked as refunded.'
        : trimmedReason != null && trimmedReason.isNotEmpty
            ? 'Your refund request was rejected. $trimmedReason'
            : 'Your refund request was rejected.';

    if (!await _allowsRefundStatus(session, refund.userId)) return;

    await _notifyCustomerByUserId(
      session,
      userId: refund.userId,
      title: approved ? 'Refund approved' : 'Refund update',
      body: body,
      type: InAppNotificationType.refundUpdate,
      referenceId: refund.id,
      event: approved ? 'refund_approved' : 'refund_rejected',
    );
  }

  static Future<bool> _allowsPromotions(
    Session session,
    UuidValue userId,
  ) async {
    final prefs = await NotificationPreference.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(userId),
    );
    return prefs?.promotions ?? false;
  }

  static Future<bool> _allowsOrderUpdates(
    Session session,
    UuidValue? userId,
  ) async {
    if (userId == null) return false;
    final prefs = await NotificationPreference.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(userId),
    );
    return prefs?.orderUpdates ?? true;
  }

  static Future<bool> _allowsRefundStatus(
    Session session,
    UuidValue userId,
  ) async {
    final prefs = await NotificationPreference.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(userId),
    );
    return prefs?.refundStatus ?? true;
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

    if (type != null && !await _shouldNotify(session, userId, type)) return;

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

  static Future<bool> _shouldNotify(
    Session session,
    UuidValue userId,
    InAppNotificationType type,
  ) async {
    return switch (type) {
      InAppNotificationType.orderPlaced ||
      InAppNotificationType.orderAccepted ||
      InAppNotificationType.orderCancelled ||
      InAppNotificationType.deliveryUpdate ||
      InAppNotificationType.paymentUpdate =>
        _allowsOrderUpdates(session, userId),
      InAppNotificationType.refundUpdate =>
        _allowsRefundStatus(session, userId),
      InAppNotificationType.productUpdate ||
      InAppNotificationType.promotionUpdate =>
        _allowsPromotions(session, userId),
      InAppNotificationType.vendorApplication ||
      InAppNotificationType.vendorFlagged ||
      InAppNotificationType.systemAlert =>
        Future.value(true),
    };
  }

  static String _orderLabel(Order order) {
    final id = order.id;
    if (id == null) return 'pending';
    return id.toString().padLeft(5, '0');
  }
}
