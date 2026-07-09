import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../data/profile_mock_data.dart';

class RefundListItem extends StatelessWidget {
  const RefundListItem({required this.refund, super.key});

  final ProfileRefund refund;

  @override
  Widget build(BuildContext context) {
    final statusLabel =
        refund.status == RefundStatus.refunded ? 'Refunded' : 'Under Review';
    final statusBg = refund.status == RefundStatus.refunded
        ? AppColors.tealBg
        : AppColors.accentBg;
    final statusFg =
        refund.status == RefundStatus.refunded ? AppColors.teal : AppColors.accent;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(14),
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
            alignment: Alignment.center,
            child: Text(refund.thumbEmoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  refund.productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.espresso,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  refund.reason,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: statusFg,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            refund.amountLabel,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: refund.isCompleted ? AppColors.espresso : AppColors.teal,
            ),
          ),
        ],
      ),
    );
  }
}
