import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/config/placeify_server_client.dart';
import '../../profile/presentation/providers/profile_dashboard_provider.dart';
import '../data/user_order_mappers.dart';
import 'widgets/user_order_card.dart';
import 'widgets/user_order_filter_bar.dart';

/// Order history backed by [client.user.listMyOrders].
class UserOrdersPage extends ConsumerStatefulWidget {
  const UserOrdersPage({super.key});

  @override
  ConsumerState<UserOrdersPage> createState() => _UserOrdersPageState();
}

class _UserOrdersPageState extends ConsumerState<UserOrdersPage> {
  int _filterIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(profileOrdersProvider.notifier).refresh();
    });
  }

  Future<void> _refresh() async {
    await ref.read(profileOrdersProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    if (!client.auth.isAuthenticated) {
      return _AuthRequired(onLogin: () => context.push('/login'));
    }

    final ordersAsync = ref.watch(profileOrdersProvider);
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final horizontalPadding = isDesktop ? AppSpacing.xxl : AppSpacing.lg;

    return ordersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorState(
        message: error.toString(),
        onRetry: _refresh,
      ),
      data: (orders) {
        final filtered = UserOrderMappers.filterOrders(orders, _filterIndex);

        return RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    isDesktop ? AppSpacing.xxl : AppSpacing.lg,
                    horizontalPadding,
                    AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order history', style: AppTypography.sectionTitle),
                      const SizedBox(height: 6),
                      Text(
                        orders.isEmpty
                            ? 'Your purchases will appear here.'
                            : '${orders.length} order${orders.length == 1 ? '' : 's'} on your account.',
                        style: AppTypography.metricLabel.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      UserOrderFilterBar(
                        filters: UserOrderMappers.orderFilters,
                        selectedIndex: _filterIndex,
                        onSelected: (index) {
                          setState(() => _filterIndex = index);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (filtered.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyOrdersState(
                    hasOrders: orders.isNotEmpty,
                    filterLabel: UserOrderMappers.orderFilters[_filterIndex],
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    AppSpacing.md,
                    horizontalPadding,
                    AppSpacing.xxxl,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          UserOrderCard(order: filtered[index]),
                      childCount: filtered.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyOrdersState extends StatelessWidget {
  const _EmptyOrdersState({
    required this.hasOrders,
    required this.filterLabel,
  });

  final bool hasOrders;
  final String filterLabel;

  @override
  Widget build(BuildContext context) {
    final title = hasOrders
        ? 'No $filterLabel orders'
        : 'No orders yet';
    final description = hasOrders
        ? 'Try another filter to see more orders.'
        : 'Browse products and checkout to start your order history.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTypography.metricLabel.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ],
        ),
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
              'Sign in to view your orders',
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
              'Could not load orders',
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
