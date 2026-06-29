import '../domain/enums/user_role.dart';
import '../domain/enums/vendor_application_list_filter.dart';
import '../domain/models/admin_audit_log_entry.dart';
import '../domain/models/admin_notification.dart';
import '../domain/models/admin_stats.dart';
import '../domain/models/platform_user.dart';
import '../domain/models/vendor_application.dart';
import '../domain/repositories/admin_repository.dart';
import '../domain/repositories/vendor_application_repository.dart';

/// Tries the remote Serverpod repository first, then falls back to local mock
/// data so the admin UI remains usable while backend endpoints are in progress.
class ResilientAdminRepository implements AdminRepository {
  ResilientAdminRepository({
    required AdminRepository remote,
    required AdminRepository local,
  })  : _remote = remote,
        _local = local;

  final AdminRepository _remote;
  final AdminRepository _local;

  @override
  Future<AdminStats> getStats() async {
    try {
      return await _remote.getStats();
    } catch (_) {
      return _local.getStats();
    }
  }

  @override
  Future<List<PlatformUser>> listUsers({String? query, UserRole? role}) async {
    try {
      return await _remote.listUsers(query: query, role: role);
    } catch (_) {
      return _local.listUsers(query: query, role: role);
    }
  }

  @override
  Future<List<AdminAuditLogEntry>> getAuditLog({int limit = 50}) async {
    try {
      return await _remote.getAuditLog(limit: limit);
    } catch (_) {
      return _local.getAuditLog(limit: limit);
    }
  }

  @override
  Future<List<AdminNotification>> getNotifications() async {
    try {
      return await _remote.getNotifications();
    } catch (_) {
      return _local.getNotifications();
    }
  }

  @override
  Future<void> markNotificationRead(String notificationId) async {
    try {
      await _remote.markNotificationRead(notificationId);
    } catch (_) {
      await _local.markNotificationRead(notificationId);
    }
  }

  @override
  Future<void> markAllNotificationsRead() async {
    try {
      await _remote.markAllNotificationsRead();
    } catch (_) {
      await _local.markAllNotificationsRead();
    }
  }

  @override
  Future<void> suspendVendor(String userId, {String? reason}) async {
    try {
      await _remote.suspendVendor(userId, reason: reason);
    } catch (_) {
      await _local.suspendVendor(userId, reason: reason);
    }
  }

  @override
  Future<void> reinstateVendor(String userId) async {
    try {
      await _remote.reinstateVendor(userId);
    } catch (_) {
      await _local.reinstateVendor(userId);
    }
  }
}

class ResilientVendorApplicationRepository
    implements VendorApplicationRepository {
  ResilientVendorApplicationRepository({
    required VendorApplicationRepository remote,
    required VendorApplicationRepository local,
  })  : _remote = remote,
        _local = local;

  final VendorApplicationRepository _remote;
  final VendorApplicationRepository _local;

  @override
  Future<List<VendorApplication>> listApplications({
    VendorApplicationListFilter? filter,
  }) async {
    try {
      return await _remote.listApplications(filter: filter);
    } catch (_) {
      return _local.listApplications(filter: filter);
    }
  }

  @override
  Future<VendorApplication?> getByVendorId(String vendorId) async {
    try {
      return await _remote.getByVendorId(vendorId);
    } catch (_) {
      return _local.getByVendorId(vendorId);
    }
  }

  @override
  Future<void> approve({
    required String userId,
    required String vendorId,
  }) async {
    try {
      await _remote.approve(userId: userId, vendorId: vendorId);
    } catch (_) {
      await _local.approve(userId: userId, vendorId: vendorId);
    }
  }

  @override
  Future<void> decline({
    required String userId,
    String? note,
  }) async {
    try {
      await _remote.decline(userId: userId, note: note);
    } catch (_) {
      await _local.decline(userId: userId, note: note);
    }
  }
}
