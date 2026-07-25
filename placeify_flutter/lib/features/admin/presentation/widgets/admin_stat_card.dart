import 'package:flutter/material.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/constants/app_typography.dart';

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
    final background = highlighted ? AppColors.espresso : Colors.white;
    final labelColor = highlighted
        ? AppColors.warmWhite.withValues(alpha: 0.6)
        : AppColors.textMuted;
    final valueColor = highlighted ? AppColors.warmWhite : AppColors.espresso;
    final subtitleColor = highlighted
        ? accentColor.withValues(alpha: 0.95)
        : accentColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlighted
              ? AppColors.espresso
              : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: highlighted ? 0.12 : 0.04),
            blurRadius: highlighted ? 20 : 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: AppTypography.metricLabel.copyWith(
                    color: labelColor,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: highlighted
                ? AppTypography.metricValueLarge.copyWith(color: valueColor)
                : AppTypography.metricValueMedium.copyWith(
                    color: valueColor,
                    fontSize: 26,
                    letterSpacing: -0.5,
                  ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: AppTypography.trendText.copyWith(color: subtitleColor),
          ),
        ],
      ),
    );
  }
}
