import 'package:placeify_client/placeify_client.dart' show UserAccountStatus;

import '../domain/enums/user_role.dart';
import '../domain/models/admin_audit_log_entry.dart';
import '../domain/models/admin_notification.dart';
import '../domain/models/admin_stats.dart';
import '../domain/models/platform_user.dart';
import '../domain/repositories/admin_repository.dart';
import 'mock/mock_admin_repository.dart';
import 'serverpod_admin_api.dart';

/// Delegates dashboard stats to local seed data and moderation to Serverpod.
class HybridAdminRepository implements AdminRepository {
  HybridAdminRepository(this._fallback, this._api);

  final MockAdminRepository _fallback;
  final ServerpodAdminApi _api;

  @override
  Future<AdminStats> getStats() => _fallback.getStats();

  @override
  Future<List<PlatformUser>> listUsers({String? query, UserRole? role}) =>
      _fallback.listUsers(query: query, role: role);

  @override
  Future<List<AdminAuditLogEntry>> getAuditLog({int limit = 50}) =>
      _fallback.getAuditLog(limit: limit);

  @override
  Future<List<AdminNotification>> getNotifications() =>
      _fallback.getNotifications();

  @override
  Future<void> markNotificationRead(String notificationId) =>
      _fallback.markNotificationRead(notificationId);

  @override
  Future<void> markAllNotificationsRead() =>
      _fallback.markAllNotificationsRead();

  @override
  Future<void> suspendVendor(String userId, {String? reason}) async {
    await _api.suspendVendor(
      userId,
      reason: reason ?? 'Suspended by admin',
    );
    await _fallback.suspendVendor(userId, reason: reason);
  }

  @override
  Future<void> reinstateVendor(
    String userId, {
    bool termsAccepted = true,
    String? termsNote,
  }) async {
    if (!termsAccepted) {
      throw UnsupportedError('Terms must be accepted.');
    }
    await _api.reactivateVendor(
      userId,
      termsAccepted: termsAccepted,
      termsNote: termsNote,
    );
    await _fallback.reinstateVendor(
      userId,
      termsAccepted: termsAccepted,
      termsNote: termsNote,
    );
  }
}
