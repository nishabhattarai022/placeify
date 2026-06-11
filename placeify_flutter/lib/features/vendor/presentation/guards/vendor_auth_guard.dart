import 'package:placeify_flutter/features/auth/domain/models/app_user.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_routes.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';

abstract final class VendorAuthGuard {
  static String? redirect({required String location, required AppUser? user}) {
    if (!location.startsWith(VendorRoutes.prefix)) return null;

    final status = user?.vendorStatus ?? VendorStatus.none;

    if (_isRegistrationRoute(location)) {
      if (status == VendorStatus.approved) {
        return VendorRoutes.dashboard;
      }
      if (status == VendorStatus.pending || status == VendorStatus.suspended) {
        return VendorRoutes.profileFallback;
      }
      return null;
    }

    if (status != VendorStatus.approved) {
      return VendorRoutes.profileFallback;
    }
    return null;
  }

  static bool _isRegistrationRoute(String location) {
    return location == VendorRoutes.register ||
        location == VendorRoutes.registerSuccess;
  }
}
