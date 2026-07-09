import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_routes.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_notification_badge_provider.dart';

import '../../services/haptic_service.dart';
import 'bottom_nav_pill_widgets.dart';

/// Vendor navigation — same floating pill pattern as [ConsumerBottomNav].
class VendorBottomNav extends ConsumerWidget {
  const VendorBottomNav({
    required this.activeIndex,
    super.key,
  });

  final int activeIndex;

  static void _goDashboard(BuildContext context) =>
      context.go(VendorRoutes.dashboard);
  static void _goOrders(BuildContext context) => context.go(VendorRoutes.orders);
  static void _goProducts(BuildContext context) =>
      context.go(VendorRoutes.products);
  static void _goPayments(BuildContext context) =>
      context.go(VendorRoutes.payments);
  static void _goProfile(BuildContext context) =>
      context.go(VendorRoutes.profile);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = activeIndex.clamp(0, 4);
    final notificationBadgeCount =
        ref.watch(vendorNotificationBadgeCountProvider);

    return BottomNavBarShell(
      children: [
        BottomNavPrimaryChip(
          label: 'Dashboard',
          icon: Icons.dashboard_outlined,
          isSelected: index == 0,
          onTap: () {
            HapticService.light();
            _goDashboard(context);
          },
        ),
        const BottomNavItemGap(),
        BottomNavIconButton(
          icon: Icons.inventory_2_outlined,
          isSelected: index == 1,
          semanticLabel: 'Orders',
          badgeCount: notificationBadgeCount,
          onTap: () {
            HapticService.light();
            _goOrders(context);
          },
        ),
        const BottomNavItemGap(),
        BottomNavIconButton(
          assetPath: 'assets/icons/ic_package.svg',
          isSelected: index == 2,
          semanticLabel: 'Products',
          onTap: () {
            HapticService.light();
            _goProducts(context);
          },
        ),
        const BottomNavItemGap(),
        BottomNavIconButton(
          assetPath: 'assets/icons/ic_trending_up.svg',
          isSelected: index == 3,
          semanticLabel: 'Payments',
          onTap: () {
            HapticService.light();
            _goPayments(context);
          },
        ),
        const BottomNavItemGap(),
        BottomNavIconButton(
          icon: Icons.person_outline,
          isSelected: index == 4,
          semanticLabel: 'Profile',
          onTap: () {
            HapticService.light();
            _goProfile(context);
          },
        ),
      ],
    );
  }
}
