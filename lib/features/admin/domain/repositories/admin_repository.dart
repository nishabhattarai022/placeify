import 'package:placeify/features/admin/domain/enums/user_role.dart';
import 'package:placeify/features/admin/domain/models/admin_audit_log_entry.dart';
import 'package:placeify/features/admin/domain/models/admin_notification.dart';
import 'package:placeify/features/admin/domain/models/admin_stats.dart';
import 'package:placeify/features/admin/domain/models/platform_user.dart';

/// Platform-wide admin operations contract (stats, users, vendors, audit).
abstract interface class AdminRepository {
  Future<AdminStats> getStats();

  Future<List<PlatformUser>> listUsers({String? query, UserRole? role});

  Future<List<AdminAuditLogEntry>> getAuditLog({int limit = 50});

  Future<List<AdminNotification>> getNotifications();

  Future<void> markNotificationRead(String notificationId);

  Future<void> markAllNotificationsRead();

  Future<void> suspendVendor(String userId, {String? reason});

  Future<void> reinstateVendor(String userId);
}
