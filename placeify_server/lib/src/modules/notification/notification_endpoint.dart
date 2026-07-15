import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'notification_service.dart';

/// Notification preference management for profile settings.
class NotificationEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final _service = NotificationService();

  Future<NotificationPreference> getPreferences(Session session) {
    return _service.getPreferences(session);
  }

  Future<NotificationPreference> updatePreferences(
    Session session, {
    bool? orderUpdates,
    bool? refundStatus,
    bool? arReminders,
    bool? priceDropAlerts,
    bool? vendorMessages,
    bool? promotions,
  }) {
    return _service.updatePreferences(
      session,
      orderUpdates: orderUpdates,
      refundStatus: refundStatus,
      arReminders: arReminders,
      priceDropAlerts: priceDropAlerts,
      vendorMessages: vendorMessages,
      promotions: promotions,
    );
  }

  Future<List<InAppNotificationSummary>> listInAppNotifications(
    Session session, {
    int limit = 50,
    int offset = 0,
  }) {
    return _service.listInAppNotifications(
      session,
      limit: limit,
      offset: offset,
    );
  }

  Future<int> unreadInAppNotificationCount(Session session) {
    return _service.unreadInAppNotificationCount(session);
  }

  Future<void> markInAppNotificationRead(
    Session session,
    int notificationId,
  ) {
    return _service.markInAppNotificationRead(session, notificationId);
  }

  Future<void> markAllInAppNotificationsRead(Session session) {
    return _service.markAllInAppNotificationsRead(session);
  }

  Stream<InAppNotificationSummary> watchInAppNotifications(Session session) {
    return _service.watchInAppNotifications(session);
  }
}
