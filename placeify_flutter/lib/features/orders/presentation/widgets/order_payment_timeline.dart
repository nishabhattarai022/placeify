import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/constants/order_strings.dart';
import '../../domain/enums/payment_status.dart';
import '../../domain/models/order.dart';
import '../../domain/models/order_payment_event.dart';
import 'consumer_payment_status_chip.dart';

/// Vendor-recorded payment updates only (no auto-created pending rows).
class OrderPaymentTimeline extends StatelessWidget {
  const OrderPaymentTimeline({
    required this.order,
    super.key,
  });

  final Order order;

  @override
  Widget build(BuildContext context) {
    final events = [...order.paymentUpdates]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Current status',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ConsumerPaymentStatusChip(status: order.paymentStatus),
          ],
        ),
        const SizedBox(height: 14),
        if (events.isEmpty)
          const Text(
            OrderStrings.noPaymentUpdatesYet,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          )
        else
          Column(
            children: [
              for (var i = 0; i < events.length; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                _PaymentEventRow(event: events[i]),
              ],
            ],
          ),
      ],
    );
  }
}

class _PaymentEventRow extends StatelessWidget {
  const _PaymentEventRow({required this.event});

  final OrderPaymentEvent event;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ConsumerPaymentStatusChip(status: event.status),
              const Spacer(),
              Text(
                Formatters.shortDate(event.timestamp),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          if (event.note != null && event.note!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              event.note!,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
