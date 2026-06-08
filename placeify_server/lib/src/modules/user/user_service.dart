import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/session_service.dart';
import 'user_repository.dart';

class UserService {
  UserService({UserProfileStore? repository})
      : _repository = repository ?? UserProfileStore();

  final UserProfileStore _repository;

  Future<User?> getCurrentUser(Session session) async {
    final authUserId =
        UuidValue.fromString(session.authenticated!.userIdentifier);
    return _repository.findByAuthUserId(session, authUserId);
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
    return User.db.updateRow(
      session,
      user.copyWith(role: UserRole.vendor),
    );
  }

  Future<UserDashboard> getDashboard(Session session) async {
    final user = await SessionService.requireUser(session);
    return _repository.buildDashboard(session, user);
  }
}
