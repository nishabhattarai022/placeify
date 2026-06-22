import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';

/// Prompts vendors to build a 3D model before using AR / 3D features.
class BuildModelPromptDialog extends StatelessWidget {
  const BuildModelPromptDialog({
    required this.productId,
    required this.onBuildNow,
    required this.onDismiss,
    super.key,
  });

  final String productId;
  final VoidCallback onBuildNow;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadii.md),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.vendorForestBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.view_in_ar_rounded,
              color: AppColors.vendorForest,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '3D Model Not Set Up',
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        "You haven't built a 3D model for this product yet. Build the 3D "
        'model first to use this feature.',
        style: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onDismiss,
          child: Text(
            'Maybe Later',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        FilledButton(
          onPressed: onBuildNow,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.vendorForest,
            foregroundColor: AppColors.warmWhite,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: AppRadii.pill),
          ),
          child: Text(
            'Build 3D Model',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
