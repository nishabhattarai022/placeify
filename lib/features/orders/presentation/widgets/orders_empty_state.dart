import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/haptic_service.dart';
import '../../domain/constants/order_strings.dart';
import '../../domain/enums/order_list_filter.dart';

class OrdersEmptyState extends StatelessWidget {
  const OrdersEmptyState({
    required this.filter,
    super.key,
  });

  final OrderListFilter filter;

  IconData get _icon => switch (filter) {
        OrderListFilter.all => Icons.shopping_bag_outlined,
        OrderListFilter.active => Icons.local_shipping_outlined,
        OrderListFilter.delivered => Icons.check_circle_outline_rounded,
        OrderListFilter.cancelled => Icons.cancel_outlined,
        OrderListFilter.returns => Icons.assignment_return_outlined,
      };

  bool get _showBrowseCta => filter == OrderListFilter.all;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.warmWhite,
                borderRadius: AppRadii.md,
                border: Border.all(color: AppColors.creamDark, width: 1.5),
              ),
              child: Icon(_icon, size: 28, color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            Text(
              OrderStrings.emptyTitle(filter),
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              OrderStrings.emptySubtitle(filter),
              style: AppTypography.bodyLight.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (_showBrowseCta) ...[
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  HapticService.light();
                  context.pushNamed('browse');
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.espresso,
                    borderRadius: AppRadii.pill,
                  ),
                  child: Text(
                    OrderStrings.emptyCta,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warmWhite,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
