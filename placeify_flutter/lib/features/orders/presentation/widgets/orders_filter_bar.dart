import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/animated_scale_tap.dart';
import '../../domain/enums/order_list_filter.dart';

class OrdersFilterBar extends StatelessWidget {
  const OrdersFilterBar({
    required this.filter,
    required this.onFilterTap,
    super.key,
  });

  final OrderListFilter filter;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        8,
        AppSpacing.screenPadding,
        12,
      ),
      child: Row(
        children: [
          Icon(
            filter.icon,
            size: 16,
            color: AppColors.textMuted,
          ),
          const SizedBox(width: 6),
          Text(
            filter.barLabel,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
          const Spacer(),
          AnimatedScaleTap(
            onTap: onFilterTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.warmWhite,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.creamDark),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Filter by',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.espresso,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.unfold_more_rounded,
                    size: 18,
                    color: AppColors.espresso,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
