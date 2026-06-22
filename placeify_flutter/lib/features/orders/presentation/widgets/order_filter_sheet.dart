import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/placeify_bottom_sheet.dart';
import '../../domain/constants/order_strings.dart';
import '../../domain/enums/order_list_filter.dart';

abstract final class OrderFilterSheet {
  static Future<void> show(
    BuildContext context,
    OrderListFilter current,
    ValueChanged<OrderListFilter> onSelected,
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
              title: OrderStrings.filterSheetTitle,
              subtitle: OrderStrings.filterSheetSubtitle,
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final filter in OrderListFilter.values)
              PlaceifySelectTile(
                label: filter.menuLabel,
                icon: filter.icon,
                selected: current == filter,
                semanticsLabel:
                    '${OrderStrings.filterSheetTitle}: ${filter.menuLabel}',
                onTap: () => _selectFilter(
                  sheetContext,
                  current,
                  filter,
                  onSelected,
                ),
              ),
          ],
        );
      },
    );
  }

  static void _selectFilter(
    BuildContext sheetContext,
    OrderListFilter current,
    OrderListFilter option,
    ValueChanged<OrderListFilter> onSelected,
  ) {
    if (current != option) {
      HapticService.selection();
      onSelected(option);
    }
    Navigator.pop(sheetContext);
  }
}
