import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../domain/enums/payment_status.dart';

class PaymentStatusChip extends StatelessWidget {
  const PaymentStatusChip({
    required this.status,
    super.key,
  });

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (status) {
      PaymentStatus.pending => (
          AppColors.accentBg,
          AppColors.accent,
          'Pending',
        ),
      PaymentStatus.paid => (
          AppColors.sageBg,
          AppColors.sage,
          'Payment Received',
        ),
      PaymentStatus.partial => (
          AppColors.lavenderBg,
          AppColors.lavender,
          'Partial',
        ),
      PaymentStatus.refunded => (
          AppColors.coralBg,
          AppColors.coral,
          'Refunded',
        ),
      PaymentStatus.failed => (
          AppColors.coralBg,
          AppColors.rust,
          'Failed',
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.pill,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
          letterSpacing: 0.03 * 11,
        ),
      ),
    );
  }
}
