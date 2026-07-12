import 'package:serverpod/serverpod.dart';

/// Server-side admin identity configuration (never ship these defaults in the app).
abstract final class AdminAuthConfig {
  static const defaultAdminEmail = 'admin@placeify.com';
  static const defaultAdminPassword = 'demo1234';
  static const defaultAdminName = 'Demo Admin';

  static String adminEmail(Session session) {
    final fromPasswords = session.passwords['adminEmail']?.trim().toLowerCase();
    if (fromPasswords != null && fromPasswords.isNotEmpty) {
      return fromPasswords;
    }
    return defaultAdminEmail;
  }

  static String adminPassword(Session session) {
    final fromPasswords = session.passwords['adminPassword'];
    if (fromPasswords != null && fromPasswords.isNotEmpty) {
      return fromPasswords;
    }
    return defaultAdminPassword;
  }
}
