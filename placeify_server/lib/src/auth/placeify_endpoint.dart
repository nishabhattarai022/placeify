import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Base endpoint for authenticated Placeify APIs.
abstract class PlaceifyAuthenticatedEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<User> requirePlaceifyUser(Session session) async {
    final authUserId = UuidValue.fromString(
      session.authenticated!.userIdentifier,
    );
    final user = await User.db.findFirstRow(
      session,
      where: (row) => row.authUserId.equals(authUserId),
    );
    if (user == null) {
      throw PlaceifyAuthException('User profile not found.');
    }
    return user;
  }

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

class PlaceifyAuthException implements Exception {
  PlaceifyAuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
