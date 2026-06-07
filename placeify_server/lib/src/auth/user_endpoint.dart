import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import '../generated/protocol.dart';

/// Endpoints for the Placeify application user profile linked to auth.
class UserEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Returns the logged-in user's Placeify profile, or null if not created yet.
  Future<User?> getCurrentUser(Session session) async {
    final authUserId = session.authenticated!.authUserId;
    return User.db.findFirstRow(
      session,
      where: (user) => user.authUserId.equals(authUserId),
    );
  }

  /// Creates or updates the Placeify profile for the logged-in user.
  Future<User> updateProfile(
    Session session,
    String name, {
    String? phone,
    String? address,
  }) async {
    final authUserId = session.authenticated!.authUserId;
    final existing = await User.db.findFirstRow(
      session,
      where: (user) => user.authUserId.equals(authUserId),
    );

    if (existing == null) {
      return User.db.insertRow(
        session,
        User(
          authUserId: authUserId,
          name: name,
          phone: phone,
          address: address,
        ),
      );
    }

    return User.db.updateRow(
      session,
      existing.copyWith(
        name: name,
        phone: phone,
        address: address,
      ),
    );
  }
}
