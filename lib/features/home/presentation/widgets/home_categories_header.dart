import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/haptic_service.dart';

/// "Categories" title row with See All action.
class HomeCategoriesHeader extends StatelessWidget {
  const HomeCategoriesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            HapticService.light();
            context.go('/browse');
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(width: 6),
                SvgPicture.asset(
                  'assets/icons/ic_arrow_right.svg',
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    AppColors.textSecondary.withValues(alpha: 0.85),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
