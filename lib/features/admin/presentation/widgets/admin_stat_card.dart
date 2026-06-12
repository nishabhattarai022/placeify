import 'package:flutter/material.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_radii.dart';
import 'package:placeify/core/constants/app_typography.dart';

class AdminStatCard extends StatelessWidget {
  const AdminStatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.accentColor,
    super.key,
    this.highlighted = false,
  });

  final String label;
  final String value;
  final String subtitle;
  final Color accentColor;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final background = highlighted ? AppColors.espresso : AppColors.warmWhite;
    final borderColor = highlighted ? AppColors.espresso : AppColors.creamDark;
    final labelColor = highlighted
        ? AppColors.warmWhite.withValues(alpha: 0.55)
        : AppColors.textMuted;
    final valueColor = highlighted ? AppColors.warmWhite : AppColors.espresso;
    final subtitleColor = highlighted ? accentColor : accentColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.md,
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.metricLabel.copyWith(color: labelColor),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: highlighted
                ? AppTypography.metricValueLarge.copyWith(color: valueColor)
                : AppTypography.metricValueMedium.copyWith(color: valueColor),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTypography.trendText.copyWith(color: subtitleColor),
          ),
        ],
      ),
    );
  }
}
