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

  /// All registered users (admin user-management and application joins).
  Future<List<AppUser>> getAllUsers();

  Future<void> signOut();

  /// Updates vendor onboarding status for the active session user.
  Future<void> updateVendorStatus({
    required VendorStatus status,
    String? vendorId,
  });

  /// Switches the active session to vendor mode (Serverpod role).
  Future<AppUser> becomeVendor();

  /// Switches the active session to consumer mode (Serverpod role).
  Future<AppUser> becomeConsumer();

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
