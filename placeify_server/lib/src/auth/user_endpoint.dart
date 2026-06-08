import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'placeify_endpoint.dart';

/// Endpoints for the Placeify application user profile linked to auth.
class UserEndpoint extends PlaceifyAuthenticatedEndpoint {
  /// Returns the logged-in user's Placeify profile, or null if not created yet.
  Future<User?> getCurrentUser(Session session) async {
    final authUserId = UuidValue.fromString(session.authenticated!.userIdentifier);
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
    final authUserId = UuidValue.fromString(session.authenticated!.userIdentifier);
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
          role: UserRole.consumer,
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

  /// Promotes the current user to vendor role (after vendor onboarding).
  Future<User> becomeVendor(Session session) async {
    final user = await requirePlaceifyUser(session);
    if (user.role == UserRole.admin) {
      return user;
    }
    return User.db.updateRow(
      session,
      user.copyWith(role: UserRole.vendor),
    );
  }
}
