import 'package:placeify/features/auth/domain/models/app_user.dart';
import 'package:placeify/features/vendor/domain/constants/vendor_routes.dart';
import 'package:placeify/features/vendor/domain/constants/vendor_strings.dart';
import 'package:placeify/features/vendor/domain/enums/vendor_status.dart';

class VendorAuthRedirect {
  const VendorAuthRedirect({required this.location, this.toastMessage});

  final String location;
  final String? toastMessage;
}

abstract final class VendorAuthGuard {
  static VendorAuthRedirect? evaluate({
    required String location,
    required AppUser? user,
  }) {
    if (!location.startsWith(VendorRoutes.prefix)) return null;

    final status = user?.vendorStatus ?? VendorStatus.none;

    if (_isRegistrationRoute(location)) {
      return switch (status) {
        VendorStatus.approved => const VendorAuthRedirect(
            location: VendorRoutes.dashboard,
          ),
        VendorStatus.pending || VendorStatus.suspended => const VendorAuthRedirect(
            location: VendorRoutes.profileFallback,
          ),
        VendorStatus.none => null,
      };
    }

    return switch (status) {
      VendorStatus.none => const VendorAuthRedirect(
          location: VendorRoutes.register,
        ),
      VendorStatus.pending => const VendorAuthRedirect(
          location: VendorRoutes.profileFallback,
          toastMessage: VendorStrings.guardPendingToast,
        ),
      VendorStatus.suspended => const VendorAuthRedirect(
          location: VendorRoutes.profileFallback,
          toastMessage: VendorStrings.guardSuspendedToast,
        ),
      VendorStatus.approved => null,
    };
  }

  static bool _isRegistrationRoute(String location) {
    return location == VendorRoutes.register ||
        location == VendorRoutes.registerSuccess;
  }
}
