import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/placeify_bottom_sheet.dart';
import '../../domain/models/vendor_product.dart';

enum VendorProductSort {
  newest('Newest first'),
  oldest('Oldest first'),
  nameAsc('Name A–Z'),
  nameDesc('Name Z–A'),
  priceHigh('Price: high to low'),
  priceLow('Price: low to high'),
  stockHigh('Stock: high to low'),
  stockLow('Stock: low to high');

  const VendorProductSort(this.label);

  final String label;

  int compare(VendorProduct a, VendorProduct b) {
    return switch (this) {
      VendorProductSort.newest => b.createdAt.compareTo(a.createdAt),
      VendorProductSort.oldest => a.createdAt.compareTo(b.createdAt),
      VendorProductSort.nameAsc => a.name.toLowerCase().compareTo(
        b.name.toLowerCase(),
      ),
      VendorProductSort.nameDesc => b.name.toLowerCase().compareTo(
        a.name.toLowerCase(),
      ),
      VendorProductSort.priceHigh => b.price.compareTo(a.price),
      VendorProductSort.priceLow => a.price.compareTo(b.price),
      VendorProductSort.stockHigh => b.stock.compareTo(a.stock),
      VendorProductSort.stockLow => a.stock.compareTo(b.stock),
    };
  }
}

abstract final class VendorProductSortSheet {
  static Future<VendorProductSort?> show(
    BuildContext context,
    VendorProductSort current,
  ) {
    HapticService.light();
    return PlaceifyBottomSheet.show<VendorProductSort>(
      context,
      builder: (sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PlaceifyBottomSheetHeader(
              title: 'Sort products',
              subtitle: 'Choose how your catalog is ordered',
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final option in VendorProductSort.values)
              PlaceifySelectTile(
                label: option.label,
                icon: Icons.sort_rounded,
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
