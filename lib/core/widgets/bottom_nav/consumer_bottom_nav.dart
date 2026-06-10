import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/haptic_service.dart';
import '../../theme/app_fonts.dart';
import 'bottom_nav_tokens.dart';

/// Floating black pill nav: white "Home" chip + 3 dark circular icon buttons.
class ConsumerBottomNav extends StatelessWidget {
  const ConsumerBottomNav({
    required this.activeIndex,
    super.key,
  });

  final int activeIndex;

  static void _goHome(BuildContext context) => context.go('/home');
  static void _goBrowse(BuildContext context) => context.go('/browse');
  static void _goBookmarks(BuildContext context) => context.go('/bookmarks');
  static void _goProfile(BuildContext context) => context.go('/profile');

  @override
  Widget build(BuildContext context) {
    final index = activeIndex;

    return Container(
      height: BottomNavTokens.navBarHeight,
      padding: const EdgeInsets.only(bottom: BottomNavTokens.bottomPadding),
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: BottomNavTokens.pillHorizontalPadding,
          vertical: BottomNavTokens.pillVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: BottomNavTokens.pillColor,
          borderRadius: BorderRadius.circular(BottomNavTokens.pillRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HomeNavChip(
              isSelected: index == 0,
              onTap: () {
                HapticService.light();
                _goHome(context);
              },
            ),
            const SizedBox(width: BottomNavTokens.navItemGap),
            _NavIconButton(
              icon: Icons.shopping_bag_outlined,
              isSelected: index == 1,
              semanticLabel: 'Browse',
              onTap: () {
                HapticService.light();
                _goBrowse(context);
              },
            ),
            const SizedBox(width: BottomNavTokens.navItemGap),
            _NavIconButton(
              icon: Icons.star_outline,
              isSelected: index == 2,
              semanticLabel: 'Bookmarks',
              onTap: () {
                HapticService.light();
                _goBookmarks(context);
              },
            ),
            const SizedBox(width: BottomNavTokens.navItemGap),
            _NavIconButton(
              icon: Icons.person_outline,
              isSelected: index == 3,
              semanticLabel: 'Profile',
              onTap: () {
                HapticService.light();
                _goProfile(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeNavChip extends StatelessWidget {
  const _HomeNavChip({
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Home',
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          height: BottomNavTokens.homeChipHeight,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected
                ? BottomNavTokens.homeChipHorizontalPadding
                : 12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? BottomNavTokens.homeChipFill
                : BottomNavTokens.iconCircleColor,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.home_outlined,
                size: BottomNavTokens.iconSize,
                color: isSelected
                    ? BottomNavTokens.homeChipForeground
                    : BottomNavTokens.pillIconInactive,
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Text(
                  'Home',
                  style: AppFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: BottomNavTokens.homeChipForeground,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIconButton extends StatefulWidget {
  const _NavIconButton({
    required this.icon,
    required this.isSelected,
    required this.semanticLabel,
    required this.onTap,
  });

  final IconData icon;
  final bool isSelected;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  State<_NavIconButton> createState() => _NavIconButtonState();
}

class _NavIconButtonState extends State<_NavIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      selected: isSelected,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: _pressed ? 0.92 : 1,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            width: BottomNavTokens.iconCircleSize,
            height: BottomNavTokens.iconCircleSize,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white
                  : BottomNavTokens.iconCircleColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              widget.icon,
              size: BottomNavTokens.iconSize,
              color: isSelected
                  ? BottomNavTokens.homeChipForeground
                  : BottomNavTokens.pillIconInactive,
            ),
          ),
        ),
      ),
    );
  }
}
