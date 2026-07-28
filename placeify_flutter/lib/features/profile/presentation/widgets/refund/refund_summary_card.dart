import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../domain/constants/refund_strings.dart';
import '../../../../home/presentation/chairs_catalog_tokens.dart';

class RefundSummaryCard extends StatelessWidget {
  const RefundSummaryCard({
    required this.activeRequestCount,
    required this.pendingTotal,
    required this.completedTotal,
    this.destinationPreview,
    super.key,
  });

  final int activeRequestCount;
  final double pendingTotal;
  final double completedTotal;
  final String? destinationPreview;

  @override
  Widget build(BuildContext context) {
    final hasActive = activeRequestCount > 0 || pendingTotal > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ChairsCatalogTokens.imageWell,
        borderRadius: BorderRadius.circular(ChairsCatalogTokens.wideCardRadius),
        boxShadow: ChairsCatalogTokens.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      hasActive
                          ? Formatters.currencyDecimal(pendingTotal)
                          : RefundStrings.noActiveRefunds,
                      style: AppFonts.dmSans(
                        fontSize: hasActive ? 34 : 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (hasActive)
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
                    RefundStrings.completedCreditLabel,
                    style: AppFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.currencyDecimal(completedTotal),
                    style: AppFonts.dmSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    RefundStrings.completedCreditHint,
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
          const SizedBox(height: 14),
          Text(
            destinationPreview?.trim().isNotEmpty == true
                ? destinationPreview!
                : RefundStrings.destinationHint,
            style: AppFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
