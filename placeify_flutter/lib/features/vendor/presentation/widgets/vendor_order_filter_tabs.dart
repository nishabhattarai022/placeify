import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/services/haptic_service.dart';

enum VendorOrderTab {
  pending('Pending'),
  active('Active'),
  completed('Completed'),
  cancelled('Cancelled');

  const VendorOrderTab(this.label);

  final String label;
}

class VendorOrderFilterTabs extends StatelessWidget {
  const VendorOrderFilterTabs({
    required this.selectedTab,
    required this.onSelected,
    super.key,
  });

  final VendorOrderTab selectedTab;
  final ValueChanged<VendorOrderTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: VendorOrderTab.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tab = VendorOrderTab.values[index];
          final selected = tab == selectedTab;
          return GestureDetector(
            onTap: () {
              HapticService.selection();
              onSelected(tab);
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
                tab.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? AppColors.espresso : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
