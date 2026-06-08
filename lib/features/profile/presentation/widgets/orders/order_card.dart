import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/haptic_service.dart';
import '../../../../../core/widgets/toast_overlay.dart';
import '../../../data/profile_mock_data.dart';
import 'order_progress_tracker.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({required this.order, super.key});

  final ProfileOrder order;

  Color _statusBg() => switch (order.status) {
        OrderStatus.processing => AppColors.accentBg,
        OrderStatus.shipped => AppColors.sageBg,
        OrderStatus.delivered => AppColors.tealBg,
        OrderStatus.cancelled => const Color(0x1A9B4A2A),
      };

  Color _statusFg() => switch (order.status) {
        OrderStatus.processing => AppColors.accent,
        OrderStatus.shipped => AppColors.sage,
        OrderStatus.delivered => AppColors.teal,
        OrderStatus.cancelled => AppColors.rust,
      };

  @override
  Widget build(BuildContext context) {
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
                child: Text(order.thumbEmoji, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.productName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.espresso,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Order #${order.orderNumber} · ${order.dateLabel}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    if (order.hasArPreview) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.espresso,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.view_in_ar, size: 10, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'AR Previewed',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusBg(),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  order.statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _statusFg(),
                  ),
                ),
              ),
            ],
          ),
          if (order.status == OrderStatus.shipped)
            OrderProgressTracker(activeStep: order.progressStep),
          Divider(color: AppColors.creamDark, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.priceLabel,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.espresso,
                ),
              ),
              Text(
                order.dateDetail,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          if (order.primaryAction != null || order.secondaryAction != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (order.secondaryAction != null)
                  Expanded(
                    child: _OrderBtn(
                      label: order.secondaryAction!,
                      primary: false,
                      onTap: () => PlaceifyToast.show(
                        context,
                        '${order.secondaryAction} opened',
                      ),
                    ),
                  ),
                if (order.secondaryAction != null && order.primaryAction != null)
                  const SizedBox(width: 8),
                if (order.primaryAction != null)
                  Expanded(
                    child: _OrderBtn(
                      label: order.primaryAction!,
                      primary: true,
                      onTap: () => PlaceifyToast.show(
                        context,
                        '${order.primaryAction} opened',
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderBtn extends StatelessWidget {
  const _OrderBtn({
    required this.label,
    required this.primary,
    required this.onTap,
  });

  final String label;
  final bool primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.light();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primary ? AppColors.espresso : AppColors.cream,
          borderRadius: BorderRadius.circular(999),
          border: primary ? null : Border.all(color: AppColors.sand, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: primary ? Colors.white : AppColors.espresso,
          ),
        ),
      ),
    );
  }
}
