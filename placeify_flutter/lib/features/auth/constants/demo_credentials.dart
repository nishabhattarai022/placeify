/// Demo account for local mock sign-in (development / QA).
abstract final class DemoCredentials {
  static const String email = 'placify@gmail.com';
  static const String password = 'demo1234';
  static const String fullName = 'Demo User';

  static const String adminEmail = 'admin@placeify.com';
  /// Must satisfy Serverpod email-IdP policy (8+ chars, letters and numbers).
  static const String adminPassword = 'demo1234';
  static const String adminFullName = 'Demo Admin';
}
