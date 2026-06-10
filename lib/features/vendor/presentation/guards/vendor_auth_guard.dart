import 'package:placeify/features/auth/domain/models/app_user.dart';
import 'package:placeify/features/vendor/domain/constants/vendor_routes.dart';
import 'package:placeify/features/vendor/domain/enums/vendor_status.dart';

abstract final class VendorAuthGuard {
  static String? redirect({required String location, required AppUser? user}) {
    if (!location.startsWith(VendorRoutes.prefix)) return null;
    // Phase 2: if (location == VendorRoutes.register) return null;
    if (user?.vendorStatus != VendorStatus.approved) {
      return VendorRoutes.profileFallback;
    }
    return null;
  }
}
