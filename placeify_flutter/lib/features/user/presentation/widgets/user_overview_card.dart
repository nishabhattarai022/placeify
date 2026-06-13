import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_typography.dart';
import '../../data/user_dashboard_mock_data.dart';

class UserOverviewCard extends StatelessWidget {
  const UserOverviewCard({
    required this.metric,
    super.key,
  });

  final UserOverviewMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: metric.backgroundColor,
              borderRadius: AppRadii.sm,
            ),
            child: Icon(metric.icon, color: metric.accentColor, size: 22),
          ),
          const Spacer(),
          Text(
            metric.value,
            style: AppTypography.metricValueMedium,
          ),
          const SizedBox(height: 4),
          Text(
            metric.label,
            style: AppTypography.metricLabel.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
