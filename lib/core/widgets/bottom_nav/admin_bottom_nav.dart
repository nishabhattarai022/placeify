import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify/features/admin/domain/constants/admin_routes.dart';

import '../../services/haptic_service.dart';
import 'bottom_nav_tokens.dart';
import 'nav_icon_tap.dart';

class _AdminTab {
  const _AdminTab({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final void Function(BuildContext context) onTap;
}

/// Full-width pill bar with 4 labeled tabs (espresso/forest palette).
class AdminBottomNav extends StatelessWidget {
  const AdminBottomNav({
    required this.activeIndex,
    super.key,
  });

  final int activeIndex;

  static void _goDashboard(BuildContext context) =>
      context.go(AdminRoutes.dashboard);
  static void _goApplications(BuildContext context) =>
      context.go(AdminRoutes.applications);
  static void _goVendors(BuildContext context) =>
      context.go(AdminRoutes.vendors);
  static void _goUsers(BuildContext context) => context.go(AdminRoutes.users);

  static const _tabs = [
    _AdminTab(
      icon: 'assets/icons/ic_grid.svg',
      label: 'Overview',
      onTap: _goDashboard,
    ),
    _AdminTab(
      icon: 'assets/icons/ic_box.svg',
      label: 'Applications',
      onTap: _goApplications,
    ),
    _AdminTab(
      icon: 'assets/icons/ic_package.svg',
      label: 'Vendors',
      onTap: _goVendors,
    ),
    _AdminTab(
      icon: 'assets/icons/ic_user.svg',
      label: 'Users',
      onTap: _goUsers,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final active = activeIndex.clamp(0, _tabs.length - 1);

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
          color: BottomNavTokens.adminPillColor,
          borderRadius: BorderRadius.circular(BottomNavTokens.pillRadius),
        ),
        child: Row(
          children: [
            for (var i = 0; i < _tabs.length; i++)
              Expanded(
                child: _AdminTabButton(
                  tab: _tabs[i],
                  isActive: i == active,
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

class _AdminTabButton extends StatelessWidget {
  const _AdminTabButton({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  final _AdminTab tab;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = isActive
        ? BottomNavTokens.adminIconActive
        : BottomNavTokens.adminIconInactive;
    final labelColor = isActive
        ? BottomNavTokens.adminLabelActive
        : BottomNavTokens.adminLabelInactive;

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
              SvgPicture.asset(
                tab.icon,
                width: BottomNavTokens.iconSizeVendor,
                height: BottomNavTokens.iconSizeVendor,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
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
