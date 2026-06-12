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
import 'package:placeify/features/admin/domain/constants/admin_routes.dart';
import 'package:placeify/features/admin/domain/models/admin_stats.dart' as models;
import 'package:placeify/features/admin/presentation/providers/admin_notification_badge_provider.dart';
import 'package:placeify/features/admin/presentation/providers/admin_notifications_provider.dart';
import 'package:placeify/features/admin/presentation/providers/admin_stats_provider.dart';
import 'package:placeify/features/admin/presentation/widgets/admin_application_row.dart';
import 'package:placeify/features/admin/presentation/widgets/admin_empty_state.dart';
import 'package:placeify/features/admin/presentation/widgets/admin_stat_card.dart';
import 'package:placeify/features/auth/presentation/providers/auth_provider.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  bool _hasLoaded = false;
  models.AdminStats? _cachedStats;
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
    await Future.wait([
      ref.read(adminStatsProvider.notifier).refresh(),
      ref.read(adminNotificationsProvider.notifier).refresh(),
    ]);
  }

  String _timeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _greetingName(String? fullName) {
    if (fullName == null || fullName.isEmpty) return 'there';
    return fullName.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final statsAsync = ref.watch(adminStatsProvider);

    statsAsync.whenData((stats) {
      _cachedStats = stats;
      if (!_hasLoaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _hasLoaded = true);
        });
      }
    });

    final showShimmer = statsAsync.isLoading && !_hasLoaded;
    final stats = statsAsync.value ?? _cachedStats;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_timeGreeting()}, ${_greetingName(userAsync.value?.fullName)}',
                          style: AppTypography.vendorGreeting,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Admin Overview',
                          style: AppTypography.sectionTitle,
                        ),
                      ],
                    ),
                  ),
                  const _DashboardNotificationButton(),
                ],
              ),
            ),
            Expanded(
              child: showShimmer
                  ? const _DashboardShimmer()
                  : statsAsync.hasError && stats == null
                      ? _DashboardError(onRetry: _onRefresh)
                      : stats == null
                          ? const _DashboardShimmer()
                          : RefreshIndicator(
                              color: AppColors.espresso,
                              onRefresh: _onRefresh,
                              child: _DashboardBody(
                                stats: stats,
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
    required this.stats,
    required this.scrollController,
  });

  final models.AdminStats stats;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const PageStorageKey<String>('admin_dashboard_scroll'),
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
                  child: AdminStatCard(
                    label: 'Pending',
                    value: stats.pendingCount.toString(),
                    subtitle: 'Awaiting review',
                    accentColor: AppColors.accentLight,
                    highlighted: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: AdminStatCard(
                          label: 'Approved',
                          value: stats.approvedCount.toString(),
                          subtitle: 'Active vendors',
                          accentColor: AppColors.sage,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: AdminStatCard(
                          label: 'Suspended',
                          value: stats.suspendedCount.toString(),
                          subtitle: 'Restricted access',
                          accentColor: AppColors.rust,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AdminStatCard(
            label: 'Total users',
            value: stats.totalUsers.toString(),
            subtitle: 'Registered on platform',
            accentColor: AppColors.bark,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Applications',
                style: AppTypography.sectionTitle,
              ),
              GestureDetector(
                onTap: () {
                  HapticService.light();
                  context.go(AdminRoutes.applications);
                },
                child: const Text('See all', style: AppTypography.seeAll),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (stats.recentApplications.isEmpty)
            const AdminEmptyState(
              message: 'No vendor applications yet',
              icon: Icons.storefront_outlined,
            )
          else
            ...stats.recentApplications.map(
              (application) => AdminApplicationRow(application: application),
            ),
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
                  flex: 1,
                  child: ShimmerLoader(borderRadius: AppRadii.md),
                ),
                const SizedBox(width: 12),
                Expanded(
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
          const SizedBox(height: 12),
          const SizedBox(
            height: 96,
            child: ShimmerLoader(borderRadius: AppRadii.md),
          ),
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

class _DashboardNotificationButton extends ConsumerWidget {
  const _DashboardNotificationButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgeCount = ref.watch(adminNotificationBadgeCountProvider);

    return GestureDetector(
      onTap: () {
        HapticService.light();
        context.push(AdminRoutes.notifications);
      },
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
              color: AppColors.espresso,
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
