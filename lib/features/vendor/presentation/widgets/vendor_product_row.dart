import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:placeify/features/home/data/mock_product_repository.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/vendor_product.dart';
import 'vendor_product_status_chip.dart';

class VendorProductRow extends StatelessWidget {
  const VendorProductRow({
    required this.product,
    required this.selectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onToggleSelected,
    super.key,
  });

  final VendorProduct product;
  final bool selectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onToggleSelected;

  @override
  Widget build(BuildContext context) {
    final iconPath = _iconForCategory(product.categoryId);
    final meta = '${product.sku} · ${product.stock} in stock';

    return GestureDetector(
      onTap: () {
        HapticService.light();
        onTap();
      },
      onLongPress: () {
        HapticService.medium();
        onLongPress();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.08)
              : AppColors.warmWhite,
          borderRadius: AppRadii.md,
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.creamDark,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            if (selectionMode) ...[
              _SelectionCheckbox(
                selected: isSelected,
                onToggle: onToggleSelected,
              ),
              const SizedBox(width: 10),
            ],
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 24,
                  colorFilter: const ColorFilter.mode(
                    AppColors.bark,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    meta,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.currencyFull(product.price),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (product.isLowStock) ...[
                      const _LowStockBadge(),
                      const SizedBox(width: 6),
                    ],
                    VendorProductStatusChip(isActive: product.isActive),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _iconForCategory(String categoryId) {
    for (final category in MockProductRepository.categories) {
      if (category.id == categoryId) return category.svgIconAssetPath;
    }
    return 'assets/icons/ic_chair.svg';
  }
}

class _LowStockBadge extends StatelessWidget {
  const _LowStockBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.coralBg,
        borderRadius: AppRadii.pill,
      ),
      child: const Text(
        'Low stock',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.coral,
        ),
      ),
    );
  }
}

class _SelectionCheckbox extends StatelessWidget {
  const _SelectionCheckbox({
    required this.selected,
    required this.onToggle,
  });

  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.selection();
        onToggle();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: selected ? AppColors.espresso : AppColors.warmWhite,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: selected ? AppColors.espresso : AppColors.creamDark,
            width: 1.5,
          ),
        ),
        child: selected
            ? const Icon(
                Icons.check_rounded,
                size: 16,
                color: AppColors.warmWhite,
              )
            : null,
      ),
    );
  }
}
