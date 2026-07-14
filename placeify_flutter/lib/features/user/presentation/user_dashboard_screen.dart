import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_client/placeify_client.dart' hide Product;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/config/placeify_server_client.dart';
import '../../home/domain/models/product.dart';
import '../../home/presentation/providers/catalog_provider.dart';
import '../../orders/presentation/providers/customer_in_app_notifications_provider.dart';
import '../../orders/presentation/providers/orders_provider.dart';
import '../../profile/presentation/providers/profile_dashboard_provider.dart';
import '../data/user_dashboard_mappers.dart';
import '../data/user_dashboard_marketplace_mapper.dart';
import '../data/user_dashboard_mock_data.dart';
import 'widgets/user_dashboard_marketplace_row.dart';
import 'widgets/user_dashboard_order_update_banner.dart';
import 'widgets/user_dashboard_recent_orders.dart';
import 'widgets/user_overview_card.dart';

/// Dashboard overview backed by [client.user.getDashboard].
const _dashboardRecentProductLimit = 4;
const _dashboardOfferProductLimit = 4;

class UserDashboardScreen extends ConsumerStatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  ConsumerState<UserDashboardScreen> createState() =>
      _UserDashboardScreenState();
}

class _UserDashboardScreenState extends ConsumerState<UserDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _refreshDashboard();
    });
  }

  Future<void> _refreshDashboard() async {
    await Future.wait([
      ref.read(profileDashboardProvider.notifier).refresh(),
      ref.read(profileOrdersProvider.notifier).refresh(),
      ref.read(customerInAppNotificationsProvider.notifier).refresh(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (!client.auth.isAuthenticated) {
      return _AuthRequired(onLogin: () => context.push('/login'));
    }

    final dashboardAsync = ref.watch(profileDashboardProvider);
    final ordersAsync = ref.watch(profileOrdersProvider);
    final notificationsAsync = ref.watch(customerInAppNotificationsProvider);

    ref.listen(customerInAppNotificationsProvider, (previous, next) {
      final prevCount = previous?.value?.unreadCount ?? 0;
      final nextCount = next.value?.unreadCount ?? 0;
      if (nextCount > prevCount) {
        ref.read(profileOrdersProvider.notifier).refresh(silent: true);
        ref.read(profileDashboardProvider.notifier).refresh(silent: true);
        ref.read(ordersProvider.notifier).refresh(silent: true);
      }
    });

    return dashboardAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorState(
        message: error.toString(),
        onRetry: _refreshDashboard,
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
          onRefresh: _refreshDashboard,
          child: FutureBuilder<({
            List<Product> recent,
            List<Product> offers,
            List<Product> featured,
          })>(
            future: _loadMarketplaceProducts(dashboard, ref),
            builder: (context, snapshot) {
              final recent = snapshot.data?.recent ?? const [];
              final offers = snapshot.data?.offers ?? const [];
              final featured = snapshot.data?.featured ?? const [];
              final orders = ordersAsync.value ?? const [];
              final latestUnread = notificationsAsync.maybeWhen(
                data: (state) => state.notifications
                    .where((row) => !row.isRead)
                    .where(_isOrderNotification)
                    .firstOrNull,
                orElse: () => null,
              );

              return _DashboardContent(
                dashboard: dashboard,
                metrics: metrics,
                recentProducts: recent,
                offerProducts: offers,
                featuredProducts: featured,
                recentOrders: orders,
                latestOrderUpdate: latestUnread,
              );
            },
          ),
        );
      },
    );
  }

  Future<({
    List<Product> recent,
    List<Product> offers,
    List<Product> featured,
  })> _loadMarketplaceProducts(
    UserDashboard dashboard,
    WidgetRef ref,
  ) async {
    final apiRecent = dashboard.marketplace.recentProducts
        .take(_dashboardRecentProductLimit)
        .toList();
    final recent = await UserDashboardMarketplaceMapper.toUiProducts(apiRecent);
    var offers = await UserDashboardMarketplaceMapper.toOfferProducts(
      dashboard.marketplace.offerProducts,
      limit: _dashboardOfferProductLimit,
    );
    if (offers.isEmpty) {
      final fallback = await ref.read(catalogDiscountedProductsProvider.future);
      offers = fallback.take(_dashboardOfferProductLimit).toList();
    }
    final featured = await UserDashboardMarketplaceMapper.toUiProducts(
      dashboard.marketplace.featuredProducts,
    );
    return (recent: recent, offers: offers, featured: featured);
  }

  bool _isOrderNotification(InAppNotificationSummary notification) {
    return switch (notification.type) {
      InAppNotificationType.orderPlaced ||
      InAppNotificationType.orderAccepted ||
      InAppNotificationType.orderCancelled ||
      InAppNotificationType.deliveryUpdate ||
      InAppNotificationType.paymentUpdate ||
      InAppNotificationType.refundUpdate =>
        true,
      _ => false,
    };
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.dashboard,
    required this.metrics,
    required this.recentProducts,
    required this.offerProducts,
    required this.featuredProducts,
    required this.recentOrders,
    this.latestOrderUpdate,
  });

  final UserDashboard dashboard;
  final List<UserOverviewMetric> metrics;
  final List<Product> recentProducts;
  final List<Product> offerProducts;
  final List<Product> featuredProducts;
  final List<UserOrderSummary> recentOrders;
  final InAppNotificationSummary? latestOrderUpdate;

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
          if (latestOrderUpdate != null)
            UserDashboardOrderUpdateBanner(
              notification: latestOrderUpdate!,
            ),
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
          if (recentOrders.isNotEmpty) ...[
            const SizedBox(height: 28),
            UserDashboardRecentOrders(orders: recentOrders),
          ],
          if (recentProducts.isNotEmpty) ...[
            const SizedBox(height: 28),
            UserDashboardMarketplaceRow(
              title: 'New arrivals',
              products: recentProducts,
            ),
          ],
          if (offerProducts.isNotEmpty) ...[
            const SizedBox(height: 28),
            UserDashboardMarketplaceRow(
              title: 'Special Offers',
              products: offerProducts,
              maxProducts: _dashboardOfferProductLimit,
            ),
          ],
          if (featuredProducts.isNotEmpty) ...[
            const SizedBox(height: 28),
            UserDashboardMarketplaceRow(
              title: 'Featured',
              products: featuredProducts,
            ),
          ],
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
