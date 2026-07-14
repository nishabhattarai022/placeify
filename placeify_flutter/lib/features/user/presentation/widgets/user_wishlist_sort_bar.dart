import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/haptic_service.dart';
import '../../data/user_wishlist_mappers.dart';

class UserWishlistSortBar extends StatelessWidget {
  const UserWishlistSortBar({
    required this.sort,
    required this.onChanged,
    super.key,
  });

  final UserWishlistSort sort;
  final ValueChanged<UserWishlistSort> onChanged;

  static const _options = UserWishlistSort.values;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final option = _options[index];
          final selected = option == sort;
          return GestureDetector(
            onTap: () {
              HapticService.selection();
              onChanged(option);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppColors.forest : AppColors.warmWhite,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: selected ? AppColors.forest : AppColors.creamDark,
                ),
              ),
              child: Text(
                UserWishlistMappers.sortLabels[option]!,
                style: AppTypography.metricLabel.copyWith(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
