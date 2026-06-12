import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_radii.dart';
import 'package:placeify/core/constants/app_spacing.dart';
import 'package:placeify/core/constants/app_typography.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/utils/formatters.dart';
import 'package:placeify/core/utils/relative_time.dart';
import 'package:placeify/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify/core/widgets/shimmer_loader.dart';
import 'package:placeify/features/admin/domain/constants/admin_routes.dart';
import 'package:placeify/features/admin/domain/constants/admin_strings.dart';
import 'package:placeify/features/admin/domain/models/admin_audit_log_entry.dart';
import 'package:placeify/features/admin/domain/models/admin_stats.dart' as models;
import 'package:placeify/features/admin/presentation/providers/admin_audit_log_provider.dart';
import 'package:placeify/features/admin/presentation/providers/admin_notification_badge_provider.dart';
import 'package:placeify/features/admin/presentation/providers/admin_notifications_provider.dart';
import 'package:placeify/features/admin/presentation/providers/admin_stats_provider.dart';
import 'package:placeify/features/admin/presentation/widgets/admin_stat_card.dart';
import 'package:placeify/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify/features/vendor/presentation/widgets/mini_bar_chart.dart';

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
      ref.read(adminAuditLogProvider.notifier).refresh(),
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
                          AdminStrings.adminOverview,
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
                              color: AppColors.adminSlate,
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
                    label: AdminStrings.totalVendorsLabel,
                    value: stats.totalVendors.toString(),
                    subtitle: AdminStrings.totalVendorsSubtitle,
                    accentColor: AppColors.sage,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: AdminStatCard(
                          label: AdminStrings.pendingLabel,
                          value: stats.pendingCount.toString(),
                          subtitle: AdminStrings.pendingSubtitle,
                          accentColor: AppColors.accent,
                          highlighted: stats.pendingCount > 0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: AdminStatCard(
                          label: AdminStrings.totalUsersLabel,
                          value: stats.totalUsers.toString(),
                          subtitle: AdminStrings.totalUsersSubtitle,
                          accentColor: AppColors.bark,
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
            label: AdminStrings.platformGmvLabel,
            value: Formatters.currencyFull(stats.platformGmv),
            subtitle: AdminStrings.platformGmvSubtitle,
            accentColor: AppColors.adminSlate,
          ),
          if (stats.pendingCount > 0) ...[
            const SizedBox(height: 16),
            _NeedsAttentionCard(pendingCount: stats.pendingCount),
          ],
          const SizedBox(height: 20),
          const Text(
            AdminStrings.quickLinks,
            style: AppTypography.sectionTitle,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _QuickLinkTile(
                  icon: Icons.people_outline,
                  label: AdminStrings.usersLink,
                  onTap: () {
                    HapticService.light();
                    context.push(AdminRoutes.users);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickLinkTile(
                  icon: Icons.notifications_outlined,
                  label: AdminStrings.notificationsLink,
                  onTap: () {
                    HapticService.light();
                    context.push(AdminRoutes.notifications);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            AdminStrings.recentActivity,
            style: AppTypography.sectionTitle,
          ),
          const SizedBox(height: 12),
          if (stats.recentActivity.isEmpty)
            const _EmptyActivityCard()
          else
            ...stats.recentActivity.map(
              (entry) => _ActivityTile(entry: entry),
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AdminStrings.newSignups,
                style: AppTypography.sectionTitle,
              ),
              const Text(
                AdminStrings.last7Days,
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warmWhite,
              borderRadius: AppRadii.md,
              border: Border.all(color: AppColors.creamDark, width: 1.5),
            ),
            child: MiniBarChart(heights: stats.signupSeries),
          ),
          const SizedBox(height: BottomNavTokens.scrollBottomPadding),
        ],
      ),
    );
  }
}

class _NeedsAttentionCard extends StatelessWidget {
  const _NeedsAttentionCard({required this.pendingCount});

  final int pendingCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.light();
        context.go(AdminRoutes.approvals);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.accentBg,
          borderRadius: AppRadii.md,
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AdminStrings.needsAttention,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.espresso,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$pendingCount ${AdminStrings.needsAttentionBody}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              AdminStrings.reviewNow,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLinkTile extends StatelessWidget {
  const _QuickLinkTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.md,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.warmWhite,
            borderRadius: AppRadii.md,
            border: Border.all(color: AppColors.creamDark, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: AppColors.adminSlate),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.espresso,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.entry});

  final AdminAuditLogEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              AdminStrings.auditActionLabel(entry.action),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.espresso,
              ),
            ),
          ),
          Text(
            RelativeTime.format(entry.timestamp),
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _EmptyActivityCard extends StatelessWidget {
  const _EmptyActivityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: const Text(
        AdminStrings.noActivityYet,
        style: TextStyle(fontSize: 13, color: AppColors.textMuted),
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
        children: [
          SizedBox(
            height: 196,
            child: Row(
              children: [
                const Expanded(child: ShimmerLoader(borderRadius: AppRadii.md)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(child: ShimmerLoader(borderRadius: AppRadii.md)),
                      const SizedBox(height: 12),
                      Expanded(child: ShimmerLoader(borderRadius: AppRadii.md)),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            AdminStrings.dashboardLoadError,
            style: AppTypography.sectionTitle,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRetry,
            child: const Text(AdminStrings.retry),
          ),
        ],
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
              color: AppColors.adminSlate,
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
