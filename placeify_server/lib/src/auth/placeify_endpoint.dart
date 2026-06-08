import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Base endpoint for authenticated Placeify APIs.
///
/// All user-specific endpoints (cart, orders, profile, vendor) should extend
/// this class so [requireLogin] is enforced consistently.
abstract class PlaceifyAuthenticatedEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Returns the Placeify profile for the authenticated user.
  Future<User> requirePlaceifyUser(Session session) async {
    final authUserId = UuidValue.fromString(session.authenticated!.userIdentifier);
    final user = await User.db.findFirstRow(
      session,
      where: (row) => row.authUserId.equals(authUserId),
    );
    if (user == null) {
      throw PlaceifyAuthException('User profile not found.');
    }
    return user;
  }

  /// Ensures the caller has one of [allowedRoles].
  Future<User> requireRole(
    Session session,
    Set<UserRole> allowedRoles,
  ) async {
    final user = await requirePlaceifyUser(session);
    if (!allowedRoles.contains(user.role)) {
      throw PlaceifyAuthException(
        'You do not have permission to perform this action.',
      );
    }
    return user;
  }
}

/// Authorization failure for role or profile checks.
class PlaceifyAuthException implements Exception {
  PlaceifyAuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
