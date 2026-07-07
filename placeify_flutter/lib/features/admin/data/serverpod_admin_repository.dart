import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_client/serverpod_client.dart';

import '../../../core/config/placeify_server_client.dart';
import '../domain/enums/user_role.dart' as admin;
import '../domain/models/admin_audit_log_entry.dart';
import '../domain/models/admin_notification.dart';
import '../domain/models/admin_stats.dart';
import '../domain/models/platform_user.dart';
import '../domain/repositories/admin_repository.dart';
import 'admin_platform_mapper.dart';
import 'serverpod_admin_api.dart';

/// Serverpod-only admin repository for platform reads and moderation writes.
class ServerpodAdminRepository implements AdminRepository {
  ServerpodAdminRepository(this._api);

  final ServerpodAdminApi _api;

  @override
  Future<AdminStats> getStats() async {
    try {
      final stats = await client.admin.getPlatformStats();
      return AdminPlatformMapper.toAdminStats(stats);
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  @override
  Future<List<PlatformUser>> listUsers({
    String? query,
    admin.UserRole? role,
  }) async {
    try {
      final users = await client.admin.listUsers(
        query: query,
        role: AdminPlatformMapper.toApiRole(role),
      );
      return users.map(AdminPlatformMapper.toPlatformUser).toList();
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  @override
  Future<List<AdminAuditLogEntry>> getAuditLog({int limit = 50}) async {
    try {
      final entries = await client.admin.getAuditLog(limit: limit);
      return entries.map(AdminPlatformMapper.toAuditLogEntry).toList();
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  @override
  Future<List<AdminNotification>> getNotifications() async => const [];

  @override
  Future<void> markNotificationRead(String notificationId) async {}

  @override
  Future<void> markAllNotificationsRead() async {}

  @override
  Future<void> suspendVendor(String userId, {String? reason}) async {
    final trimmedReason = reason?.trim();
    await _api.suspendVendor(
      userId,
      reason: trimmedReason == null || trimmedReason.isEmpty
          ? 'Suspended by admin'
          : trimmedReason,
    );
  }

  @override
  Future<void> reinstateVendor(
    String userId, {
    bool termsAccepted = true,
    String? termsNote,
  }) async {
    await _api.reactivateVendor(
      userId,
      termsAccepted: termsAccepted,
      termsNote: termsNote,
    );
  }

  String _mapError(Object error) {
    if (error is AdminApiException) return error.message;
    if (error is PlaceifyException) return error.message;
    if (error is ServerpodClientException) return error.message;
    return error.toString();
  }
}
