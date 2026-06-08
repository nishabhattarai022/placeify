import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../services/haptic_service.dart';
import '../toast_overlay.dart';
import 'bottom_nav_tokens.dart';
import 'nav_icon_tap.dart';

class _VendorTab {
  const _VendorTab({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final void Function(BuildContext context) onTap;
}

/// Full-width pill bar with 5 labeled tabs (no protruding circle).
class VendorBottomNav extends StatelessWidget {
  const VendorBottomNav({
    required this.activeIndex,
    super.key,
  });

  final int activeIndex;

  static const _tabs = [
    _VendorTab(
      icon: 'assets/icons/ic_grid.svg',
      label: 'Dashboard',
      onTap: _noop,
    ),
    _VendorTab(
      icon: 'assets/icons/ic_package.svg',
      label: 'Products',
      onTap: _products,
    ),
    _VendorTab(
      icon: 'assets/icons/ic_home.svg',
      label: 'Store',
      onTap: _store,
    ),
    _VendorTab(
      icon: 'assets/icons/ic_message_circle.svg',
      label: 'Messages',
      onTap: _messages,
    ),
    _VendorTab(
      icon: 'assets/icons/ic_user.svg',
      label: 'Profile',
      onTap: _profile,
    ),
  ];

  static void _noop(BuildContext context) {}
  static void _products(BuildContext context) =>
      PlaceifyToast.show(context, 'Products');
  static void _store(BuildContext context) => context.go('/home');
  static void _messages(BuildContext context) =>
      PlaceifyToast.show(context, 'Messages');
  static void _profile(BuildContext context) =>
      PlaceifyToast.show(context, 'Profile');

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
    required this.onTap,
  });

  final _VendorTab tab;
  final bool isActive;
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
