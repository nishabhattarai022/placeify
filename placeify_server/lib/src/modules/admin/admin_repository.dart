import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/session_service.dart';

/// Admin profile storage and lookups.
class AdminStore {
  Future<Admin?> findByUserId(Session session, UuidValue userId) {
    return Admin.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(userId),
      include: Admin.include(user: User.include()),
    );
  }

  Future<bool> hasAdminProfile(Session session) async {
    final user = await SessionService.requireUser(session);
    if (user.role != UserRole.admin || !user.isActive) return false;
    final profile = await findByUserId(session, user.id!);
    if (profile == null) return true;
    return profile.isActive;
  }

  Future<int> countActiveAdmins(Session session) {
    return User.db.count(
      session,
      where: (row) =>
          row.role.equals(UserRole.admin) &
          row.isActive.equals(true) &
          row.deletedAt.equals(null),
    );
  }

  Admin _profileFromUser(User user) {
    return Admin(
      userId: user.id!,
      fullName: user.name,
      email: user.email ?? '',
      phoneNumber: user.phone,
      adminType: AdminType.moderator,
    );
  }

  Future<Admin> requireAdminProfile(Session session) async {
    final user = await SessionService.requireRole(session, {UserRole.admin});
    if (!user.isActive) {
      throw PlaceifyException(
        message: 'Your admin account is inactive.',
        code: 'FORBIDDEN',
      );
    }

    final existing = await findByUserId(session, user.id!);
    if (existing != null) {
      if (!existing.isActive) {
        throw PlaceifyException(
          message: 'Your admin account is inactive.',
          code: 'FORBIDDEN',
        );
      }
      return existing;
    }

    return Admin.db.insertRow(session, _profileFromUser(user));
  }

  /// Promotes the first admin when none exist (self only). Otherwise requires
  /// an existing active admin to promote another user.
  Future<Admin> bootstrapFirstAdmin(Session session) async {
    final adminCount = await countActiveAdmins(session);
    if (adminCount > 0) {
      throw PlaceifyException(
        message: 'An admin account already exists.',
        code: 'ADMIN_BOOTSTRAP_FORBIDDEN',
      );
    }

    final user = await SessionService.requireUser(session);
    return _promoteUserToAdmin(
      session,
      user,
      adminType: AdminType.super_admin,
    );
  }

  Future<Admin> promoteToAdmin(
    Session session,
    UuidValue targetUserId, {
    AdminType adminType = AdminType.moderator,
  }) async {
    await requireAdminProfile(session);

    final target = await User.db.findById(session, targetUserId);
    if (target == null || target.deletedAt != null) {
      throw PlaceifyException(
        message: 'User not found.',
        code: 'USER_NOT_FOUND',
      );
    }

    return _promoteUserToAdmin(session, target, adminType: adminType);
  }

  /// Ensures [target] has [UserRole.admin] and an active [Admin] profile row.
  Future<Admin> ensureAdminAccount(
    Session session,
    User target, {
    AdminType adminType = AdminType.moderator,
  }) {
    return _promoteUserToAdmin(session, target, adminType: adminType);
  }

  Future<Admin> _promoteUserToAdmin(
    Session session,
    User target, {
    required AdminType adminType,
  }) async {
    final now = DateTime.now();
    final email = target.email?.trim().toLowerCase() ?? '';
    if (email.isEmpty) {
      throw PlaceifyException(
        message: 'User must have an email before becoming an admin.',
        code: 'INVALID_ADMIN_PROFILE',
      );
    }

    final updatedUser = target.role == UserRole.admin
        ? target
        : await User.db.updateRow(
            session,
            target.copyWith(
              role: UserRole.admin,
              status: UserAccountStatus.approved,
              isActive: true,
              updatedAt: now,
            ),
          );

    final existing = await findByUserId(session, updatedUser.id!);
    if (existing != null) {
      return Admin.db.updateRow(
        session,
        existing.copyWith(
          fullName: updatedUser.name,
          email: email,
          phoneNumber: updatedUser.phone,
          adminType: adminType,
          isActive: true,
          updatedAt: now,
        ),
      );
    }

    return Admin.db.insertRow(
      session,
      Admin(
        userId: updatedUser.id!,
        fullName: updatedUser.name,
        email: email,
        phoneNumber: updatedUser.phone,
        adminType: adminType,
        isActive: true,
        updatedAt: now,
      ),
    );
  }

  Future<Admin?> getMyAdmin(Session session) async {
    final user = await SessionService.requireUser(session);
    if (user.role != UserRole.admin) return null;
    return findByUserId(session, user.id!);
  }

  Future<Admin> updateMyAdmin(
    Session session,
    String fullName, {
    String? email,
    String? phoneNumber,
    AdminType? adminType,
    bool? isActive,
  }) async {
    final user = await SessionService.requireRole(session, {UserRole.admin});
    if (fullName.trim().isEmpty) {
      throw PlaceifyException(
        message: 'Admin full name is required.',
        code: 'INVALID_ADMIN_PROFILE',
      );
    }

    final existing = await findByUserId(session, user.id!);
    final now = DateTime.now();
    if (existing == null) {
      return Admin.db.insertRow(
        session,
        _profileFromUser(user).copyWith(
          fullName: fullName.trim(),
          email: email?.trim().toLowerCase() ?? user.email ?? '',
          phoneNumber: phoneNumber?.trim() ?? user.phone,
          adminType: adminType ?? AdminType.moderator,
          isActive: isActive ?? true,
          updatedAt: now,
        ),
      );
    }

    return Admin.db.updateRow(
      session,
      existing.copyWith(
        fullName: fullName.trim(),
        email: email?.trim().toLowerCase() ?? existing.email,
        phoneNumber: phoneNumber?.trim() ?? existing.phoneNumber,
        adminType: adminType ?? existing.adminType,
        isActive: isActive ?? existing.isActive,
        updatedAt: now,
      ),
    );
  }
}
