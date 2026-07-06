import 'package:serverpod/serverpod.dart' hide Order;

import '../../../generated/protocol.dart';
import '../../../shared/placeify_exception.dart';
import '../../../shared/session_service.dart';

/// Shared vendor authorization checks used across domain stores.
class VendorAccessGuard {
  Future<Vendor> requireVendorProfile(Session session) async {
    final user = await SessionService.requireRole(
      session,
      {UserRole.vendor, UserRole.admin},
    );

    final vendor = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(user.id!),
    );
    if (vendor == null) {
      throw PlaceifyException(
        message: 'Vendor profile not found.',
        code: 'VENDOR_NOT_FOUND',
      );
    }
    return vendor;
  }

  /// Resolves the vendor shop for the logged-in user.
  ///
  /// Does **not** mutate [User.role]. Vendor role is assigned only via admin
  /// approval ([AdminModerationStore.approveVendor]).
  Future<Vendor> requireOwnedVendor(
    Session session, {
    bool allowSuspended = false,
  }) async {
    final user = await SessionService.requireUser(session);
    final vendor = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(user.id!),
    );
    if (vendor == null) {
      throw PlaceifyException(
        message: 'Shop not found.',
        code: 'SHOP_NOT_FOUND',
      );
    }

    if (user.role != UserRole.vendor && user.role != UserRole.admin) {
      throw PlaceifyException(
        message: 'Vendor account is pending admin approval.',
        code: 'VENDOR_NOT_APPROVED',
      );
    }

    if (user.role != UserRole.admin &&
        user.status != UserAccountStatus.approved &&
        !(allowSuspended && user.status == UserAccountStatus.suspended)) {
      throw PlaceifyException(
        message: 'Vendor account is pending admin approval.',
        code: 'VENDOR_NOT_APPROVED',
      );
    }

    if (!user.isActive && !allowSuspended) {
      throw PlaceifyException(
        message: 'Vendor account is deactivated.',
        code: 'ACCOUNT_INACTIVE',
      );
    }

    return vendor;
  }

  Future<Vendor> requireSuspendedVendorForAppeal(Session session) async {
    final user = await SessionService.requireUser(session);
    if (user.role != UserRole.vendor) {
      throw PlaceifyException(
        message: 'Vendor profile not found.',
        code: 'VENDOR_NOT_FOUND',
      );
    }
    if (user.status != UserAccountStatus.suspended) {
      throw PlaceifyException(
        message: 'Only suspended vendors can submit an appeal.',
        code: 'NOT_SUSPENDED',
      );
    }

    final vendor = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(user.id!),
    );
    if (vendor == null) {
      throw PlaceifyException(
        message: 'Shop not found.',
        code: 'SHOP_NOT_FOUND',
      );
    }
    return vendor;
  }

  Future<bool> hasShop(Session session) async {
    final user = await SessionService.requireUser(session);
    final existing = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(user.id!),
    );
    return existing != null;
  }
}
