import 'package:placeify/features/vendor/domain/models/vendor_registration.dart';

/// Vendor onboarding submission contract (mock persists locally until a real API exists).
abstract interface class VendorRegistrationRepository {
  /// When true, [submitRegistration] throws to simulate a network failure.
  bool get simulateNetworkError;
  set simulateNetworkError(bool value);

  /// Submits the registration form and returns the assigned temporary vendor id.
  Future<String> submitRegistration(VendorRegistration registration);
}

class VendorRegistrationException implements Exception {
  VendorRegistrationException(this.message);

  final String message;

  @override
  String toString() => message;
}
