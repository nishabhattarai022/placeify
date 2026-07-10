import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';

/// Styled pill button used in modals, sheets, and dialogs.
class PlaceifyPillButton extends StatelessWidget {
  const PlaceifyPillButton({
    required this.label,
    required this.onTap,
    this.color = AppColors.espresso,
    this.textColor = AppColors.warmWhite,
    this.variant = PlaceifyPillVariant.primary,
    this.enabled = true,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final Color color;
  final Color textColor;
  final PlaceifyPillVariant variant;
  final bool enabled;
  final bool isLoading;

  bool get _isInteractive => enabled && !isLoading && onTap != null;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (variant) {
      PlaceifyPillVariant.primary =>
        enabled ? color : AppColors.creamDark,
      PlaceifyPillVariant.secondary => AppColors.cream,
    };

    final foregroundColor = switch (variant) {
      PlaceifyPillVariant.primary =>
        enabled ? textColor : AppColors.textMuted,
      PlaceifyPillVariant.secondary =>
        enabled ? AppColors.textPrimary : AppColors.textMuted,
    };

    return GestureDetector(
      onTap: _isInteractive ? onTap : null,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppRadii.pill,
          border: variant == PlaceifyPillVariant.secondary
              ? Border.all(color: AppColors.creamDark, width: 1.5)
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: foregroundColor,
          ),
        ),
      ),
    );
  }
}

enum PlaceifyPillVariant { primary, secondary }
