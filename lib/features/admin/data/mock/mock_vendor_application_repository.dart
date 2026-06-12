import 'dart:convert';

import 'package:placeify/features/admin/data/config/admin_seed_data.dart';
import 'package:placeify/features/admin/domain/enums/application_decision.dart';
import 'package:placeify/features/admin/domain/models/admin_audit_log_entry.dart';
import 'package:placeify/features/admin/domain/models/vendor_application.dart';
import 'package:placeify/features/admin/domain/repositories/vendor_application_repository.dart';
import 'package:placeify/features/auth/domain/models/app_user.dart';
import 'package:placeify/features/auth/domain/repositories/auth_repository.dart';
import 'package:placeify/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify/features/vendor/domain/models/vendor_registration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockVendorApplicationRepository implements VendorApplicationRepository {
  MockVendorApplicationRepository(this._authRepository, this._prefs);

  final AuthRepository _authRepository;
  final SharedPreferences _prefs;

  static const _auditLogKey = 'placeify_admin_audit_log';

  @override
  Future<List<VendorApplication>> listApplications({
    VendorStatus? filter,
  }) async {
    await AdminSeedData.ensureSeeded(_prefs);

    final users = await _authRepository.getAllUsers();
    final registrations = _loadRegistrations();
    final applications = <VendorApplication>[];

    for (final user in users) {
      final vendorId = user.vendorId;
      if (vendorId == null) continue;
      if (user.vendorStatus == VendorStatus.none) continue;

      final regData = registrations[vendorId];
      if (regData == null) continue;

      final application = _mapToApplication(user, regData);
      if (filter == null || application.status == filter) {
        applications.add(application);
      }
    }

    applications.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    return applications;
  }

  @override
  Future<VendorApplication?> getByVendorId(String vendorId) async {
    await AdminSeedData.ensureSeeded(_prefs);

    final users = await _authRepository.getAllUsers();
    final user = users.where((u) => u.vendorId == vendorId).firstOrNull;
    if (user == null) return null;

    final regData = _loadRegistrations()[vendorId];
    if (regData == null) return null;

    return _mapToApplication(user, regData);
  }

  @override
  Future<void> approve({
    required String userId,
    required String vendorId,
  }) async {
    await _authRepository.updateVendorStatusForUser(
      userId: userId,
      status: VendorStatus.approved,
      vendorId: vendorId,
    );

    await _appendAuditLog(
      targetUserId: userId,
      action: const AdminAuditAction.application(
        decision: ApplicationDecision.approved,
      ),
    );
  }

  @override
  Future<void> decline({
    required String userId,
    String? note,
  }) async {
    await _authRepository.updateVendorStatusForUser(
      userId: userId,
      status: VendorStatus.none,
      vendorId: null,
    );

    await _appendAuditLog(
      targetUserId: userId,
      action: const AdminAuditAction.application(
        decision: ApplicationDecision.declined,
      ),
      note: (note == null || note.trim().isEmpty) ? null : note.trim(),
    );
  }

  VendorApplication _mapToApplication(
    AppUser user,
    Map<String, dynamic> regData,
  ) {
    final registration = VendorRegistration.fromJson(
      Map<String, dynamic>.from(regData)..remove('vendorId')..remove('submittedAt'),
    );
    final submittedRaw = regData['submittedAt'] as String?;
    final submittedAt = submittedRaw != null
        ? DateTime.parse(submittedRaw)
        : DateTime.now();

    return VendorApplication(
      vendorId: user.vendorId!,
      userId: user.id,
      businessName: registration.business.businessName,
      contactEmail: registration.business.email,
      submittedAt: submittedAt,
      registration: registration,
      status: user.vendorStatus,
    );
  }

  Map<String, dynamic> _loadRegistrations() {
    final raw = _prefs.getString(AdminSeedData.registrationsKey);
    if (raw == null || raw.isEmpty) return {};

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return Map<String, dynamic>.from(decoded);
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
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
