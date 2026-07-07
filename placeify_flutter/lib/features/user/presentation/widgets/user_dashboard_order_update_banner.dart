import 'package:flutter/material.dart';
import 'package:placeify_client/placeify_client.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

/// Latest unread order notification on the user dashboard.
class UserDashboardOrderUpdateBanner extends StatelessWidget {
  const UserDashboardOrderUpdateBanner({
    required this.notification,
    super.key,
  });

  final InAppNotificationSummary notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.sageBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sage.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.notifications_active_outlined,
            color: AppColors.forest,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: AppTypography.sectionTitle.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: AppTypography.metricLabel.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
