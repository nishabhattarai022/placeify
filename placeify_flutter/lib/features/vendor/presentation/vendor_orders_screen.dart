import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'providers/vendor_orders_provider.dart';
import 'widgets/vendor_order_card.dart';

class VendorOrdersScreen extends ConsumerWidget {
  const VendorOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(vendorShopOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.espresso),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Shop orders',
          style: TextStyle(
            fontFamily: 'Fraunces',
            color: AppColors.espresso,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: AppTypography.bodyLight,
            ),
          ),
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'No customer orders yet.\nOrders from your shop will appear here.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyLight,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(vendorShopOrdersProvider.notifier).refresh(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                8,
                AppSpacing.screenPadding,
                BottomNavTokens.scrollBottomPadding,
              ),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return VendorOrderCard(
                  order: order,
                  onTap: () => context.pushNamed(
                    'vendorOrderDetail',
                    pathParameters: {'orderId': order.orderId.toString()},
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
