import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';

/// Styled pill button used in modals, sheets, and dialogs.
class PlaceifyPillButton extends StatelessWidget {
  const PlaceifyPillButton({
    required this.label,
    required this.onTap,
    this.color = Colors.black,
    this.textColor = Colors.white,
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
        enabled ? color : Colors.black.withValues(alpha: 0.18),
      PlaceifyPillVariant.secondary => Colors.white,
    };

    final foregroundColor = switch (variant) {
      PlaceifyPillVariant.primary =>
        enabled ? textColor : Colors.white.withValues(alpha: 0.7),
      PlaceifyPillVariant.secondary =>
        enabled ? Colors.black87 : AppColors.textMuted,
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
              ? Border.all(color: Colors.black.withValues(alpha: 0.08))
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
