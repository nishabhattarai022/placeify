import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_flutter/features/admin/domain/constants/admin_routes.dart';
import 'package:placeify_flutter/features/ar/presentation/widgets/ar_selection_done_bar.dart';
import 'package:placeify_flutter/features/messaging/presentation/providers/messaging_providers.dart';
import 'package:placeify_flutter/features/orders/presentation/providers/customer_in_app_notifications_provider.dart';
import 'package:placeify_flutter/features/orders/presentation/providers/orders_provider.dart';
import 'package:placeify_flutter/features/profile/presentation/providers/profile_dashboard_provider.dart';
import 'package:placeify_flutter/features/profile/presentation/providers/profile_refunds_provider.dart';
import 'package:placeify_flutter/features/shops/domain/constants/shop_routes.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_routes.dart';
import 'package:placeify_flutter/features/vendor/presentation/widgets/vendor_model_3d_build_poll.dart';
import 'package:placeify_flutter/features/vendor/presentation/widgets/vendor_model_3d_notification_listener.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../config/placeify_server_client.dart';
import '../widgets/placeify_bottom_nav.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    if (!client.auth.isAuthenticated) return;
    ref.read(customerInAppNotificationsProvider.notifier).refresh(silent: true);
    ref.read(ordersProvider.notifier).refresh(silent: true);
    ref.read(profileDashboardProvider.notifier).refresh(silent: true);
    ref.invalidate(profileRefundsProvider);
    ref.invalidate(messagingUnreadCountProvider(asVendor: false));
    ref.invalidate(conversationInboxProvider(asVendor: false));
  }

  int _consumerActiveIndex(String location) {
    if (location == '/home') return 0;
    if (location == '/my-ar') return 1;
    if (location == '/browse') return 2;
    if (location == '/bookmarks') return 3;
    if (location == '/profile' || location.startsWith('/profile/')) {
      return 4;
    }
    if (location == ShopRoutes.shops ||
        location.startsWith('${ShopRoutes.shops}/') ||
        location.startsWith('/browse/category') ||
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

  int _adminActiveIndex(String location) {
    if (location.startsWith(AdminRoutes.approvals)) return 1;
    if (location.startsWith(AdminRoutes.vendors)) return 2;
    if (location == AdminRoutes.settings) return 3;
    if (location == AdminRoutes.dashboard ||
        location.startsWith(AdminRoutes.prefix)) {
      return 0;
    }
    return 0;
  }

  bool _showConsumerNav(String location) {
    if (location.startsWith(AdminRoutes.prefix)) return false;
    if (location.startsWith('/vendor')) return false;
    if (location.startsWith('/product/')) return false;
    if (location.startsWith('/messages')) return false;
    if (location.startsWith('${ShopRoutes.shops}/')) return false;
    if (location.startsWith('/browse/category')) return false;
    if (location == '/cart') return false;
    if (location == '/profile/augmented-reality') return false;
    return true;
  }

  /// Vendor bottom nav only on tab roots — hide on pushed routes (upload, edit, etc.)
  /// so full-screen actions like Save are not covered.
  bool _showVendorNav(String location) {
    if (!location.startsWith(VendorRoutes.prefix)) return false;
    return VendorRoutes.tabRoots.contains(location);
  }

  /// Admin bottom nav only on tab roots — hide on pushed routes (detail, settings).
  bool _showAdminNav(String location) {
    if (!location.startsWith(AdminRoutes.prefix)) return false;
    return AdminRoutes.tabRoots.contains(location);
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final showConsumerNav = _showConsumerNav(location);
    final showVendorNav = _showVendorNav(location);
    final showAdminNav = _showAdminNav(location);

    return VendorModel3dBuildPoll(
      child: VendorModel3dNotificationListener(
        child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            widget.child,
            ArSelectionDoneBar(showAboveNav: showConsumerNav),
          ],
        ),
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
                : showAdminNav
                    ? SafeArea(
                        top: false,
                        child: PlaceifyBottomNav(
                          activeIndex: _adminActiveIndex(location),
                          mode: PlaceifyBottomNavMode.admin,
                        ),
                      )
                    : null,
        ),
      ),
    );
  }
}
