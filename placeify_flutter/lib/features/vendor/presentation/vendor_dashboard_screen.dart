import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/placeify_bottom_nav.dart';
import '../../../main.dart' show client;
import '../../auth/presentation/account_mode_actions.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../data/vendor_mappers.dart';
import 'providers/vendor_dashboard_provider.dart';
import 'vendor_onboarding_screen.dart';
import 'widgets/metric_card.dart';
import 'widgets/order_row.dart';
import 'widgets/revenue_card.dart';
import 'widgets/top_products_chart.dart';
import 'widgets/upload_product_button.dart';
import 'widgets/vendor_products_section.dart';

class VendorDashboardScreen extends ConsumerStatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  ConsumerState<VendorDashboardScreen> createState() =>
      _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends ConsumerState<VendorDashboardScreen> {
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

  String _greetingName() {
    final user = ref.watch(currentUserProvider).value;
    if (user != null && user.fullName.trim().isNotEmpty) {
      final first = user.fullName.trim().split(' ').first;
      return first;
    }
    return 'there';
  }

  @override
  Widget build(BuildContext context) {
    if (!client.auth.isAuthenticated) {
      return _AuthRequired(onLogin: () => context.push('/login'));
    }

    final dashboardAsync = ref.watch(vendorDashboardStateProvider);

    if (dashboardAsync.isLoading && !dashboardAsync.hasValue) {
      return const Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (dashboardAsync.hasError && !dashboardAsync.hasValue) {
      return Scaffold(
        backgroundColor: AppColors.cream,
        body: _ErrorState(
          message: dashboardAsync.error.toString(),
          onRetry: () =>
              ref.read(vendorDashboardStateProvider.notifier).refresh(),
        ),
      );
    }

    final dashboard = dashboardAsync.value;
    if (dashboard == null) {
      return const VendorOnboardingScreen();
    }

    return _buildDashboard(context, dashboard);
  }

  Widget _buildDashboard(BuildContext context, VendorDashboard dashboard) {

        final metrics = VendorMappers.metrics(dashboard);
        final orders = VendorMappers.orders(dashboard.recentOrders);
        final topProducts = VendorMappers.topProducts(
          dashboard.topProducts,
          dashboard.revenue,
        );
        final productsAsync = ref.watch(vendorProductsProvider);

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
                              'Good morning, ${_greetingName()}',
                              style: AppTypography.vendorGreeting,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dashboard.shop.shopName,
                              style: AppTypography.sectionTitle,
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () =>
                            openConsumerExperience(context, ref),
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 18,
                          color: AppColors.espresso,
                        ),
                        label: const Text(
                          'Shop',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.espresso,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () =>
                        ref.read(vendorDashboardStateProvider.notifier).refresh(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: RevenueCard(revenue: dashboard.revenue),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: MetricCard(metric: metrics[0]),
                                      ),
                                      const SizedBox(height: 12),
                                      Expanded(
                                        child: MetricCard(metric: metrics[1]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          UploadProductButton(
                            onTap: () => context.pushNamed('vendorAddProduct'),
                          ),
                          const SizedBox(height: 20),
                          productsAsync.when(
                            loading: () => const SizedBox(
                              height: 24,
                              child: Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                            error: (_, __) => const SizedBox.shrink(),
                            data: (products) => Column(
                              children: [
                                VendorProductsSection(products: products),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recent Orders',
                                style: AppTypography.sectionTitle,
                              ),
                              if (orders.isNotEmpty)
                                GestureDetector(
                                  onTap: () =>
                                      context.pushNamed('vendorOrders'),
                                  child: const Text(
                                    'See all',
                                    style: AppTypography.seeAll,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (orders.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.warmWhite,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.creamDark),
                              ),
                              child: Text(
                                'No orders yet. Add products to start selling.',
                                style: AppTypography.bodyLight,
                              ),
                            )
                          else
                            ...orders.map(
                              (o) => OrderRow(
                                order: o,
                                onTap: o.shopOrderId > 0
                                    ? () => context.pushNamed(
                                          'vendorOrderDetail',
                                          pathParameters: {
                                            'orderId':
                                                o.shopOrderId.toString(),
                                          },
                                        )
                                    : null,
                              ),
                            ),
                          const SizedBox(height: 20),
                          TopProductsChart(products: topProducts),
                          const SizedBox(
                            height: BottomNavTokens.scrollBottomPadding,
                          ),
                        ],
                      ),
                    ),
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
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sign in to manage your shop',
                textAlign: TextAlign.center,
                style: AppTypography.sectionTitle,
              ),
              const SizedBox(height: 12),
              const Text(
                'Use your Placeify account to open a vendor dashboard.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyLight,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onLogin,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.espresso,
                  foregroundColor: AppColors.warmWhite,
                ),
                child: const Text('Log in'),
              ),
            ],
          ),
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Could not load dashboard',
              style: AppTypography.sectionTitle,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyLight,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
