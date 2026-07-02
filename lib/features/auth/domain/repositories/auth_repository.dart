import 'package:placeify/features/vendor/domain/enums/vendor_status.dart';

import '../models/app_user.dart';
import '../models/consumer_profile_details.dart';

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

  /// Updates vendor onboarding status for any user (admin cross-user writes).
  Future<void> updateVendorStatusForUser({
    required String userId,
    required VendorStatus status,
    String? vendorId,
  });

  Future<ConsumerProfileDetails?> getConsumerProfile();

  Future<AppUser> updateConsumerProfile(ConsumerProfileDetails profile);

  /// Sets a new password for the account matching [email] (no session required).
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  });
}

class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
