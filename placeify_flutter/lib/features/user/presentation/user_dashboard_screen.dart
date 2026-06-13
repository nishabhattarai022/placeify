import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../main.dart' show client;
import '../../profile/presentation/providers/profile_dashboard_provider.dart';
import '../data/user_dashboard_mock_data.dart';
import '../data/user_dashboard_mappers.dart';
import 'widgets/user_overview_card.dart';

/// Dashboard overview backed by [client.user.getDashboard].
class UserDashboardScreen extends ConsumerWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!client.auth.isAuthenticated) {
      return _AuthRequired(onLogin: () => context.push('/login'));
    }

    final dashboardAsync = ref.watch(profileDashboardProvider);
    final ordersAsync = ref.watch(profileOrdersProvider);

    return dashboardAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorState(
        message: error.toString(),
        onRetry: () => _refreshDashboard(ref),
      ),
      data: (dashboard) {
        if (dashboard == null) {
          return _AuthRequired(onLogin: () => context.push('/login'));
        }

        final pendingOrders = ordersAsync.whenOrNull(
          data: UserDashboardMappers.countPendingOrders,
        );
        final metrics = UserDashboardMappers.overviewMetrics(
          dashboard,
          pendingOrders: pendingOrders,
        );

        return RefreshIndicator(
          onRefresh: () => _refreshDashboard(ref),
          child: _DashboardContent(
            dashboard: dashboard,
            metrics: metrics,
          ),
        );
      },
    );
  }

  Future<void> _refreshDashboard(WidgetRef ref) async {
    await Future.wait([
      ref.read(profileDashboardProvider.notifier).refresh(),
      ref.refresh(profileOrdersProvider.future),
    ]);
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.dashboard,
    required this.metrics,
  });

  final UserDashboard dashboard;
  final List<UserOverviewMetric> metrics;

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
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.all(isDesktop ? AppSpacing.xxl : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overview', style: AppTypography.sectionTitle),
          const SizedBox(height: 6),
          Text(
            'Live summary from your Placeify account.',
            style: AppTypography.metricLabel.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 12.0;
              final itemWidth = columnCount == 1
                  ? constraints.maxWidth
                  : (constraints.maxWidth - spacing * (columnCount - 1)) /
                      columnCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final metric in metrics)
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
                  'Welcome back, ${UserDashboardMappers.firstName(dashboard)}',
                  style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'You have ${dashboard.orderCount} orders and '
                  '${dashboard.wishlistCount} saved items. Open a section '
                  'from the sidebar to manage your account.',
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

class _AuthRequired extends StatelessWidget {
  const _AuthRequired({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              'Sign in to view your dashboard',
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onLogin,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.forest,
                foregroundColor: Colors.white,
              ),
              child: const Text('Go to login'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.rust),
            const SizedBox(height: 16),
            Text(
              'Could not load dashboard',
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.metricLabel.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
