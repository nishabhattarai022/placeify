import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/constants/order_strings.dart';
import '../../domain/enums/payment_status.dart';

/// Payment status pill for consumer orders (distinct from vendor [PaymentStatusChip]).
class ConsumerPaymentStatusChip extends StatelessWidget {
  const ConsumerPaymentStatusChip({
    required this.status,
    super.key,
  });

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      PaymentStatus.pending => (AppColors.accentBg, AppColors.accent),
      PaymentStatus.received => (AppColors.sageBg, AppColors.sage),
      PaymentStatus.confirmed => (AppColors.sageBg, AppColors.bark),
      PaymentStatus.failed => (AppColors.coralBg, AppColors.rust),
      PaymentStatus.refunded => (AppColors.coralBg, AppColors.coral),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.pill,
      ),
      child: Text(
        OrderStrings.paymentStatusLabel(status),
        style: AppTypography.statusPill.copyWith(color: fg),
      ),
    );
  }
}
