import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Reusable modal bottom sheet shell aligned with the Placeify design system.
abstract final class PlaceifyBottomSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget Function(BuildContext sheetContext) builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: AppColors.warmWhite,
      barrierColor: AppColors.espresso.withValues(alpha: 0.32),
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final bottomInset = MediaQuery.viewPaddingOf(sheetContext).bottom;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.md + bottomInset,
            ),
            child: builder(sheetContext),
          ),
        );
      },
    );
  }
}

class PlaceifyBottomSheetHeader extends StatelessWidget {
  const PlaceifyBottomSheetHeader({
    required this.title,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle!,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
              height: 1.35,
            ),
          ),
        ],
      ],
    );
  }
}

class PlaceifySelectTile extends StatelessWidget {
  const PlaceifySelectTile({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.semanticsLabel,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final labelText = semanticsLabel ?? label;

    return Semantics(
      button: true,
      selected: selected,
      label: selected ? '$labelText, selected' : labelText,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.cream : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 20,
                    color: selected
                        ? AppColors.espresso
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected
                          ? AppColors.espresso
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                    );
                  },
                  child: selected
                      ? const Icon(
                          Icons.check_rounded,
                          key: ValueKey('check'),
                          size: 20,
                          color: AppColors.espresso,
                        )
                      : const SizedBox(
                          key: ValueKey('no-check'),
                          width: 20,
                          height: 20,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
