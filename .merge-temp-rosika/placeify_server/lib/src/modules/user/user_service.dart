import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/session_service.dart';
import 'user_repository.dart';

class UserService {
  UserService({UserProfileStore? repository})
      : _repository = repository ?? UserProfileStore();

  final UserProfileStore _repository;

  Future<User?> getCurrentUser(Session session) async {
    final auth = session.authenticated;
    if (auth == null) return null;

    final authUserId = UuidValue.fromString(auth.userIdentifier);
    final existing = await _repository.findByAuthUserId(session, authUserId);
    if (existing != null) return existing;

    // Backfill profiles for accounts created before onAfterAccountCreated ran.
    return _repository.upsertProfile(session, authUserId, 'User');
  }

  Future<User> updateProfile(
    Session session,
    String name, {
    String? phone,
    String? address,
  }) async {
    final authUserId =
        UuidValue.fromString(session.authenticated!.userIdentifier);
    return _repository.upsertProfile(
      session,
      authUserId,
      name,
      phone: phone,
      address: address,
    );
  }

  Future<User> becomeVendor(Session session) async {
    final user = await SessionService.requireUser(session);
    if (user.role == UserRole.admin) return user;

    final shop = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(user.id!),
    );
    if (shop == null) {
      throw PlaceifyException(message: 'Complete vendor registration before switching to vendor mode.',
        code: 'SHOP_NOT_FOUND',
      );
    }

    return User.db.updateRow(
      session,
      user.copyWith(role: UserRole.vendor),
    );
  }

  Future<User> becomeConsumer(Session session) async {
    final user = await SessionService.requireUser(session);
    if (user.role == UserRole.admin) return user;
    if (user.role == UserRole.consumer) return user;

    return User.db.updateRow(
      session,
      user.copyWith(role: UserRole.consumer),
    );
  }

  Future<UserDashboard> getDashboard(Session session) async {
    final user = await SessionService.requireUser(session);
    return _repository.buildDashboard(session, user);
  }
}
