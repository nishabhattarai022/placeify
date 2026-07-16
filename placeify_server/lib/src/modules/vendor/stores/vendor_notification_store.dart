import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../../../shared/session_service.dart';
import '../../notification/in_app_notification_store.dart';

/// Vendor in-app notification reads and read-state updates.
class VendorNotificationStore {
  VendorNotificationStore({InAppNotificationStore? notifications})
      : _notifications = notifications ?? InAppNotificationStore();

  final InAppNotificationStore _notifications;

  Future<List<VendorNotificationSummary>> listNotifications(
    Session session, {
    int limit = 50,
  }) async {
    final user = await SessionService.requireUser(session);
    final rows = await _notifications.listForUser(session, user.id!, limit: limit);

    return [
      for (final row in rows)
        if (_isVendorFacing(row))
          VendorNotificationSummary(
            id: row.id.toString(),
            type: _vendorNotificationType(row.type),
            title: row.title,
            body: row.message,
            isRead: row.isRead,
            createdAt: row.createdAt,
            relatedId: row.referenceId?.toString(),
            relatedKey: row.referenceKey,
          ),
    ];
  }

  /// Excludes customer-personal inbox rows when a vendor account shares a user.
  bool _isVendorFacing(InAppNotificationSummary row) {
    return switch (row.type) {
      InAppNotificationType.orderAccepted => false,
      InAppNotificationType.deliveryUpdate => false,
      InAppNotificationType.orderPlaced => row.title == 'New order received',
      InAppNotificationType.orderCancelled =>
        row.message.contains('cancelled by the customer'),
      _ => true,
    };
  }

  Future<void> markNotificationRead(Session session, int notificationId) async {
    final user = await SessionService.requireUser(session);
    await _notifications.markRead(session, user.id!, notificationId);
  }

  Future<void> markAllNotificationsRead(Session session) async {
    final user = await SessionService.requireUser(session);
    await _notifications.markAllRead(session, user.id!);
  }

  VendorNotificationType _vendorNotificationType(InAppNotificationType type) {
    return switch (type) {
      InAppNotificationType.orderPlaced => VendorNotificationType.order,
      InAppNotificationType.orderAccepted => VendorNotificationType.order,
      InAppNotificationType.orderCancelled => VendorNotificationType.order,
      InAppNotificationType.deliveryUpdate => VendorNotificationType.order,
      InAppNotificationType.paymentUpdate => VendorNotificationType.payment,
      InAppNotificationType.productUpdate => VendorNotificationType.product,
      InAppNotificationType.promotionUpdate => VendorNotificationType.product,
      InAppNotificationType.refundUpdate => VendorNotificationType.payment,
      InAppNotificationType.vendorApplication ||
      InAppNotificationType.vendorFlagged ||
      InAppNotificationType.systemAlert =>
        VendorNotificationType.product,
    };
  }
}
