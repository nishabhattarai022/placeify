import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/services/haptic_service.dart';
import '../../../../../core/widgets/placeify_bottom_sheet.dart';
import 'wishlist_sort.dart';

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
            for (final option in WishlistSort.values)
              PlaceifySelectTile(
                label: option.menuLabel,
                selected: current == option,
                onTap: () {
                  ref.read(wishlistSortProvider.notifier).state = option;
                  Navigator.pop(sheetContext);
                },
              ),
          ],
        );
      },
    );
  }
}
