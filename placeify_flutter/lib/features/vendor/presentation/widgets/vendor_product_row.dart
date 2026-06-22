import 'package:flutter/material.dart';
import 'package:placeify_flutter/features/home/data/mock_product_repository.dart';
import 'package:placeify_flutter/features/vendor/data/vendor_3d_model_store.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/vendor_product.dart';
import 'vendor_list_thumbnail.dart';

class VendorProductRow extends StatelessWidget {
  const VendorProductRow({
    required this.product,
    required this.selectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onToggleSelected,
    this.onBuild3d,
    super.key,
  });

  final VendorProduct product;
  final bool selectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onToggleSelected;
  final VoidCallback? onBuild3d;

  @override
  Widget build(BuildContext context) {
    final iconPath = _iconForCategory(product.categoryId);
    final stockLabel = '${product.stock} in stock';
    final modelStatus = Vendor3dModelStore.statusFor(product);
    final showBuild3d =
        !selectionMode && onBuild3d != null && !modelStatus.isReady;

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
            VendorListThumbnail(
              label: product.name,
              imageUrl: product.primaryImageUrl,
              fallbackIconPath: iconPath,
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
                    '${product.sku} · $stockLabel',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.currencyFull(product.price),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (modelStatus.isReady) const _ArReadyBadge(),
                  ],
                ),
                if (showBuild3d) ...[
                  const SizedBox(height: 8),
                  _Build3dChip(onTap: onBuild3d!),
                ],
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

class _ArReadyBadge extends StatelessWidget {
  const _ArReadyBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.sage.withValues(alpha: 0.14),
        borderRadius: AppRadii.pill,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.view_in_ar_rounded,
            size: 11,
            color: AppColors.sage,
          ),
          SizedBox(width: 3),
          Text(
            'AR',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.sage,
            ),
          ),
        ],
      ),
    );
  }
}

class _Build3dChip extends StatelessWidget {
  const _Build3dChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.vendorForestBg,
          borderRadius: AppRadii.pill,
          border: Border.all(
            color: AppColors.vendorForest.withValues(alpha: 0.22),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.view_in_ar_outlined,
              size: 12,
              color: AppColors.vendorForest,
            ),
            SizedBox(width: 4),
            Text(
              'Build 3D',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.vendorForest,
              ),
            ),
          ],
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
