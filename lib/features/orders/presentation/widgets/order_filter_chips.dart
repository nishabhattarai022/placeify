import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/services/haptic_service.dart';
import '../../domain/constants/order_strings.dart';
import '../../domain/enums/order_list_filter.dart';

class OrderFilterChips extends StatelessWidget {
  const OrderFilterChips({
    required this.selectedFilter,
    required this.onSelected,
    super.key,
  });

  final OrderListFilter selectedFilter;
  final ValueChanged<OrderListFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: OrderListFilter.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = OrderListFilter.values[index];
          final selected = filter == selectedFilter;
          return GestureDetector(
            onTap: () {
              HapticService.selection();
              onSelected(filter);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppColors.warmWhite : Colors.transparent,
                borderRadius: AppRadii.pill,
                border: Border.all(
                  color: selected ? AppColors.creamDark : AppColors.sand,
                  width: 1.5,
                ),
              ),
              child: Text(
                OrderStrings.filterLabel(filter),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color:
                      selected ? AppColors.espresso : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
