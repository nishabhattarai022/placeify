import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'notification_repository.dart';

class NotificationService {
  NotificationService({NotificationStore? repository})
      : _repository = repository ?? NotificationStore();

  final NotificationStore _repository;

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
}
