import 'package:flutter/material.dart';

import 'bottom_nav/admin_bottom_nav.dart';
import 'bottom_nav/consumer_bottom_nav.dart';
import 'bottom_nav/vendor_bottom_nav.dart';

export 'bottom_nav/bottom_nav_tokens.dart' show BottomNavTokens;

enum PlaceifyBottomNavMode { consumer, vendor, admin }

/// Facade for consumer gooey nav vs vendor/admin full-width pill nav.
class PlaceifyBottomNav extends StatelessWidget {
  const PlaceifyBottomNav({
    super.key,
    required this.activeIndex,
    this.mode = PlaceifyBottomNavMode.consumer,
  });

  /// Consumer: 0 home, 1 browse, 2 bookmarks, 3 profile.
  /// Vendor: 0 dashboard, 1 orders, 2 products, 3 payments, 4 profile.
  /// Admin: 0 dashboard, 1 approvals, 2 vendors, 3 settings.
  final int activeIndex;
  final PlaceifyBottomNavMode mode;

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case PlaceifyBottomNavMode.vendor:
        return VendorBottomNav(activeIndex: activeIndex);
      case PlaceifyBottomNavMode.admin:
        return AdminBottomNav(activeIndex: activeIndex);
      case PlaceifyBottomNavMode.consumer:
        return ConsumerBottomNav(activeIndex: activeIndex);
    }
  }
}
