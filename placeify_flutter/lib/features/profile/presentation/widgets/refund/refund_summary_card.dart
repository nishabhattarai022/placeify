import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/haptic_service.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/widgets/toast_overlay.dart';

class RefundSummaryCard extends StatelessWidget {
  const RefundSummaryCard({
    required this.pendingTotal,
    required this.activeRequestCount,
    required this.walletCredit,
    super.key,
  });

  final double pendingTotal;
  final int activeRequestCount;
  final double walletCredit;

  @override
  Widget build(BuildContext context) {
    final activeLabel = activeRequestCount == 1
        ? 'Across 1 active request'
        : 'Across $activeRequestCount active requests';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                      activeLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Wallet Credit',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.currencyDecimal(walletCredit),
                    style: const TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.teal,
                    ),
                  ),
                  Text(
                    walletCredit > 0 ? 'Ready to use' : 'No credit yet',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _RefundActionBtn(
                  label: 'To Card',
                  icon: Icons.credit_card_outlined,
                  primary: true,
                  onTap: () => PlaceifyToast.show(
                    context,
                    'Refund to original payment',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _RefundActionBtn(
                  label: 'To Wallet',
                  icon: Icons.account_balance_wallet_outlined,
                  primary: false,
                  onTap: () => PlaceifyToast.show(context, 'Added to wallet!'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RefundActionBtn extends StatelessWidget {
  const _RefundActionBtn({
    required this.label,
    required this.icon,
    required this.primary,
    required this.onTap,
  });

  final String label;
  final IconData icon;
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: primary ? AppColors.espresso : AppColors.cream,
          borderRadius: BorderRadius.circular(999),
          border: primary
              ? null
              : Border.all(color: AppColors.sand, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: primary ? Colors.white : AppColors.espresso,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: primary ? Colors.white : AppColors.espresso,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
