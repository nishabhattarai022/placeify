import 'dart:convert';

import 'package:placeify_flutter/features/admin/data/config/admin_seed_data.dart';
import 'package:placeify_flutter/features/vendor/data/config/vendor_mock_config.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_profile.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_registration.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Builds and registers [VendorProfile] entries from persisted registrations.
abstract final class VendorProfileProvisioner {
  static bool ensureFromRegistration(String vendorId, SharedPreferences prefs) {
    if (VendorMockConfig.profileFor(vendorId) != null) return true;

    final regData = _loadRegistrations(prefs)[vendorId];
    if (regData == null) return false;

    final registration = VendorRegistration.fromJson(
      Map<String, dynamic>.from(regData)
        ..remove('vendorId')
        ..remove('submittedAt'),
    );
    final submittedRaw = regData['submittedAt'] as String?;
    final submittedAt = submittedRaw != null
        ? DateTime.parse(submittedRaw)
        : DateTime.now();
    final address = registration.address;

    VendorMockConfig.registerApprovedProfile(
      VendorProfile(
        id: vendorId,
        businessName: registration.business.businessName,
        email: registration.business.email,
        phone: registration.business.phone,
        address:
            '${address.street}, ${address.city}, ${address.state} ${address.postalCode}',
        category: registration.category.category,
        bio: registration.category.description,
        createdAt: submittedAt,
      ),
    );
    return true;
  }

  static Map<String, dynamic> _loadRegistrations(SharedPreferences prefs) {
    final raw = prefs.getString(AdminSeedData.registrationsKey);
    if (raw == null || raw.isEmpty) return {};

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return Map<String, dynamic>.from(decoded);
  }
}
