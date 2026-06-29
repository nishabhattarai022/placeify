import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';

/// Persists in-app notifications and read state.
class InAppNotificationStore {
  static String userChannel(UuidValue userId) => 'in_app_$userId';

  Future<InAppNotification> create(
    Session session, {
    required UuidValue userId,
    required String title,
    required String message,
    required InAppNotificationType type,
    int? referenceId,
  }) async {
    final row = await InAppNotification.db.insertRow(
      session,
      InAppNotification(
        userId: userId,
        title: title,
        message: message,
        type: type,
        referenceId: referenceId,
      ),
    );
    final summary = _toSummary(row);
    await _broadcastSummary(session, userId, summary);
    return row;
  }

  Future<void> _broadcastSummary(
    Session session,
    UuidValue userId,
    InAppNotificationSummary summary,
  ) async {
    final channel = userChannel(userId);
    final useRedis = session.serverpod.redisController != null;
    // #region agent log
    _agentLog(
      'in_app_notification_store.dart:_broadcastSummary',
      'broadcast notification',
      {
        'channel': channel,
        'notificationId': summary.id,
        'type': summary.type.name,
        'useRedis': useRedis,
      },
      hypothesisId: 'H1',
    );
    // #endregion
    if (useRedis) {
      await session.messages.postMessage(channel, summary, global: true);
    } else {
      await session.messages.postMessage(channel, summary, global: false);
    }
  }

  Future<void> createAsync(
    Session session, {
    required UuidValue userId,
    required String title,
    required String message,
    required InAppNotificationType type,
    int? referenceId,
  }) async {
    await create(
      session,
      userId: userId,
      title: title,
      message: message,
      type: type,
      referenceId: referenceId,
    );
  }

  Future<List<InAppNotificationSummary>> listForUser(
    Session session,
    UuidValue userId, {
    int limit = 50,
    int offset = 0,
  }) async {
    final rows = await InAppNotification.db.find(
      session,
      where: (row) => row.userId.equals(userId),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: limit,
      offset: offset,
    );

    return [for (final row in rows) _toSummary(row)];
  }

  Future<int> unreadCount(Session session, UuidValue userId) async {
    return InAppNotification.db.count(
      session,
      where: (row) => row.userId.equals(userId) & row.isRead.equals(false),
    );
  }

  Future<void> markRead(
    Session session,
    UuidValue userId,
    int notificationId,
  ) async {
    final row = await InAppNotification.db.findFirstRow(
      session,
      where: (notification) =>
          notification.id.equals(notificationId) &
          notification.userId.equals(userId),
    );
    if (row == null || row.isRead) return;

    await InAppNotification.db.updateRow(
      session,
      row.copyWith(isRead: true),
    );
  }

  Future<void> markAllRead(Session session, UuidValue userId) async {
    final unread = await InAppNotification.db.find(
      session,
      where: (row) => row.userId.equals(userId) & row.isRead.equals(false),
    );

    for (final row in unread) {
      await InAppNotification.db.updateRow(
        session,
        row.copyWith(isRead: true),
      );
    }
  }

  Future<UuidValue?> vendorUserId(
    Session session,
    UuidValue vendorId,
  ) async {
    final vendor = await Vendor.db.findById(session, vendorId);
    return vendor?.userId;
  }

  InAppNotificationSummary _toSummary(InAppNotification row) {
    return InAppNotificationSummary(
      id: row.id!,
      title: row.title,
      message: row.message,
      type: row.type,
      referenceId: row.referenceId,
      isRead: row.isRead,
      createdAt: row.createdAt,
    );
  }
}

// #region agent log
void _agentLog(
  String location,
  String message,
  Map<String, Object?> data, {
  required String hypothesisId,
}) {
  try {
    File('/Users/rosikagajurel/Documents/College/placeify/.cursor/debug-1d536e.log')
        .writeAsStringSync(
      '${jsonEncode({
        'sessionId': '1d536e',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'location': location,
        'message': message,
        'data': data,
        'hypothesisId': hypothesisId,
      })}\n',
      mode: FileMode.append,
    );
  } catch (_) {}
}
// #endregion
