import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
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
    if (user.role != UserRole.admin) return false;
    final profile = await findByUserId(session, user.id!);
    return profile != null;
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
    final existing = await findByUserId(session, user.id!);
    if (existing != null) return existing;

    return Admin.db.insertRow(session, _profileFromUser(user));
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
    bool? newApplicationAlerts,
    bool? systemAlerts,
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
          newApplicationAlerts: newApplicationAlerts ?? true,
          systemAlerts: systemAlerts ?? true,
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
        newApplicationAlerts:
            newApplicationAlerts ?? existing.newApplicationAlerts,
        systemAlerts: systemAlerts ?? existing.systemAlerts,
        updatedAt: now,
      ),
    );
  }

  Future<Admin> updateNotificationPreferences(
    Session session, {
    required bool newApplicationAlerts,
    required bool systemAlerts,
  }) async {
    final profile = await requireAdminProfile(session);
    return Admin.db.updateRow(
      session,
      profile.copyWith(
        newApplicationAlerts: newApplicationAlerts,
        systemAlerts: systemAlerts,
        updatedAt: DateTime.now(),
      ),
    );
  }
}
