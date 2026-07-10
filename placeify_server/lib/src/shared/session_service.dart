import 'package:serverpod/serverpod.dart';

import '../auth/auth_email_resolver.dart';
import '../generated/protocol.dart';
import '../modules/user/user_repository.dart';

/// Resolves authenticated Placeify users and their carts.
abstract final class SessionService {
  /// Returns the Placeify profile for the signed-in auth user, creating one if
  /// missing (e.g. accounts registered before [onAfterAccountCreated] ran).
  ///
  /// Always syncs [User.email] from the auth email account when available.
  static Future<User> requireUser(Session session) async {
    final auth = session.authenticated;
    if (auth == null) {
      throw PlaceifyException(
        message: 'Sign in to continue.',
        code: 'AUTH_REQUIRED',
      );
    }

    final authUserId = UuidValue.fromString(auth.userIdentifier);
    return _resolveOrCreateProfile(session, authUserId);
  }

  /// Same as [requireUser] but returns null when the session is not authenticated.
  static Future<User?> resolveUserIfAuthenticated(Session session) async {
    final auth = session.authenticated;
    if (auth == null) return null;

    final authUserId = UuidValue.fromString(auth.userIdentifier);
    return _resolveOrCreateProfile(session, authUserId);
  }

  static Future<User> _resolveOrCreateProfile(
    Session session,
    UuidValue authUserId,
  ) async {
    final store = UserProfileStore();
    final existing = await store.findByAuthUserId(session, authUserId);
    if (existing != null) {
      return AuthEmailResolver.syncProfileEmail(session, existing);
    }

    final authEmail = await AuthEmailResolver.findAuthEmail(
      session,
      authUserId,
    );
    final displayName = (authEmail != null && authEmail.contains('@'))
        ? authEmail.split('@').first
        : 'User';

    return store.upsertProfile(
      session,
      authUserId,
      displayName,
      email: authEmail,
    );
  }

  static Future<Cart> requireCart(Session session) async {
    final user = await requireUser(session);
    final existing = await Cart.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(user.id!),
    );
    if (existing != null) return existing;
    return Cart.db.insertRow(session, Cart(userId: user.id!));
  }

  static Future<User> requireRole(Session session, Set<UserRole> roles) async {
    final user = await requireUser(session);
    if (!roles.contains(user.role)) {
      throw PlaceifyException(
        message: 'You do not have permission to perform this action.',
        code: 'FORBIDDEN',
      );
    }
    return user;
  }
}
