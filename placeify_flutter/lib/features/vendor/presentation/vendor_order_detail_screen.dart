import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_client/placeify_client.dart';

import '../../../core/config/resolve_media_url.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'providers/vendor_orders_provider.dart';

class VendorOrderDetailScreen extends ConsumerWidget {
  const VendorOrderDetailScreen({required this.orderId, super.key});

  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(vendorShopOrderDetailProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.espresso),
          onPressed: () => context.pop(),
        ),
        title: orderAsync.maybeWhen(
          data: (order) => Text(
            'Order #${order.orderNumber}',
            style: const TextStyle(
              fontFamily: 'Fraunces',
              color: AppColors.espresso,
              fontWeight: FontWeight.w600,
            ),
          ),
          orElse: () => const Text(
            'Order details',
            style: TextStyle(
              fontFamily: 'Fraunces',
              color: AppColors.espresso,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(error.toString(), style: AppTypography.bodyLight),
        ),
        data: (order) => _OrderDetailBody(order: order),
      ),
    );
  }
}

class _OrderDetailBody extends StatelessWidget {
  const _OrderDetailBody({required this.order});

  final VendorShopOrder order;

  @override
  Widget build(BuildContext context) {
    final statusLabel = _statusLabel(order.status);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        0,
        AppSpacing.screenPadding,
        BottomNavTokens.scrollBottomPadding,
      ),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.warmWhite,
            borderRadius: AppRadii.md,
            border: Border.all(color: AppColors.creamDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.customerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.14),
                      borderRadius: AppRadii.pill,
                    ),
                    child: Text(
                      statusLabel,
                      style: AppTypography.statusPill.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                Formatters.orderMeta(order.orderNumber, order.placedAt),
                style: AppTypography.bodyLight,
              ),
              const SizedBox(height: 14),
              const Text(
                'Ship to',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                order.shippingAddress,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('Items from your shop', style: AppTypography.sectionTitle),
        const SizedBox(height: 12),
        for (final item in order.items) _LineItemTile(item: item),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.espresso,
            borderRadius: AppRadii.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your total',
                style: TextStyle(
                  color: Color(0xB3FFFFFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                Formatters.currencyDecimal(order.vendorTotal),
                style: AppTypography.metricValueLarge.copyWith(fontSize: 24),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _statusLabel(OrderStatus status) {
    return switch (status) {
      OrderStatus.pending => 'Pending',
      OrderStatus.confirmed => 'Confirmed',
      OrderStatus.shipped => 'Shipped',
      OrderStatus.delivered => 'Delivered',
      OrderStatus.cancelled => 'Cancelled',
    };
  }
}

class _LineItemTile extends StatelessWidget {
  const _LineItemTile({required this.item});

  final VendorOrderLineItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 56,
              height: 56,
              child: FutureBuilder<String>(
                future: resolveMediaUrl(item.thumbnailUrl),
                builder: (context, snapshot) {
                  final url = snapshot.data ?? '';
                  if (url.isEmpty) {
                    return Container(
                      color: AppColors.cream,
                      child: const Icon(Icons.chair_outlined),
                    );
                  }
                  return CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.cream,
                      child: const Icon(Icons.broken_image_outlined),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty ${item.quantity} · ${Formatters.currencyDecimal(item.unitPrice)} each',
                  style: AppTypography.bodyLight,
                ),
              ],
            ),
          ),
          Text(
            Formatters.currencyDecimal(item.lineTotal),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.espresso,
            ),
          ),
        ],
      ),
    );
  }
}
