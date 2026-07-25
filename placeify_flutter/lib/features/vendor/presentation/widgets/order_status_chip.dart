import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/enums/order_status.dart';

/// Semantic status pill for vendor orders.
class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({
    required this.status,
    required this.label,
    super.key,
  });

  final OrderStatus status;
  final String label;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      OrderStatus.pending => (
          AppColors.accent.withValues(alpha: 0.14),
          AppColors.accent,
        ),
      OrderStatus.accepted || OrderStatus.processing => (
          AppColors.sage.withValues(alpha: 0.14),
          AppColors.sage,
        ),
      OrderStatus.shipped || OrderStatus.returnRequested => (
          AppColors.sage.withValues(alpha: 0.14),
          AppColors.sage,
        ),
      OrderStatus.delivered || OrderStatus.refunded => (
          AppColors.tealBg,
          AppColors.teal,
        ),
      OrderStatus.rejected || OrderStatus.cancelled => (
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
