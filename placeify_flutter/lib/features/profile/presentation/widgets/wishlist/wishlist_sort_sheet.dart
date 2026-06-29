import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/services/haptic_service.dart';
import '../../../../../core/widgets/placeify_bottom_sheet.dart';
import 'wishlist_sort.dart';
import 'wishlist_sort_provider.dart';

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
            const PlaceifyBottomSheetHeader(
              title: 'Sort by',
              subtitle: 'Choose how items are ordered',
            ),
            const SizedBox(height: AppSpacing.lg),
            for (var i = 0; i < _sortGroups.length; i++) ...[
              if (i > 0)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Divider(
                    color: AppColors.creamDark,
                    height: 1,
                    thickness: 1,
                  ),
                ),
              _WishlistSortSectionHeader(
                label: _sortGroups[i].sectionLabel,
              ),
              for (final option in WishlistSort.values.where(
                (sort) => sort.group == _sortGroups[i],
              ))
                PlaceifySelectTile(
                  label: option.tileLabel,
                  icon: option.icon,
                  selected: current == option,
                  semanticsLabel:
                      '${_sortGroups[i].sectionLabel}: ${option.tileLabel}',
                  onTap: () => _selectSort(
                    sheetContext,
                    ref,
                    current,
                    option,
                  ),
                ),
            ],
          ],
        );
      },
    );
  }

  static void _selectSort(
    BuildContext sheetContext,
    WidgetRef ref,
    WishlistSort current,
    WishlistSort option,
  ) {
    if (current != option) {
      HapticService.selection();
      ref.read(wishlistSortProvider.notifier).select(option);
    }
    Navigator.pop(sheetContext);
  }
}

class _WishlistSortSectionHeader extends StatelessWidget {
  const _WishlistSortSectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.xs,
        bottom: AppSpacing.xs,
      ),
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
