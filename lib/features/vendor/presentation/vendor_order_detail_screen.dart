import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../profile/presentation/widgets/profile_sub_hero.dart';
import '../domain/models/delivery_update.dart';
import '../domain/models/vendor_order.dart';
import 'providers/vendor_order_detail_provider.dart';
import 'widgets/order_status_chip.dart';
import 'widgets/order_timeline_widget.dart';

class VendorOrderDetailScreen extends ConsumerWidget {
  const VendorOrderDetailScreen({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(vendorOrderDetailProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: detailAsync.when(
        loading: () => const _OrderDetailShimmer(),
        error: (_, __) => _OrderDetailError(onRetry: () {
          ref.invalidate(vendorOrderDetailProvider(orderId));
        }),
        data: (detail) {
          if (detail == null) {
            return _OrderDetailError(onRetry: () {
              ref.invalidate(vendorOrderDetailProvider(orderId));
            });
          }

          return _OrderDetailBody(
            order: detail.order,
            deliveryUpdates: detail.deliveryUpdates,
          );
        },
      ),
    );
  }
}

class _OrderDetailBody extends StatelessWidget {
  const _OrderDetailBody({
    required this.order,
    required this.deliveryUpdates,
  });

  final VendorOrder order;
  final List<DeliveryUpdate> deliveryUpdates;

  @override
  Widget build(BuildContext context) {
    final unitPrice = order.quantity > 0
        ? order.totalAmount / order.quantity
        : order.totalAmount;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: ProfileSubHero(
            title: 'Order #${order.orderNumber}',
            bottom: OrderStatusChip(
              status: order.status,
              label: order.statusLabel,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, AppSpacing.xxl),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _SectionCard(
                title: 'Customer',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: AppTypography.productName,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Placed ${Formatters.shortDate(order.orderedAt)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Items',
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          _iconForProduct(order.productName),
                          width: 26,
                          colorFilter: const ColorFilter.mode(
                            AppColors.bark,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.productName,
                            style: AppTypography.productName,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Qty ${order.quantity} · ${Formatters.currencyFull(unitPrice)} each',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      Formatters.currencyFull(order.totalAmount),
                      style: AppTypography.productName,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Total',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Order total',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      Formatters.currencyFull(order.totalAmount),
                      style: AppTypography.priceFullPrice,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Timeline',
                child: OrderTimelineWidget(
                  status: order.status,
                  deliveryUpdates: deliveryUpdates,
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  static String _iconForProduct(String productName) {
    final lower = productName.toLowerCase();
    if (lower.contains('sofa')) return 'assets/icons/ic_sofa.svg';
    if (lower.contains('table') || lower.contains('desk')) {
      return 'assets/icons/ic_table.svg';
    }
    return 'assets/icons/ic_chair.svg';
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.lg,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.metricLabel.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _OrderDetailShimmer extends StatelessWidget {
  const _OrderDetailShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 120,
          child: ShimmerLoader(),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: List.generate(
              4,
              (_) => const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  height: 100,
                  child: ShimmerLoader(borderRadius: AppRadii.lg),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderDetailError extends StatelessWidget {
  const _OrderDetailError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ProfileSubHero(title: 'Order'),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 40,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Could not load this order.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: onRetry,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
