import 'package:flutter/material.dart';

import 'bottom_nav/consumer_bottom_nav.dart';
import 'bottom_nav/vendor_bottom_nav.dart';

export 'bottom_nav/bottom_nav_tokens.dart' show BottomNavTokens;

enum PlaceifyBottomNavMode { consumer, vendor }

/// Facade for consumer gooey nav vs vendor full-width pill nav.
class PlaceifyBottomNav extends StatelessWidget {
  const PlaceifyBottomNav({
    super.key,
    required this.activeIndex,
    this.mode = PlaceifyBottomNavMode.consumer,
  });

  /// Consumer: 0 home, 1 browse, 2 bookmarks, 3 profile.
  /// Vendor: 0 dashboard, 1 products, 2 store, 3 messages, 4 profile.
  final int activeIndex;
  final PlaceifyBottomNavMode mode;

  @override
  Widget build(BuildContext context) {
    if (mode == PlaceifyBottomNavMode.vendor) {
      return VendorBottomNav(activeIndex: activeIndex);
    }
    return ConsumerBottomNav(activeIndex: activeIndex);
  }
}
