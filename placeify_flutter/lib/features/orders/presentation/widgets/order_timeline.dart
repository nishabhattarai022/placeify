import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/constants/order_strings.dart';
import '../../domain/enums/consumer_order_status.dart';
import '../../domain/models/order.dart';
import '../../domain/models/order_status_update.dart';

/// Chronological vendor-posted updates only (no inferred lifecycle steps).
class OrderTimeline extends StatelessWidget {
  const OrderTimeline({
    required this.order,
    super.key,
  });

  final Order order;

  @override
  Widget build(BuildContext context) {
    final events = [...order.statusHistory]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (events.isEmpty) {
      if (order.isCancelled) {
        return const _CancelledBanner();
      }
      return const Text(
        OrderStrings.noVendorUpdatesYet,
        style: TextStyle(
          fontSize: 13,
          color: AppColors.textSecondary,
          height: 1.45,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < events.length; i++)
          _VendorUpdateRow(
            update: events[i],
            isLast: i == events.length - 1 && !order.isCancelled,
            highlightAsLatest:
                i == events.length - 1 && order.isActive && !order.isCancelled,
          ),
        if (order.isCancelled) ...[
          const SizedBox(height: 8),
          const _CancelledBanner(),
        ],
      ],
    );
  }
}

class _VendorUpdateRow extends StatelessWidget {
  const _VendorUpdateRow({
    required this.update,
    required this.isLast,
    required this.highlightAsLatest,
  });

  final OrderStatusUpdate update;
  final bool isLast;
  final bool highlightAsLatest;

  @override
  Widget build(BuildContext context) {
    final dotColor =
        highlightAsLatest ? AppColors.accent : AppColors.teal;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: dotColor, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.check, size: 10, color: Colors.white),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: AppColors.teal,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    OrderStrings.statusLabel(update.status),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: highlightAsLatest
                          ? AppColors.textPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.shortDate(update.timestamp),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  if (update.note != null && update.note!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      update.note!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelledBanner extends StatelessWidget {
  const _CancelledBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.coralBg,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.coral.withValues(alpha: 0.2)),
      ),
      child: Text(
        OrderStrings.statusLabel(ConsumerOrderStatus.cancelled),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.coral,
        ),
      ),
    );
  }
}
