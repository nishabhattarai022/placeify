import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_typography.dart';

class VendorProductStatusChip extends StatelessWidget {
  const VendorProductStatusChip({
    required this.isActive,
    super.key,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = isActive
        ? (
            AppColors.sage.withValues(alpha: 0.14),
            AppColors.sage,
            'Active',
          )
        : (
            AppColors.textMuted.withValues(alpha: 0.14),
            AppColors.textMuted,
            'Hidden',
          );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.pill,
      ),
      child: Text(
        label,
        style: AppTypography.statusPill.copyWith(color: fg),
      ),
    );
  }
}
