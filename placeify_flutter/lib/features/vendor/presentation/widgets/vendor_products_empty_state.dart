import 'package:flutter/material.dart';
import 'package:placeify_flutter/features/home/data/mock_product_repository.dart';
import 'package:placeify_flutter/features/vendor/presentation/vendor_product_upload_navigation.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/haptic_service.dart';

class VendorProductsEmptyState extends StatelessWidget {
  const VendorProductsEmptyState({
    this.searchQuery,
    this.categoryId,
    this.onClearFilters,
    super.key,
  });

  final String? searchQuery;
  final String? categoryId;
  final VoidCallback? onClearFilters;

  bool get _hasActiveFilters =>
      (searchQuery != null && searchQuery!.trim().isNotEmpty) ||
      categoryId != null;

  @override
  Widget build(BuildContext context) {
    if (_hasActiveFilters) {
      return _FilteredEmptyState(onClearFilters: onClearFilters);
    }

    return _CatalogEmptyState(
      onAddProduct: () {
        HapticService.light();
        openVendorProductUpload(context);
      },
    );
  }
}

class _FilteredEmptyState extends StatelessWidget {
  const _FilteredEmptyState({this.onClearFilters});

  final VoidCallback? onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.warmWhite,
                borderRadius: AppRadii.md,
                border: Border.all(color: AppColors.creamDark, width: 1.5),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 28,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No matching products',
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or category filter.',
              style: AppTypography.bodyLight.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onClearFilters != null) ...[
              const SizedBox(height: 20),
              _EmptyStateButton(
                label: 'Clear filters',
                onTap: onClearFilters!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CatalogEmptyState extends StatelessWidget {
  const _CatalogEmptyState({required this.onAddProduct});

  final VoidCallback onAddProduct;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.warmWhite,
                borderRadius: AppRadii.md,
                border: Border.all(color: AppColors.creamDark, width: 1.5),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 28,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No products yet',
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first product to start selling on Placeify.',
              style: AppTypography.bodyLight.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _EmptyStateButton(
              label: 'Add product',
              onTap: onAddProduct,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyStateButton extends StatelessWidget {
  const _EmptyStateButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.light();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.espresso,
          borderRadius: AppRadii.pill,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.warmWhite,
          ),
        ),
      ),
    );
  }
}

String vendorProductCategoryLabel(String? categoryId) {
  if (categoryId == null) return 'All categories';
  for (final category in MockProductRepository.categories) {
    if (category.id == categoryId) return category.label;
  }
  return categoryId;
}
