import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/models/vendor_metric.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({required this.metric, super.key});

  final VendorMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label.toUpperCase(),
            style: AppTypography.metricLabel.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(metric.value, style: AppTypography.metricValueMedium),
          const SizedBox(height: 4),
          Row(
            children: [
              if (metric.iconPath != null) ...[
                SvgPicture.asset(
                  metric.iconPath!,
                  width: 14,
                  colorFilter: ColorFilter.mode(
                    metric.trendColor,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  metric.trendLabel,
                  style: AppTypography.trendText.copyWith(
                    color: metric.trendColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
