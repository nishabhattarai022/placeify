import 'package:serverpod/serverpod.dart';

/// Structured audit logs for vendor profile mutations.
abstract final class VendorProfileAuditLog {
  static void profileUpdated(
    Session session, {
    required UuidValue vendorId,
    required String action,
  }) {
    session.log(
      'vendor_profile action=$action vendorId=$vendorId '
      'timestamp=${DateTime.now().toUtc().toIso8601String()}',
      level: LogLevel.info,
    );
  }

  static void logoUploaded(Session session, UuidValue vendorId) {
    profileUpdated(session, vendorId: vendorId, action: 'logo_upload');
  }

  static void bannerUploaded(Session session, UuidValue vendorId) {
    profileUpdated(session, vendorId: vendorId, action: 'banner_upload');
  }

  static void coverUploaded(Session session, UuidValue vendorId) {
    profileUpdated(session, vendorId: vendorId, action: 'cover_upload');
  }
}
