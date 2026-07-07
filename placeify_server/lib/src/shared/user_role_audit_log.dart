import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Structured audit trail for [User.role] changes.
abstract final class UserRoleAuditLog {
  static void roleChanged(
    Session session, {
    required UuidValue userId,
    required UserRole previousRole,
    required UserRole newRole,
    required String source,
    UuidValue? changedByUserId,
    UuidValue? changedByAdminId,
  }) {
    session.log(
      'user_role_change userId=$userId '
      'previous=${previousRole.name} new=${newRole.name} '
      'source=$source '
      'changedByUserId=$changedByUserId '
      'changedByAdminId=$changedByAdminId '
      'timestamp=${DateTime.now().toUtc().toIso8601String()}',
      level: LogLevel.info,
    );
  }
}
