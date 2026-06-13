import 'package:flutter/material.dart';
import 'package:placeify_client/placeify_client.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../profile/presentation/widgets/orders/order_progress_tracker.dart';
import '../../data/user_order_mappers.dart';

class UserOrderCard extends StatelessWidget {
  const UserOrderCard({required this.order, super.key});

  final UserOrderSummary order;

  @override
  Widget build(BuildContext context) {
    final colors = UserOrderMappers.statusColors(order.status);
    final showProgress = order.status == OrderStatus.shipped;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.inventory_2_outlined,
                  size: 28,
                  color: AppColors.bark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UserOrderMappers.productTitle(order),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.espresso,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      UserOrderMappers.orderMeta(order),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  UserOrderMappers.statusLabel(order.status),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.foreground,
                  ),
                ),
              ),
            ],
          ),
          if (showProgress)
            OrderProgressTracker(
              activeStep: UserOrderMappers.progressStep(order.status),
            ),
          Divider(color: AppColors.creamDark, height: showProgress ? 12 : 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                UserOrderMappers.totalLabel(order),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.espresso,
                ),
              ),
              Text(
                UserOrderMappers.placedLabel(order),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
