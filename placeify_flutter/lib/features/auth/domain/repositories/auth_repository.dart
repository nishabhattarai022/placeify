import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';

import '../models/app_user.dart';

/// Auth API contract (mock implementation persists locally until a real API exists).
abstract interface class AuthRepository {
  Future<AppUser> register({
    required String fullName,
    required String email,
    required String password,
  });

  Future<AppUser> signIn({
    required String email,
    required String password,
  });

  Future<AppUser?> getCurrentUser();

  /// Confirms the signed-in user has an active admin profile on the server.
  Future<bool> verifyAdminAccess();

  /// Dedicated admin authorization (not consumer email login).
  Future<AppUser> signInAsAdmin({
    required String adminId,
    required String password,
  });

  /// All registered users (admin user-management and application joins).
  Future<List<AppUser>> getAllUsers();

  Future<void> signOut();

  Future<DateTime> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> requestPasswordReset({
    required String email,
  });

  Future<void> confirmPasswordReset({
    required String token,
    required String newPassword,
  });

  Future<AppUser> becomeVendor();

  Future<AppUser> becomeConsumer();

  /// Updates vendor onboarding status for the active session user.
  Future<void> updateVendorStatus({
    required VendorStatus status,
    String? vendorId,
  });

  /// Updates vendor onboarding status for any user (admin cross-user writes).
  Future<void> updateVendorStatusForUser({
    required String userId,
    required VendorStatus status,
    String? vendorId,
  });
}

class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
