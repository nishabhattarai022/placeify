/// Demo account for local mock / consumer QA sign-in.
///
/// Admin credentials are never shipped in the client. Use the Admin access
/// screen; the server validates against its configured admin identity.
abstract final class DemoCredentials {
  static const String email = 'placify@gmail.com';
  static const String password = 'demo1234';
  static const String fullName = 'Demo User';

  static const String hint = 'Demo: $email / $password';
}
