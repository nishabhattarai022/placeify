import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/vendor/domain/constants/vendor_routes.dart';
import '../widgets/placeify_bottom_nav.dart';

class MainShell extends StatelessWidget {
  const MainShell({required this.child, super.key});

  final Widget child;

  int _consumerActiveIndex(String location) {
    if (location == '/home') return 0;
    if (location == '/browse') return 1;
    if (location == '/bookmarks') return 2;
    if (location == '/profile' || location.startsWith('/profile/')) {
      return 3;
    }
    if (location.startsWith('/browse/category') ||
        location.startsWith('/category') ||
        location.startsWith('/product')) {
      return -1;
    }
    return 0;
  }

  int _vendorActiveIndex(String location) {
    if (location.startsWith('${VendorRoutes.prefix}/orders')) return 1;
    if (location.startsWith('${VendorRoutes.prefix}/products')) return 2;
    if (location.startsWith('${VendorRoutes.prefix}/payments')) return 3;
    if (location.startsWith('${VendorRoutes.prefix}/profile')) return 4;
    if (location == VendorRoutes.dashboard ||
        location.startsWith(VendorRoutes.prefix)) {
      return 0;
    }
    return 0;
  }

  bool _showConsumerNav(String location) {
    if (location.startsWith('/vendor')) return false;
    if (location.startsWith('/product/')) return false;
    if (location.startsWith('/browse/category')) return false;
    if (location == '/cart') return false;
    if (location == '/profile/augmented-reality') return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final showConsumerNav = _showConsumerNav(location);
    final showVendorNav = location.startsWith('/vendor');

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: child,
      bottomNavigationBar: showConsumerNav
          ? SafeArea(
              top: false,
              child: PlaceifyBottomNav(
                activeIndex: _consumerActiveIndex(location),
              ),
            )
          : showVendorNav
              ? SafeArea(
                  top: false,
                  child: PlaceifyBottomNav(
                    activeIndex: _vendorActiveIndex(location),
                    mode: PlaceifyBottomNavMode.vendor,
                  ),
                )
              : null,
    );
  }
}
