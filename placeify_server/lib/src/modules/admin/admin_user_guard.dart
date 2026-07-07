import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';

/// Centralized guards for admin user-management operations.
abstract final class AdminUserGuard {
  static void ensureCanModifyUser({
    required User actor,
    required User target,
  }) {
    if (target.role == UserRole.admin) {
      throw PlaceifyException(
        message: 'Admin accounts cannot be modified through this action.',
        code: 'FORBIDDEN',
      );
    }

    if (actor.id != null && target.id != null && actor.id == target.id) {
      throw PlaceifyException(
        message: 'You cannot perform this action on your own account.',
        code: 'FORBIDDEN',
      );
    }
  }

  static void ensureCanChangeStatus({
    required User actor,
    required User target,
    required UserAccountStatus newStatus,
  }) {
    ensureCanModifyUser(actor: actor, target: target);

    if (target.role == UserRole.admin) {
      throw PlaceifyException(
        message: 'Admin account status cannot be changed.',
        code: 'FORBIDDEN',
      );
    }
  }

  /// Reserved for future AdminType-based permission checks.
  static void ensureAdminType(
    Admin admin,
    Set<AdminType> allowedTypes,
  ) {
    if (!allowedTypes.contains(admin.adminType)) {
      throw PlaceifyException(
        message: 'Your admin role does not have permission for this action.',
        code: 'FORBIDDEN',
      );
    }
  }
}
