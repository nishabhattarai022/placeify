import 'package:flutter/material.dart';

import '../../theme/app_fonts.dart';
import 'bottom_nav_tokens.dart';

/// Floating black pill wrapper shared by consumer and vendor navigation.
class BottomNavBarShell extends StatelessWidget {
  const BottomNavBarShell({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
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
          children: children,
        ),
      ),
    );
  }
}

/// Expandable white chip for the primary tab (Home, Dashboard, etc.).
class BottomNavPrimaryChip extends StatelessWidget {
  const BottomNavPrimaryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
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
                icon,
                size: BottomNavTokens.iconSize,
                color: isSelected
                    ? BottomNavTokens.homeChipForeground
                    : BottomNavTokens.pillIconInactive,
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Text(
                  label,
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

/// Circular icon tab with press scale — matches consumer secondary tabs.
class BottomNavIconButton extends StatefulWidget {
  const BottomNavIconButton({
    required this.icon,
    required this.isSelected,
    required this.semanticLabel,
    required this.onTap,
    this.badgeCount = 0,
    super.key,
  });

  final IconData icon;
  final bool isSelected;
  final String semanticLabel;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  State<BottomNavIconButton> createState() => _BottomNavIconButtonState();
}

class _BottomNavIconButtonState extends State<BottomNavIconButton> {
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
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
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
              if (widget.badgeCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: BottomNavNotificationBadge(count: widget.badgeCount),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavNotificationBadge extends StatelessWidget {
  const BottomNavNotificationBadge({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count > 9 ? '9+' : count.toString();

    return Container(
      constraints: const BoxConstraints(minWidth: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      height: 16,
      decoration: BoxDecoration(
        color: const Color(0xFFE85D4C),
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

class BottomNavItemGap extends StatelessWidget {
  const BottomNavItemGap({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: BottomNavTokens.navItemGap);
  }
}
