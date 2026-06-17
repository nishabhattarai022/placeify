import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_flutter/features/admin/domain/constants/admin_routes.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/admin_pending_badge_provider.dart';

import '../../services/haptic_service.dart';
import 'bottom_nav_tokens.dart';
import 'nav_icon_tap.dart';

class _AdminTab {
  const _AdminTab({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badgeCount = 0,
  });

  final String icon;
  final String label;
  final void Function(BuildContext context) onTap;
  final int badgeCount;
}

/// Full-width pill bar with 4 labeled tabs (navy slate palette).
class AdminBottomNav extends ConsumerWidget {
  const AdminBottomNav({
    required this.activeIndex,
    super.key,
  });

  final int activeIndex;

  static void _goDashboard(BuildContext context) =>
      context.go(AdminRoutes.dashboard);
  static void _goApprovals(BuildContext context) =>
      context.go(AdminRoutes.approvals);
  static void _goVendors(BuildContext context) =>
      context.go(AdminRoutes.vendors);
  static void _goSettings(BuildContext context) =>
      context.go(AdminRoutes.settings);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingBadge = ref.watch(adminPendingApplicationsBadgeProvider);
    final active = activeIndex.clamp(0, 3);

    final tabs = [
      _AdminTab(
        icon: 'assets/icons/ic_grid.svg',
        label: 'Dashboard',
        onTap: _goDashboard,
      ),
      _AdminTab(
        icon: 'assets/icons/ic_box.svg',
        label: 'Approvals',
        onTap: _goApprovals,
        badgeCount: pendingBadge,
      ),
      _AdminTab(
        icon: 'assets/icons/ic_package.svg',
        label: 'Vendors',
        onTap: _goVendors,
      ),
      _AdminTab(
        icon: 'assets/icons/ic_user.svg',
        label: 'Settings',
        onTap: _goSettings,
      ),
    ];

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
            for (var i = 0; i < tabs.length; i++)
              Expanded(
                child: _AdminTabButton(
                  tab: tabs[i],
                  isActive: i == active,
                  onTap: () {
                    HapticService.light();
                    tabs[i].onTap(context);
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
          padding: const EdgeInsets.symmetric(vertical: 6),
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
                  if (tab.badgeCount > 0)
                    Positioned(
                      top: -4,
                      right: -8,
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 14),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE07B5F),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          tab.badgeCount > 9 ? '9+' : '${tab.badgeCount}',
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                tab.label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                  height: 1.1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
