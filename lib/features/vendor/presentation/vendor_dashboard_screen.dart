import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_radii.dart';
import 'package:placeify/core/constants/app_spacing.dart';
import 'package:placeify/core/constants/app_typography.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify/core/widgets/shimmer_loader.dart';
import 'package:placeify/features/vendor/domain/constants/vendor_routes.dart';
import 'package:placeify/features/vendor/domain/models/vendor_dashboard_data.dart';
import 'package:placeify/features/vendor/domain/models/vendor_metric.dart';
import 'package:placeify/features/vendor/presentation/providers/vendor_notification_badge_provider.dart';
import 'package:placeify/features/vendor/presentation/providers/vendor_profile_provider.dart';
import 'package:placeify/features/vendor/presentation/providers/vendor_stats_provider.dart';
import 'package:placeify/features/vendor/presentation/widgets/metric_card.dart';
import 'package:placeify/features/vendor/presentation/widgets/revenue_card.dart';
import 'package:placeify/features/vendor/presentation/widgets/top_products_chart.dart';
import 'package:placeify/features/vendor/presentation/widgets/upload_product_button.dart';
import 'package:placeify/features/vendor/presentation/widgets/vendor_dashboard_fab.dart';
import 'package:placeify/features/vendor/presentation/widgets/vendor_onboarding_checklist.dart';
import 'package:placeify/features/vendor/presentation/widgets/vendor_order_row.dart';
import 'package:placeify/features/vendor/presentation/widgets/vendor_reviews_section.dart';

class VendorDashboardScreen extends ConsumerStatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  ConsumerState<VendorDashboardScreen> createState() =>
      _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends ConsumerState<VendorDashboardScreen> {
  bool _hasLoaded = false;
  VendorDashboardData? _cachedData;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref.read(vendorStatsProvider.notifier).refresh();
    ref.invalidate(vendorProfileProvider);
  }

  String _greetingName(String? businessName) {
    if (businessName == null || businessName.isEmpty) return 'there';
    return businessName.split(' ').first;
  }

  String _formatViewCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  List<VendorMetric> _metricsFor(VendorDashboardData data) {
    final stats = data.stats;
    return [
      VendorMetric(
        label: 'Orders',
        value: stats.orderCount.toString(),
        trendLabel: stats.periodLabel,
        trendColor: AppColors.sage,
        iconPath: 'assets/icons/ic_trending_up.svg',
      ),
      VendorMetric(
        label: 'Views',
        value: _formatViewCount(stats.viewCount),
        trendLabel:
            '${(stats.conversionRate * 100).toStringAsFixed(1)}% conversion',
        trendColor: AppColors.sage,
        iconPath: 'assets/icons/ic_check_circle.svg',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(vendorProfileProvider);
    final statsAsync = ref.watch(vendorStatsProvider);

    statsAsync.whenData((data) {
      _cachedData = data;
      if (!_hasLoaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _hasLoaded = true);
        });
      }
    });

    final showShimmer = statsAsync.isLoading && !_hasLoaded;
    final data = statsAsync.value ?? _cachedData;

    return Scaffold(
      backgroundColor: AppColors.cream,
      floatingActionButton: const VendorDashboardFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _DashboardBackButton(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning, ${_greetingName(profileAsync.value?.businessName)}',
                          style: AppTypography.vendorGreeting,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Vendor Dashboard',
                          style: AppTypography.sectionTitle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const _DashboardNotificationButton(),
                ],
              ),
            ),
            Expanded(
              child: showShimmer
                  ? const _DashboardShimmer()
                  : statsAsync.hasError && data == null
                      ? _DashboardError(onRetry: _onRefresh)
                      : data == null
                          ? const _DashboardShimmer()
                          : RefreshIndicator(
                              color: AppColors.vendorForest,
                              onRefresh: _onRefresh,
                              child: _DashboardBody(
                                data: data,
                                metrics: _metricsFor(data),
                                scrollController: _scrollController,
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    required this.data,
    required this.metrics,
    required this.scrollController,
  });

  final VendorDashboardData data;
  final List<VendorMetric> metrics;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final stats = data.stats;
    final conversionLabel =
        '${(stats.conversionRate * 100).toStringAsFixed(1)}% conversion · ${stats.periodLabel}';

    return SingleChildScrollView(
      key: const PageStorageKey<String>('vendor_dashboard_scroll'),
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: RevenueCard(
                    revenue: stats.revenue,
                    trendLabel: conversionLabel,
                    revenueSeries: data.revenueSeries,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(child: MetricCard(metric: metrics[0])),
                      const SizedBox(height: 12),
                      Expanded(child: MetricCard(metric: metrics[1])),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const VendorOnboardingChecklist(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Insights', style: AppTypography.sectionTitle),
              GestureDetector(
                onTap: () => context.push(VendorRoutes.analytics),
                child: const Text('Analytics', style: AppTypography.seeAll),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const UploadProductButton(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Orders', style: AppTypography.sectionTitle),
              GestureDetector(
                onTap: () => context.go(VendorRoutes.orders),
                child: const Text('See all', style: AppTypography.seeAll),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (data.recentOrders.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No orders yet',
                style: AppTypography.metricLabel.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            )
          else
            ...data.recentOrders.map((order) => VendorOrderRow(order: order)),
          const SizedBox(height: 20),
          const VendorReviewsSection(),
          const SizedBox(height: 20),
          TopProductsChart(products: data.topProducts),
          const SizedBox(height: BottomNavTokens.scrollBottomPadding),
        ],
      ),
    );
  }
}

class _DashboardShimmer extends StatelessWidget {
  const _DashboardShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 196,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(
                  flex: 3,
                  child: ShimmerLoader(borderRadius: AppRadii.lg),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: ShimmerLoader(borderRadius: AppRadii.md),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ShimmerLoader(borderRadius: AppRadii.md),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const ShimmerLoader(borderRadius: AppRadii.md),
          const SizedBox(height: 20),
          const ShimmerLoader(borderRadius: AppRadii.sm),
          const SizedBox(height: 12),
          ...List.generate(
            3,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: SizedBox(
                height: 76,
                child: ShimmerLoader(borderRadius: AppRadii.md),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(
            height: 180,
            child: ShimmerLoader(borderRadius: AppRadii.md),
          ),
        ],
      ),
    );
  }
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Could not load dashboard',
              style: AppTypography.sectionTitle,
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _DashboardBackButton extends StatelessWidget {
  const _DashboardBackButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.light();
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(VendorRoutes.profileFallback);
        }
      },
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.creamDark, width: 1.5),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.arrow_back,
          size: 22,
          color: AppColors.vendorForest,
        ),
      ),
    );
  }
}

class _DashboardNotificationButton extends ConsumerWidget {
  const _DashboardNotificationButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgeCount = ref.watch(vendorNotificationBadgeCountProvider);

    return GestureDetector(
      onTap: () => context.push(VendorRoutes.notifications),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.warmWhite,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.creamDark, width: 1.5),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.notifications_outlined,
              size: 22,
              color: AppColors.vendorForest,
            ),
          ),
          if (badgeCount > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                constraints: const BoxConstraints(minWidth: 18),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.coral,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: AppColors.cream, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  badgeCount > 9 ? '9+' : badgeCount.toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
