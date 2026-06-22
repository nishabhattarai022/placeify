import 'package:placeify_flutter/features/admin/domain/enums/user_role.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';

import 'app_user.dart';

extension AppUserX on AppUser {
  bool get isVendorMode => role == UserRole.vendor;

  bool get isVendorAccount =>
      isVendorMode || vendorStatus != VendorStatus.none;

  bool get hasVendorShop => vendorId != null && vendorId!.isNotEmpty;

  bool get canLoadVendorPortal =>
      isVendorAccount && vendorStatus == VendorStatus.approved;
}
