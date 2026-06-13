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

  Future<Admin> requireAdminProfile(Session session) async {
    final user = await SessionService.requireRole(session, {UserRole.admin});
    final existing = await findByUserId(session, user.id!);
    if (existing != null) return existing;

    return Admin.db.insertRow(
      session,
      Admin(
        userId: user.id!,
        title: 'Platform Administrator',
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
    String title, {
    String? department,
    bool? isActive,
  }) async {
    final user = await SessionService.requireRole(session, {UserRole.admin});
    if (title.trim().isEmpty) {
      throw PlaceifyException(
        'Admin title is required.',
        code: 'INVALID_ADMIN_PROFILE',
      );
    }

    final existing = await findByUserId(session, user.id!);
    if (existing == null) {
      return Admin.db.insertRow(
        session,
        Admin(
          userId: user.id!,
          title: title.trim(),
          department: department?.trim(),
          isActive: isActive ?? true,
        ),
      );
    }

    return Admin.db.updateRow(
      session,
      existing.copyWith(
        title: title.trim(),
        department: department?.trim(),
        isActive: isActive ?? existing.isActive,
      ),
    );
  }
}
