import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/placeify_bottom_sheet.dart';

enum VendorOrderDateFilter {
  all('All dates'),
  today('Today'),
  last7Days('Last 7 days'),
  last30Days('Last 30 days');

  const VendorOrderDateFilter(this.label);

  final String label;

  bool matches(DateTime orderedAt) {
    if (this == VendorOrderDateFilter.all) return true;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final orderDay = DateTime(
      orderedAt.year,
      orderedAt.month,
      orderedAt.day,
    );

    return switch (this) {
      VendorOrderDateFilter.today => orderDay == today,
      VendorOrderDateFilter.last7Days => orderedAt.isAfter(
        now.subtract(const Duration(days: 7)),
      ),
      VendorOrderDateFilter.last30Days => orderedAt.isAfter(
        now.subtract(const Duration(days: 30)),
      ),
      VendorOrderDateFilter.all => true,
    };
  }
}

abstract final class VendorOrderDateFilterSheet {
  static Future<VendorOrderDateFilter?> show(
    BuildContext context,
    VendorOrderDateFilter current,
  ) {
    HapticService.light();
    return PlaceifyBottomSheet.show<VendorOrderDateFilter>(
      context,
      builder: (sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PlaceifyBottomSheetHeader(
              title: 'Filter by date',
              subtitle: 'Show orders from a specific time range',
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final option in VendorOrderDateFilter.values)
              PlaceifySelectTile(
                label: option.label,
                icon: Icons.calendar_today_outlined,
                selected: current == option,
                onTap: () {
                  HapticService.selection();
                  Navigator.pop(sheetContext, option);
                },
              ),
          ],
        );
      },
    );
  }
}
