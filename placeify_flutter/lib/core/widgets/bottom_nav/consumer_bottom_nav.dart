import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/haptic_service.dart';
import 'bottom_nav_pill_widgets.dart';

/// Floating black pill nav: white "Home" chip + 4 dark circular icon buttons.
class ConsumerBottomNav extends StatelessWidget {
  const ConsumerBottomNav({
    required this.activeIndex,
    super.key,
  });

  final int activeIndex;

  static void _goHome(BuildContext context) => context.go('/home');
  static void _goMyAr(BuildContext context) => context.go('/my-ar');
  static void _goBrowse(BuildContext context) => context.go('/browse');
  static void _goBookmarks(BuildContext context) => context.go('/bookmarks');
  static void _goProfile(BuildContext context) => context.go('/profile');

  @override
  Widget build(BuildContext context) {
    final index = activeIndex;

    return BottomNavBarShell(
      children: [
        BottomNavPrimaryChip(
          label: 'Home',
          icon: Icons.home_outlined,
          isSelected: index == 0,
          onTap: () {
            HapticService.light();
            _goHome(context);
          },
        ),
        const BottomNavItemGap(),
        BottomNavIconButton(
          icon: Icons.view_in_ar_outlined,
          isSelected: index == 1,
          semanticLabel: 'My AR',
          onTap: () {
            HapticService.light();
            _goMyAr(context);
          },
        ),
        const BottomNavItemGap(),
        BottomNavIconButton(
          icon: Icons.shopping_bag_outlined,
          isSelected: index == 2,
          semanticLabel: 'Browse',
          onTap: () {
            HapticService.light();
            _goBrowse(context);
          },
        ),
        const BottomNavItemGap(),
        BottomNavIconButton(
          icon: Icons.star_outline,
          isSelected: index == 3,
          semanticLabel: 'Bookmarks',
          onTap: () {
            HapticService.light();
            _goBookmarks(context);
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
