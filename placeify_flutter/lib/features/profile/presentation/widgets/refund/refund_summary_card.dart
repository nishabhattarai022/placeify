import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/formatters.dart';

class RefundSummaryCard extends StatelessWidget {
  const RefundSummaryCard({
    required this.pendingTotal,
    required this.activeCount,
    super.key,
  });

  final double pendingTotal;
  final int activeCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Pending Refund',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            Formatters.currencyDecimal(pendingTotal),
            style: const TextStyle(
              fontFamily: 'Fraunces',
              fontSize: 34,
              fontWeight: FontWeight.w400,
              color: AppColors.espresso,
              height: 1.1,
            ),
          ),
          Text(
            activeCount == 0
                ? 'No active refund requests'
                : activeCount == 1
                    ? 'Across 1 active request'
                    : 'Across $activeCount active requests',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMuted.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
