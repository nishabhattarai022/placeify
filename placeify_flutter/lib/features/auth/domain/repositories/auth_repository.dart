import '../../../vendor/domain/enums/vendor_status.dart';
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

  Future<AppUser> becomeVendor();

  Future<AppUser> becomeConsumer();

  Future<AppUser> updateVendorStatus({
    required VendorStatus status,
    String? vendorId,
  });

  Future<void> signOut();
}

class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
