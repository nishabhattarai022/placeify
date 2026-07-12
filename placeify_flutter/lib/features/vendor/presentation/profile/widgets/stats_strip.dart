import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_profile_strings.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_metric.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_stats.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_stats_provider.dart'
    hide VendorStats;
import 'package:placeify_flutter/features/vendor/presentation/widgets/metric_card.dart';

/// Horizontal strip of four profile metrics (products, orders, rating, response).
class ProfileStatsStrip extends ConsumerWidget {
  const ProfileStatsStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(vendorStatsProvider);

    return statsAsync.when(
      loading: () => const _StatsStripShimmer(),
      error: (_, _) => const SizedBox.shrink(),
      data: (data) => _StatsRow(stats: data.stats),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final VendorStats stats;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      VendorMetric(
        label: VendorProfileStrings.productsMetric,
        value: stats.productCount.toString(),
        trendLabel: 'Active',
        trendColor: AppColors.sage,
      ),
      VendorMetric(
        label: VendorProfileStrings.ordersMetric,
        value: stats.orderCount.toString(),
        trendLabel: stats.periodLabel,
        trendColor: AppColors.sage,
      ),
      VendorMetric(
        label: VendorProfileStrings.avgRatingMetric,
        value: stats.averageRating.toStringAsFixed(1),
        trendLabel: 'Out of 5',
        trendColor: AppColors.sage,
      ),
      VendorMetric(
        label: VendorProfileStrings.responseRateMetric,
        value: '${(stats.responseRate * 100).round()}%',
        trendLabel: 'Replies',
        trendColor: AppColors.sage,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < metrics.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            SizedBox(
              width: 148,
              child: MetricCard(metric: metrics[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatsStripShimmer extends StatelessWidget {
  const _StatsStripShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          4,
          (index) => Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 10),
            child: const SizedBox(
              width: 148,
              height: 108,
              child: ColoredBox(color: AppColors.creamDark),
            ),
          ),
        ),
      ),
    );
  }
}
