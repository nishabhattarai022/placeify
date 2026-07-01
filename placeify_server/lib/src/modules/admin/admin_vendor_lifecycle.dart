import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';

/// Shared rules for admin vendor approval, listing, and suspension.
abstract final class AdminVendorLifecycle {
  static bool isApprovedActiveVendor(User user, Vendor vendor) {
    if (user.status == UserAccountStatus.suspended ||
        user.status == UserAccountStatus.rejected) {
      return false;
    }

    if (user.status == UserAccountStatus.pending &&
        user.role != UserRole.vendor &&
        vendor.approvedAt == null) {
      return false;
    }

    return user.role == UserRole.vendor ||
        vendor.approvedAt != null ||
        user.status == UserAccountStatus.approved;
  }

  static UserAccountStatus effectiveAccountStatus(User user, Vendor vendor) {
    if (user.status == UserAccountStatus.suspended) {
      return UserAccountStatus.suspended;
    }
    if (user.status == UserAccountStatus.rejected) {
      return UserAccountStatus.rejected;
    }
    if (isApprovedActiveVendor(user, vendor)) {
      return UserAccountStatus.approved;
    }
    return user.status;
  }

  static bool matchesListFilter(
    User user,
    Vendor vendor,
    UserAccountStatus filter,
  ) {
    return switch (filter) {
      UserAccountStatus.pending => user.status == UserAccountStatus.pending,
      UserAccountStatus.rejected => user.status == UserAccountStatus.rejected,
      UserAccountStatus.suspended => user.status == UserAccountStatus.suspended,
      UserAccountStatus.approved => isApprovedActiveVendor(user, vendor),
    };
  }

  static void ensureCanSuspend(User user, Vendor vendor) {
    if (user.status == UserAccountStatus.rejected) {
      throw PlaceifyException(
        message: 'Rejected vendors cannot be suspended.',
        code: 'INVALID_VENDOR_STATUS',
      );
    }

    if (user.status == UserAccountStatus.pending &&
        user.role != UserRole.vendor &&
        vendor.approvedAt == null) {
      throw PlaceifyException(
        message: 'Vendor application is still pending approval.',
        code: 'INVALID_VENDOR_STATUS',
      );
    }

    if (!isApprovedActiveVendor(user, vendor)) {
      throw PlaceifyException(
        message: 'Only approved vendors can be suspended.',
        code: 'INVALID_VENDOR_STATUS',
      );
    }
  }
}
