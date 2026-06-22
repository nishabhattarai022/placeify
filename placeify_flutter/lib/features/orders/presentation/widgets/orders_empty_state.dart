import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.warmWhite,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.creamDark),
              ),
              child: Icon(
                _icon,
                size: 32,
                color: AppColors.sage.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              OrderStrings.emptyTitle(filter),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Fraunces',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.espresso,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              OrderStrings.emptySubtitle(filter),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
            if (_showBrowseCta) ...[
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  HapticService.light();
                  context.pushNamed('browse');
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.espresso,
                  foregroundColor: AppColors.warmWhite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(OrderStrings.emptyCta),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
