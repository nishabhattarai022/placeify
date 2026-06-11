import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'placeify_exception.dart';

/// Resolves authenticated Placeify users and their carts.
abstract final class SessionService {
  static Future<User> requireUser(Session session) async {
    final auth = session.authenticated;
    if (auth == null) {
      throw PlaceifyException(message: 'Authentication required.', code: 'AUTH_REQUIRED');
    }

    final authUserId = UuidValue.fromString(auth.userIdentifier);
    final user = await User.db.findFirstRow(
      session,
      where: (row) => row.authUserId.equals(authUserId),
    );
    if (user == null) {
      throw PlaceifyException(message: 'User profile not found.', code: 'PROFILE_NOT_FOUND');
    }
    return user;
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
      throw PlaceifyException(message: 'You do not have permission to perform this action.',
        code: 'FORBIDDEN',
      );
    }
    return user;
  }
}
