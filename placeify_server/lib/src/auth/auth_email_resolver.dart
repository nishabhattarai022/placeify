import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../generated/protocol.dart';

/// Keeps Placeify [User.email] aligned with the auth [EmailAccount] email.
///
/// Auth email is the source of truth for login, password change, and reset.
abstract final class AuthEmailResolver {
  static Future<String?> findAuthEmail(
    Session session,
    UuidValue authUserId, {
    Transaction? transaction,
  }) async {
    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (row) => row.authUserId.equals(authUserId),
      transaction: transaction,
    );
    final email = account?.email.trim().toLowerCase();
    if (email == null || email.isEmpty) return null;
    return email;
  }

  /// Prefer auth account email; fall back to profile email only if needed.
  static Future<String> requireAuthEmail(Session session, User user) async {
    final authEmail = await findAuthEmail(session, user.authUserId);
    if (authEmail != null) return authEmail;

    final fromProfile = user.email?.trim().toLowerCase();
    if (fromProfile != null && fromProfile.isNotEmpty) {
      return fromProfile;
    }

    throw PlaceifyException(
      message: 'Email account not found.',
      code: 'EMAIL_NOT_FOUND',
    );
  }

  /// Writes the auth email onto the Placeify profile when missing or stale.
  static Future<User> syncProfileEmail(
    Session session,
    User user, {
    Transaction? transaction,
  }) async {
    final authEmail = await findAuthEmail(
      session,
      user.authUserId,
      transaction: transaction,
    );
    if (authEmail == null) return user;

    final current = user.email?.trim().toLowerCase() ?? '';
    if (current == authEmail) return user;

    return User.db.updateRow(
      session,
      user.copyWith(
        email: authEmail,
        updatedAt: DateTime.now(),
      ),
      transaction: transaction,
    );
  }
}
