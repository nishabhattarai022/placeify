import 'package:flutter/material.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_radii.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/features/admin/domain/enums/admin_vendor_list_filter.dart';

class VendorFilterChips extends StatelessWidget {
  const VendorFilterChips({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final AdminVendorListFilter selected;
  final ValueChanged<AdminVendorListFilter> onSelected;

  static const _filters = AdminVendorListFilter.values;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
      child: Row(
        children: [
          for (final filter in _filters) ...[
            _VendorFilterChip(
              label: _labelFor(filter),
              isSelected: selected == filter,
              onTap: () {
                HapticService.light();
                onSelected(filter);
              },
            ),
            if (filter != _filters.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  static String _labelFor(AdminVendorListFilter filter) {
    return switch (filter) {
      AdminVendorListFilter.all => 'All',
      AdminVendorListFilter.approved => 'Approved',
      AdminVendorListFilter.suspended => 'Suspended',
    };
  }
}

class _VendorFilterChip extends StatelessWidget {
  const _VendorFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.adminSlate : AppColors.warmWhite,
          borderRadius: AppRadii.pill,
          border: Border.all(
            color: isSelected ? AppColors.adminSlate : AppColors.creamDark,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.warmWhite : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
