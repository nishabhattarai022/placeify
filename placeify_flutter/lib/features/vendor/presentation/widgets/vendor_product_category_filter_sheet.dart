import 'package:placeify_flutter/features/home/domain/constants/product_categories.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/placeify_bottom_sheet.dart';

abstract final class VendorProductCategoryFilterSheet {
  static Future<String?> show(
    BuildContext context,
    String? currentCategoryId,
  ) {
    HapticService.light();
    return PlaceifyBottomSheet.show<String?>(
      context,
      builder: (sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PlaceifyBottomSheetHeader(
              title: 'Filter by category',
              subtitle: 'Show products from a specific category',
            ),
            const SizedBox(height: AppSpacing.lg),
            PlaceifySelectTile(
              label: 'All categories',
              icon: Icons.category_outlined,
              selected: currentCategoryId == null,
              onTap: () {
                HapticService.selection();
                Navigator.pop(sheetContext, null);
              },
            ),
            for (final category in ProductCategories.all)
              PlaceifySelectTile(
                label: category.label,
                selected: currentCategoryId == category.id,
                onTap: () {
                  HapticService.selection();
                  Navigator.pop(sheetContext, category.id);
                },
              ),
          ],
        );
      },
    );
  }
}
