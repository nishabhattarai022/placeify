import 'package:flutter/material.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/constants/app_radii.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/features/admin/domain/enums/vendor_application_list_filter.dart';

class ApplicationFilterChips extends StatelessWidget {
  const ApplicationFilterChips({
    required this.selected,
    required this.onSelected,
    required this.pendingCount,
    required this.approvedCount,
    required this.declinedCount,
    super.key,
  });

  final VendorApplicationListFilter selected;
  final ValueChanged<VendorApplicationListFilter> onSelected;
  final int pendingCount;
  final int approvedCount;
  final int declinedCount;

  static const _filters = VendorApplicationListFilter.values;

  int _countFor(VendorApplicationListFilter filter) => switch (filter) {
    VendorApplicationListFilter.pending => pendingCount,
    VendorApplicationListFilter.approved => approvedCount,
    VendorApplicationListFilter.declined => declinedCount,
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
      child: Row(
        children: [
          for (final filter in _filters) ...[
            _ApplicationFilterChip(
              label: _labelFor(filter),
              count: _countFor(filter),
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

  static String _labelFor(VendorApplicationListFilter filter) {
    return switch (filter) {
      VendorApplicationListFilter.pending => 'Pending',
      VendorApplicationListFilter.approved => 'Approved',
      VendorApplicationListFilter.declined => 'Declined',
    };
  }
}

class _ApplicationFilterChip extends StatelessWidget {
  const _ApplicationFilterChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.warmWhite
                    : AppColors.textSecondary,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.warmWhite.withValues(alpha: 0.2)
                      : AppColors.adminSlateBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppColors.warmWhite
                        : AppColors.adminSlate,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
