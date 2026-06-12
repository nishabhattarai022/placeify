import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../data/user_dashboard_mock_data.dart';
import 'widgets/user_overview_card.dart';

/// Dashboard overview with static summary cards.
class UserDashboardScreen extends StatelessWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 900;
    final columnCount = width >= 1100
        ? 4
        : width >= 600
            ? 2
            : 1;

    return SingleChildScrollView(
      padding: EdgeInsets.all(
        isDesktop ? AppSpacing.xxl : AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: AppTypography.sectionTitle,
          ),
          const SizedBox(height: 6),
          Text(
            'A quick snapshot of your account activity.',
            style: AppTypography.metricLabel.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final spacing = 12.0;
              final itemWidth = columnCount == 1
                  ? constraints.maxWidth
                  : (constraints.maxWidth - spacing * (columnCount - 1)) /
                      columnCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final metric in UserDashboardOverviewMetrics.cards)
                    SizedBox(
                      width: itemWidth,
                      height: 140,
                      child: UserOverviewCard(metric: metric),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.warmWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.creamDark),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, ${UserDashboardMockData.userName}',
                  style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Use the sidebar to open orders, cart, wishlist, and other '
                  'sections. Each area will be connected to the backend in '
                  'upcoming steps.',
                  style: AppTypography.metricLabel.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
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
