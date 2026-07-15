import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/session_service.dart';
import 'in_app_notification_store.dart';
import 'notification_repository.dart';

class NotificationService {
  NotificationService({
    NotificationStore? repository,
    InAppNotificationStore? inAppNotifications,
  })  : _repository = repository ?? NotificationStore(),
        _inAppNotifications = inAppNotifications ?? InAppNotificationStore();

  final NotificationStore _repository;
  final InAppNotificationStore _inAppNotifications;

  Future<NotificationPreference> getPreferences(Session session) {
    return _repository.getPreferences(session);
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
    return _repository.updatePreferences(
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
  }) async {
    final user = await SessionService.requireUser(session);
    return _inAppNotifications.listForUser(
      session,
      user.id!,
      limit: limit,
      offset: offset,
    );
  }

  Future<int> unreadInAppNotificationCount(Session session) async {
    final user = await SessionService.requireUser(session);
    return _inAppNotifications.unreadCount(session, user.id!);
  }

  Future<void> markInAppNotificationRead(
    Session session,
    int notificationId,
  ) async {
    final user = await SessionService.requireUser(session);
    await _inAppNotifications.markRead(session, user.id!, notificationId);
  }

  Future<void> markAllInAppNotificationsRead(Session session) async {
    final user = await SessionService.requireUser(session);
    await _inAppNotifications.markAllRead(session, user.id!);
  }

  Stream<InAppNotificationSummary> watchInAppNotifications(
    Session session,
  ) async* {
    final user = await SessionService.requireUser(session);
    yield* session.messages.createStream<InAppNotificationSummary>(
      InAppNotificationStore.userChannel(user.id!),
    );
  }
}
