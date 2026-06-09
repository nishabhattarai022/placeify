import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/services/haptic_service.dart';
import '../../../../../core/widgets/placeify_bottom_sheet.dart';
import 'wishlist_sort.dart';

const _sortGroups = [
  WishlistSortGroup.dateAdded,
  WishlistSortGroup.price,
  WishlistSortGroup.name,
];

abstract final class WishlistSortSheet {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    WishlistSort current,
  ) {
    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PlaceifyBottomSheetHeader(title: 'Sort by'),
            const SizedBox(height: AppSpacing.md),
            for (var i = 0; i < _sortGroups.length; i++) ...[
              if (i > 0)
                const Divider(
                  color: AppColors.creamDark,
                  height: 1,
                  thickness: 1,
                ),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _WishlistSortSectionHeader(
                      label: _sortGroups[i].sectionLabel,
                    ),
                    for (final option in WishlistSort.values
                        .where((sort) => sort.group == _sortGroups[i]))
                      _WishlistSortOptionTile(
                        label: option.tileLabel,
                        icon: option.icon,
                        selected: current == option,
                        onTap: () {
                          ref.read(wishlistSortProvider.notifier).state =
                              option;
                          Navigator.pop(sheetContext);
                        },
                      ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _WishlistSortSectionHeader extends StatelessWidget {
  const _WishlistSortSectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _WishlistSortOptionTile extends StatelessWidget {
  const _WishlistSortOptionTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.cream : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected
                        ? AppColors.espresso
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_rounded,
                  size: 20,
                  color: AppColors.espresso,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
