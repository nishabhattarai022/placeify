import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/session_service.dart';

class NotificationStore {
  Future<NotificationPreference> getPreferences(Session session) async {
    final user = await SessionService.requireUser(session);
    final existing = await NotificationPreference.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(user.id!),
    );
    if (existing != null) return existing;

    return NotificationPreference.db.insertRow(
      session,
      NotificationPreference(userId: user.id!),
    );
  }

  Future<NotificationPreference> updatePreferences(
    Session session, {
    bool? orderUpdates,
    bool? refundStatus,
    bool? arReminders,
    bool? priceDropAlerts,
    bool? vendorMessages,
    bool? promotions,
  }) async {
    final current = await getPreferences(session);
    return NotificationPreference.db.updateRow(
      session,
      current.copyWith(
        orderUpdates: orderUpdates,
        refundStatus: refundStatus,
        arReminders: arReminders,
        priceDropAlerts: priceDropAlerts,
        vendorMessages: vendorMessages,
        promotions: promotions,
        updatedAt: DateTime.now(),
      ),
    );
  }
}
