import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/haptic_service.dart';

class UserOrderFilterBar extends StatelessWidget {
  const UserOrderFilterBar({
    required this.filters,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;
          return GestureDetector(
            onTap: () {
              HapticService.selection();
              onSelected(index);
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
                filters[index],
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
