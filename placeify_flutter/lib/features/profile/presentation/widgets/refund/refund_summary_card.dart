import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/widgets/toast_overlay.dart';
import '../../../domain/constants/refund_strings.dart';
import '../../../../home/presentation/chairs_catalog_tokens.dart';
import 'refund_action_button.dart';

class RefundSummaryCard extends StatelessWidget {
  const RefundSummaryCard({
    required this.activeRequestCount,
    super.key,
  });

  final int activeRequestCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ChairsCatalogTokens.imageWell,
        borderRadius: BorderRadius.circular(ChairsCatalogTokens.wideCardRadius),
        boxShadow: ChairsCatalogTokens.cardShadow,
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
                    Text(
                      RefundStrings.totalPendingLabel,
                      style: AppFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'NPR 45.00',
                      style: AppFonts.dmSans(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      RefundStrings.activeRequestsCount(activeRequestCount),
                      style: AppFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    RefundStrings.walletCreditLabel,
                    style: AppFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NPR 20.00',
                    style: AppFonts.dmSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    RefundStrings.walletReadyLabel,
                    style: AppFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: RefundActionButton(
                  label: RefundStrings.toCard,
                  icon: Icons.credit_card_outlined,
                  onTap: () => PlaceifyToast.show(
                    context,
                    RefundStrings.refundToCardToast,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RefundActionButton(
                  label: RefundStrings.toWallet,
                  icon: Icons.account_balance_wallet_outlined,
                  primary: false,
                  onTap: () => PlaceifyToast.show(
                    context,
                    RefundStrings.addedToWalletToast,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
