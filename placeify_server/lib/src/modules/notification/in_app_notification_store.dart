import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';

/// Persists in-app notifications and read state.
class InAppNotificationStore {
  Future<InAppNotification> create(
    Session session, {
    required UuidValue userId,
    required String title,
    required String message,
    required InAppNotificationType type,
    int? referenceId,
  }) async {
    return InAppNotification.db.insertRow(
      session,
      InAppNotification(
        userId: userId,
        title: title,
        message: message,
        type: type,
        referenceId: referenceId,
      ),
    );
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

  /// Notifies every active admin (used for vendor applications, flags, etc.).
  ///
  /// [referenceKey] is accepted for call-site compatibility; this schema stores
  /// only integer [referenceId], so keys are ignored.
  Future<void> notifyActiveAdmins(
    Session session, {
    required String title,
    required String message,
    required InAppNotificationType type,
    int? referenceId,
    String? referenceKey,
  }) async {
    final admins = await Admin.db.find(
      session,
      where: (row) => row.isActive.equals(true),
    );

    for (final admin in admins) {
      await create(
        session,
        userId: admin.userId,
        title: title,
        message: message,
        type: type,
        referenceId: referenceId,
      );
    }
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
