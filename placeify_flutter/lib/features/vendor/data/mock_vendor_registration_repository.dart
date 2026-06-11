import 'dart:convert';

import 'package:placeify_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_registration.dart';
import 'package:placeify_flutter/features/vendor/domain/repositories/vendor_registration_repository.dart';
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

    return vendorId;
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
