import 'dart:convert';

import 'package:placeify/features/admin/data/config/admin_seed_data.dart';
import 'package:placeify/features/admin/domain/enums/admin_notification_type.dart';
import 'package:placeify/features/admin/domain/models/admin_notification.dart';
import 'package:placeify/features/auth/domain/repositories/auth_repository.dart';
import 'package:placeify/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify/features/vendor/domain/models/vendor_registration.dart';
import 'package:placeify/features/vendor/domain/repositories/vendor_registration_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockVendorRegistrationRepository implements VendorRegistrationRepository {
  MockVendorRegistrationRepository(this._authRepository, this._prefs);

  final AuthRepository _authRepository;
  final SharedPreferences _prefs;

  static const _registrationsKey = 'placeify_vendor_registrations';

  @override
  bool simulateNetworkError = false;

  @override
  Future<String> submitRegistration(VendorRegistration registration) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (simulateNetworkError) {
      throw VendorRegistrationException(
        'Could not submit registration. Check your connection and try again.',
      );
    }

    final vendorId = 'vendor-${DateTime.now().millisecondsSinceEpoch}';

    await _authRepository.updateVendorStatus(
      status: VendorStatus.pending,
      vendorId: vendorId,
    );

    await _persistRegistration(vendorId, registration);
    await _appendAdminNotification(
      vendorId: vendorId,
      businessName: registration.business.businessName,
    );

    return vendorId;
  }

  Future<void> _appendAdminNotification({
    required String vendorId,
    required String businessName,
  }) async {
    final raw = _prefs.getString(AdminSeedData.notificationsKey);
    final existing = <AdminNotification>[];
    if (raw != null && raw.isNotEmpty) {
      final list = jsonDecode(raw) as List<dynamic>;
      existing.addAll(
        list.map(
          (e) => AdminNotification.fromJson(e as Map<String, dynamic>),
        ),
      );
    }

    existing.insert(
      0,
      AdminNotification(
        id: 'admin-n-${DateTime.now().millisecondsSinceEpoch}',
        title: 'New vendor application',
        body: '$businessName submitted a registration request.',
        createdAt: DateTime.now(),
        type: AdminNotificationType.newApplication,
        linkedVendorId: vendorId,
      ),
    );

    await _prefs.setString(
      AdminSeedData.notificationsKey,
      jsonEncode(existing.map((n) => n.toJson()).toList()),
    );
  }

  Future<void> _persistRegistration(
    String vendorId,
    VendorRegistration registration,
  ) async {
    final existing = _loadRegistrations();
    existing[vendorId] = {
      'vendorId': vendorId,
      'submittedAt': DateTime.now().toIso8601String(),
      ...registration.toJson(),
    };
    await _prefs.setString(_registrationsKey, jsonEncode(existing));
  }

  Map<String, dynamic> _loadRegistrations() {
    final raw = _prefs.getString(_registrationsKey);
    if (raw == null || raw.isEmpty) return {};

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return Map<String, dynamic>.from(decoded);
  }
}
