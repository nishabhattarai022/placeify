import 'package:flutter/material.dart';
import 'package:placeify_flutter/features/home/data/mock_product_repository.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/vendor_product.dart';
import 'vendor_list_thumbnail.dart';

class VendorProductGridTile extends StatelessWidget {
  const VendorProductGridTile({
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return VendorListThumbnail(
                            label: product.name,
                            imageUrl: product.primaryImageUrl,
                            fallbackIconPath: iconPath,
                            size: constraints.maxWidth,
                          );
                        },
                      ),
                    ),
                  ),
                  if (selectionMode)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _SelectionCheckbox(
                        selected: isSelected,
                        onToggle: onToggleSelected,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.sku,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.currencyFull(product.price),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.stock} in stock',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
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
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
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
