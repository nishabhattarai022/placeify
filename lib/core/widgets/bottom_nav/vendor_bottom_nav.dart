import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/features/vendor/domain/constants/vendor_routes.dart';
import 'package:placeify/features/vendor/presentation/providers/vendor_notification_badge_provider.dart';
import 'package:placeify/features/vendor/presentation/providers/vendor_profile_editor_provider.dart';

import '../../services/haptic_service.dart';
import 'bottom_nav_tokens.dart';
import 'nav_icon_tap.dart';

class _VendorTab {
  const _VendorTab({
    required this.icon,
    required this.label,
    required this.onTap,
    this.showNotificationBadge = false,
    this.showUnsavedBadge = false,
  });

  final String icon;
  final String label;
  final void Function(BuildContext context) onTap;
  final bool showNotificationBadge;
  final bool showUnsavedBadge;
}

/// Full-width pill bar with 5 labeled tabs (no protruding circle).
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

  static const _tabs = [
    _VendorTab(
      icon: 'assets/icons/ic_grid.svg',
      label: 'Dashboard',
      onTap: _goDashboard,
    ),
    _VendorTab(
      icon: 'assets/icons/ic_box.svg',
      label: 'Orders',
      onTap: _goOrders,
      showNotificationBadge: true,
    ),
    _VendorTab(
      icon: 'assets/icons/ic_package.svg',
      label: 'Products',
      onTap: _goProducts,
    ),
    _VendorTab(
      icon: 'assets/icons/ic_trending_up.svg',
      label: 'Payments',
      onTap: _goPayments,
    ),
    _VendorTab(
      icon: 'assets/icons/ic_user.svg',
      label: 'Profile',
      onTap: _goProfile,
      showUnsavedBadge: true,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = activeIndex.clamp(0, _tabs.length - 1);
    final notificationBadgeCount = ref.watch(vendorNotificationBadgeCountProvider);
    final hasUnsavedProfile = ref.watch(vendorProfileHasUnsavedChangesProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        BottomNavTokens.horizontalPadding,
        0,
        BottomNavTokens.horizontalPadding,
        BottomNavTokens.bottomPadding,
      ),
      child: Container(
        height: BottomNavTokens.pillHeight,
        decoration: BoxDecoration(
          color: BottomNavTokens.pillColor,
          borderRadius: BorderRadius.circular(BottomNavTokens.pillRadius),
        ),
        child: Row(
          children: [
            for (var i = 0; i < _tabs.length; i++)
              Expanded(
                child: _VendorTabButton(
                  tab: _tabs[i],
                  isActive: i == active,
                  badgeCount: _tabs[i].showNotificationBadge
                      ? notificationBadgeCount
                      : _tabs[i].showUnsavedBadge && hasUnsavedProfile
                          ? 1
                          : 0,
                  onTap: () {
                    HapticService.light();
                    _tabs[i].onTap(context);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _VendorTabButton extends StatelessWidget {
  const _VendorTabButton({
    required this.tab,
    required this.isActive,
    required this.badgeCount,
    required this.onTap,
  });

  final _VendorTab tab;
  final bool isActive;
  final int badgeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = isActive
        ? BottomNavTokens.pillIconActive
        : BottomNavTokens.pillIconInactive;
    final labelColor = isActive
        ? BottomNavTokens.vendorLabelActive
        : BottomNavTokens.vendorLabelInactive;

    return Semantics(
      button: true,
      label: tab.label,
      selected: isActive,
      child: NavIconTap(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  SvgPicture.asset(
                    tab.icon,
                    width: BottomNavTokens.iconSizeVendor,
                    height: BottomNavTokens.iconSizeVendor,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  ),
                  if (badgeCount > 0)
                    Positioned(
                      top: -4,
                      right: -6,
                      child: _NotificationBadge(count: badgeCount),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                tab.label,
                style: TextStyle(
                  fontSize: BottomNavTokens.vendorLabelSize,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  const _NotificationBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count > 9 ? '9+' : count.toString();

    return Container(
      constraints: const BoxConstraints(minWidth: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      height: 16,
      decoration: BoxDecoration(
        color: AppColors.coral,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: BottomNavTokens.pillColor, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1,
        ),
      ),
    );
  }
}
