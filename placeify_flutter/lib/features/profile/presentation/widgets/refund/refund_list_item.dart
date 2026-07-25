import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radii.dart';
import '../../../../../core/constants/app_typography.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../domain/models/profile_ui_models.dart';
import '../../../../home/presentation/chairs_catalog_tokens.dart';

class RefundListItem extends StatelessWidget {
  const RefundListItem({required this.refund, super.key});

  final ProfileRefund refund;

  @override
  Widget build(BuildContext context) {
    final (statusBg, statusFg) = switch (refund.status) {
      RefundStatus.refunded => (AppColors.sageBg, AppColors.sage),
      RefundStatus.rejected => (const Color(0x14B45309), const Color(0xFFB45309)),
      RefundStatus.underReview => (const Color(0x141A1A1A), AppColors.textPrimary),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ChairsCatalogTokens.imageWell,
        borderRadius: BorderRadius.circular(ChairsCatalogTokens.compactCardRadius),
        boxShadow: ChairsCatalogTokens.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.cartQtyPill,
              borderRadius: AppRadii.md,
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
                  refund.referenceNumber ?? 'Refund #${refund.id}',
                  style: AppFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  refund.productName,
                  style: AppFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  refund.reason,
                  style: AppFonts.dmSerifDisplay(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textMuted,
                    height: 1.35,
                  ),
                ),
                if (refund.destinationLabel != null &&
                    refund.destinationLabel!.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    refund.destinationLabel!,
                    style: AppFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
                if (refund.gatewayReference != null &&
                    refund.gatewayReference!.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Gateway: ${refund.gatewayReference}',
                    style: AppFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
                if (refund.rejectionReason != null &&
                    refund.rejectionReason!.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    refund.rejectionReason!,
                    style: AppFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFB45309),
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  refund.completedDateLabel != null
                      ? 'Completed ${refund.completedDateLabel}'
                      : 'Requested ${refund.requestedDateLabel}',
                  style: AppFonts.dmSans(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: AppRadii.pill,
                  ),
                  child: Text(
                    refund.statusLabel,
                    style: AppTypography.statusPill.copyWith(
                      color: statusFg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            refund.amountLabel,
            style: AppFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
