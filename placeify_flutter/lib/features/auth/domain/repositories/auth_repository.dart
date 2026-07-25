import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';

import '../models/app_user.dart';
import '../models/consumer_profile_details.dart';

/// Auth API contract backed by Serverpod email/JWT authentication.
abstract interface class AuthRepository {
  Future<AppUser> register({
    required String fullName,
    required String email,
    required String password,
  });

  /// Starts Email IDP registration and emails a magic link.
  /// Does not create a session or Placeify User until [verifyEmailRegistration].
  Future<String> beginEmailRegistration({
    required String fullName,
    required String email,
    required String password,
  });

  /// Completes registration after the user opens the verification link.
  Future<void> verifyEmailRegistration({
    required String token,
    required String password,
    String? fullName,
  });

  Future<void> resendVerificationEmail({
    required String email,
  });

  Future<AppUser> signIn({
    required String email,
    required String password,
  });

  Future<AppUser?> getCurrentUser();

  /// All registered users (admin user-management and application joins).
  Future<List<AppUser>> getAllUsers();

  Future<void> signOut();

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

  Future<ConsumerProfileDetails?> getConsumerProfile();

  Future<AppUser> updateConsumerProfile(ConsumerProfileDetails profile);

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
