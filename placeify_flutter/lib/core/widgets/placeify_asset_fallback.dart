import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Shown when a bundled image asset is missing (common in dev without media files).
class PlaceifyAssetFallback extends StatelessWidget {
  const PlaceifyAssetFallback({
    this.icon = Icons.chair_outlined,
    this.backgroundColor = AppColors.cream,
    super.key,
  });

  final IconData icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor,
            backgroundColor.withValues(alpha: 0.85),
            AppColors.onboardingBg.withValues(alpha: 0.35),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 56,
          color: Colors.black.withValues(alpha: 0.18),
        ),
      ),
    );
  }
}
