import 'dart:convert';

import 'package:placeify_flutter/features/admin/data/config/admin_seed_data.dart';
import 'package:placeify_flutter/features/admin/domain/enums/audit_action.dart';
import 'package:placeify_flutter/features/admin/domain/enums/user_role.dart';
import 'package:placeify_flutter/features/admin/domain/enums/vendor_application_list_filter.dart';
import 'package:placeify_flutter/features/admin/domain/models/admin_audit_log_entry.dart';
import 'package:placeify_flutter/features/admin/domain/models/admin_notification.dart';
import 'package:placeify_flutter/features/admin/domain/models/admin_stats.dart';
import 'package:placeify_flutter/features/admin/domain/models/platform_user.dart';
import 'package:placeify_flutter/features/admin/domain/repositories/admin_repository.dart';
import 'package:placeify_flutter/features/admin/domain/repositories/vendor_application_repository.dart';
import 'package:placeify_flutter/features/auth/domain/models/app_user.dart';
import 'package:placeify_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAdminRepository implements AdminRepository {
  MockAdminRepository(
    this._authRepository,
    this._prefs,
    this._vendorApplicationRepository,
  );

  final AuthRepository _authRepository;
  final SharedPreferences _prefs;
  final VendorApplicationRepository _vendorApplicationRepository;

  static const _auditLogKey = 'placeify_admin_audit_log';

  static const _mockPlatformGmv = 2_450_000.0;

  @override
  Future<AdminStats> getStats() async {
    await AdminSeedData.ensureSeeded(_prefs);

    final users = await _authRepository.getAllUsers();
    final applications = await _vendorApplicationRepository.listApplications();
    final declined = await _vendorApplicationRepository.listApplications(
      filter: VendorApplicationListFilter.declined,
    );
    final auditLog = _loadAuditLog()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    final approvedCount =
        users.where((u) => u.vendorStatus == VendorStatus.approved).length;

    return AdminStats(
      totalVendors: approvedCount,
      pendingCount:
          users.where((u) => u.vendorStatus == VendorStatus.pending).length,
      totalUsers: users.length,
      platformGmv: _mockPlatformGmv,
      approvedCount: approvedCount,
      declinedCount: declined.length,
      suspendedCount:
          users.where((u) => u.vendorStatus == VendorStatus.suspended).length,
      recentActivity: auditLog.take(10).toList(),
      signupSeries: _signupSeriesFor(users),
      recentApplications: applications.take(5).toList(),
    );
  }

  List<double> _signupSeriesFor(List<AppUser> users) {
    final now = DateTime.now();
    final counts = List<int>.filled(7, 0);

    for (final user in users) {
      final created = AdminSeedData.createdAtFor(user.id);
      final dayDiff = now.difference(created).inDays;
      if (dayDiff >= 0 && dayDiff < 7) {
        counts[6 - dayDiff]++;
      }
    }

    final max = counts.reduce((a, b) => a > b ? a : b);
    if (max == 0) return List<double>.filled(7, 0.15);
    return counts.map((c) => c / max).toList();
  }

  @override
  Future<List<PlatformUser>> listUsers({String? query, UserRole? role}) async {
    await AdminSeedData.ensureSeeded(_prefs);

    final users = await _authRepository.getAllUsers();
    final normalizedQuery = query?.trim().toLowerCase();

    var platformUsers = users.map(_toPlatformUser).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (role != null) {
      platformUsers = platformUsers.where((user) => user.role == role).toList();
    }

    if (normalizedQuery != null && normalizedQuery.isNotEmpty) {
      platformUsers = platformUsers
          .where(
            (user) =>
                user.name.toLowerCase().contains(normalizedQuery) ||
                user.email.toLowerCase().contains(normalizedQuery),
          )
          .toList();
    }

    return platformUsers;
  }

  @override
  Future<List<AdminAuditLogEntry>> getAuditLog({int limit = 50}) async {
    await AdminSeedData.ensureSeeded(_prefs);
    return _loadAuditLog().take(limit).toList();
  }

  @override
  Future<List<AdminNotification>> getNotifications() async {
    await AdminSeedData.ensureSeeded(_prefs);
    return _loadNotifications()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> markNotificationRead(String notificationId) async {
    final notifications = _loadNotifications();
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index == -1) return;

    notifications[index] = notifications[index].copyWith(read: true);
    await _saveNotifications(notifications);
  }

  @override
  Future<void> markAllNotificationsRead() async {
    final notifications = _loadNotifications()
        .map((n) => n.copyWith(read: true))
        .toList();
    await _saveNotifications(notifications);
  }

  @override
  Future<void> suspendVendor(String userId, {String? reason}) async {
    final user = await _findUser(userId);
    if (user?.vendorId == null) return;

    await _authRepository.updateVendorStatusForUser(
      userId: userId,
      status: VendorStatus.suspended,
      vendorId: user!.vendorId,
    );

    await _appendAuditLog(
      targetUserId: userId,
      action: const AdminAuditAction.vendor(action: AuditAction.suspended),
      note: reason,
    );
  }

  @override
  Future<void> reinstateVendor(
    String userId, {
    bool termsAccepted = true,
    String? termsNote,
  }) async {
    final user = await _findUser(userId);
    if (user?.vendorId == null) return;

    await _authRepository.updateVendorStatusForUser(
      userId: userId,
      status: VendorStatus.approved,
      vendorId: user!.vendorId,
    );

    await _appendAuditLog(
      targetUserId: userId,
      action: const AdminAuditAction.vendor(action: AuditAction.reinstated),
    );
  }

  PlatformUser _toPlatformUser(AppUser user) {
    return PlatformUser(
      id: user.id,
      name: user.fullName,
      email: user.email,
      role: user.role,
      vendorStatus: user.vendorStatus,
      vendorId: user.vendorId,
      createdAt: AdminSeedData.createdAtFor(user.id),
    );
  }

  Future<AppUser?> _findUser(String userId) async {
    final users = await _authRepository.getAllUsers();
    return users.where((u) => u.id == userId).firstOrNull;
  }

  List<AdminAuditLogEntry> _loadAuditLog() {
    final raw = _prefs.getString(_auditLogKey);
    if (raw == null || raw.isEmpty) return [];

    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map(
          (e) => AdminAuditLogEntry.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  List<AdminNotification> _loadNotifications() {
    final raw = _prefs.getString(AdminSeedData.notificationsKey);
    if (raw == null || raw.isEmpty) return [];

    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => AdminNotification.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveNotifications(List<AdminNotification> notifications) async {
    await _prefs.setString(
      AdminSeedData.notificationsKey,
      jsonEncode(notifications.map((n) => n.toJson()).toList()),
    );
  }

  Future<void> _appendAuditLog({
    required String targetUserId,
    required AdminAuditAction action,
    String? note,
  }) async {
    final admin = await _authRepository.getCurrentUser();
    final entry = AdminAuditLogEntry(
      id: 'audit-${DateTime.now().millisecondsSinceEpoch}',
      action: action,
      actorAdminId: admin?.id ?? AdminSeedData.demoAdminId,
      targetUserId: targetUserId,
      timestamp: DateTime.now(),
      note: note,
    );

    final existing = _loadAuditLog();
    existing.insert(0, entry);
    await _prefs.setString(
      _auditLogKey,
      jsonEncode(existing.map((e) => e.toJson()).toList()),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
