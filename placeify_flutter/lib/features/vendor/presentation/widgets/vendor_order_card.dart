import 'package:flutter/material.dart';
import 'package:placeify_client/placeify_client.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/order.dart' as ui;

class VendorOrderCard extends StatelessWidget {
  const VendorOrderCard({
    required this.order,
    required this.onTap,
    super.key,
  });

  final VendorShopOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = _mapStatus(order.status);
    final primaryName = order.items.isEmpty
        ? 'Order items'
        : order.items.first.productName;
    final extraCount = order.itemCount > 1 ? ' · ${order.itemCount} items' : '';

    return Material(
      color: AppColors.warmWhite,
      borderRadius: AppRadii.md,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.md,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: AppRadii.md,
            border: Border.all(color: AppColors.creamDark, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: AppColors.bark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$primaryName$extraCount',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Order #${order.orderNumber} · ${order.customerName}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      Formatters.orderMeta(order.orderNumber, order.placedAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Formatters.currencyDecimal(order.vendorTotal),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.espresso,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _StatusPill(status: status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ui.OrderStatus _mapStatus(OrderStatus status) {
    return switch (status) {
      OrderStatus.pending ||
      OrderStatus.confirmed ||
      OrderStatus.accepted =>
        ui.OrderStatus.pending,
      OrderStatus.processing => ui.OrderStatus.pending,
      OrderStatus.rejected => ui.OrderStatus.pending,
      OrderStatus.shipped || OrderStatus.delivered => ui.OrderStatus.shipped,
      OrderStatus.cancelled => ui.OrderStatus.pending,
    };
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final ui.OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      ui.OrderStatus.pending => 'Pending',
      ui.OrderStatus.shipped => 'Shipped',
      ui.OrderStatus.customRequest => 'Request',
    };
    final (bg, fg) = switch (status) {
      ui.OrderStatus.pending => (
          AppColors.accent.withValues(alpha: 0.14),
          AppColors.accent,
        ),
      ui.OrderStatus.shipped => (
          AppColors.sage.withValues(alpha: 0.14),
          AppColors.sage,
        ),
      ui.OrderStatus.customRequest => (
          AppColors.rust.withValues(alpha: 0.12),
          AppColors.rust,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.pill,
      ),
      child: Text(
        label,
        style: AppTypography.statusPill.copyWith(color: fg),
      ),
    );
  }
}
