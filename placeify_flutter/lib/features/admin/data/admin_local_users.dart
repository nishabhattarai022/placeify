import 'dart:convert';

import 'package:placeify_flutter/features/admin/data/config/admin_seed_data.dart';
import 'package:placeify_flutter/features/admin/domain/enums/user_role.dart';
import 'package:placeify_flutter/features/auth/domain/models/app_user.dart';
import 'package:placeify_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Loads platform users for mock admin repositories when Serverpod auth
/// does not expose [AuthRepository.getAllUsers].
abstract final class AdminLocalUsers {
  static Future<List<AppUser>> load(
    AuthRepository authRepository,
    SharedPreferences prefs,
  ) async {
    try {
      return await authRepository.getAllUsers();
    } on UnsupportedError {
      await AdminSeedData.ensureSeeded(prefs);
      return _loadFromPrefs(prefs);
    }
  }

  static List<AppUser> _loadFromPrefs(SharedPreferences prefs) {
    final raw = prefs.getString(AdminSeedData.authUsersKey);
    if (raw == null || raw.isEmpty) return const [];

    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((entry) => _fromJson(entry as Map<String, dynamic>)).toList();
  }

  static AppUser _fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      role: json['role'] != null
          ? UserRole.values.byName(json['role'] as String)
          : UserRole.customer,
      vendorStatus: json['vendorStatus'] != null
          ? VendorStatus.values.byName(json['vendorStatus'] as String)
          : VendorStatus.none,
      vendorId: json['vendorId'] as String?,
    );
  }
}
