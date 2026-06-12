import 'dart:convert';

import 'package:placeify/features/admin/data/config/admin_seed_data.dart';
import 'package:placeify/features/admin/domain/enums/audit_action.dart';
import 'package:placeify/features/admin/domain/models/admin_audit_log_entry.dart';
import 'package:placeify/features/admin/domain/models/admin_notification.dart';
import 'package:placeify/features/admin/domain/models/admin_stats.dart';
import 'package:placeify/features/admin/domain/models/platform_user.dart';
import 'package:placeify/features/admin/domain/repositories/admin_repository.dart';
import 'package:placeify/features/admin/domain/repositories/vendor_application_repository.dart';
import 'package:placeify/features/auth/domain/models/app_user.dart';
import 'package:placeify/features/auth/domain/repositories/auth_repository.dart';
import 'package:placeify/features/vendor/domain/enums/vendor_status.dart';
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

  @override
  Future<AdminStats> getStats() async {
    await AdminSeedData.ensureSeeded(_prefs);

    final users = await _authRepository.getAllUsers();
    final applications = await _vendorApplicationRepository.listApplications();

    return AdminStats(
      pendingCount: users
          .where((u) => u.vendorStatus == VendorStatus.pending)
          .length,
      approvedCount: users
          .where((u) => u.vendorStatus == VendorStatus.approved)
          .length,
      suspendedCount: users
          .where((u) => u.vendorStatus == VendorStatus.suspended)
          .length,
      totalUsers: users.length,
      recentApplications: applications.take(5).toList(),
    );
  }

  @override
  Future<List<PlatformUser>> listUsers({String? query}) async {
    await AdminSeedData.ensureSeeded(_prefs);

    final users = await _authRepository.getAllUsers();
    final normalizedQuery = query?.trim().toLowerCase();

    var platformUsers = users.map(_toPlatformUser).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

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
  Future<void> suspendVendor(String userId) async {
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
    );
  }

  @override
  Future<void> reinstateVendor(String userId) async {
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
