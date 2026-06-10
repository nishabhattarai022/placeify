import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify/features/vendor/domain/constants/vendor_routes.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../domain/models/vendor_product.dart';
import 'providers/vendor_products_provider.dart';
import 'widgets/vendor_product_category_filter_sheet.dart';
import 'widgets/vendor_product_delete_sheet.dart';
import 'widgets/vendor_product_grid_tile.dart';
import 'widgets/vendor_product_row.dart';
import 'widgets/vendor_product_sort_sheet.dart';
import 'widgets/vendor_products_empty_state.dart';

enum _VendorProductViewMode { list, grid }

class VendorProductsScreen extends ConsumerStatefulWidget {
  const VendorProductsScreen({super.key});

  @override
  ConsumerState<VendorProductsScreen> createState() =>
      _VendorProductsScreenState();
}

class _VendorProductsScreenState extends ConsumerState<VendorProductsScreen> {
  _VendorProductViewMode _viewMode = _VendorProductViewMode.list;
  VendorProductSort _sort = VendorProductSort.newest;
  String? _categoryFilter;
  String _searchQuery = '';
  bool _selectionMode = false;
  final Set<String> _selectedIds = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<VendorProduct> _filterProducts(List<VendorProduct> products) {
    final query = _searchQuery.trim().toLowerCase();

    return products.where((product) {
      if (_categoryFilter != null && product.categoryId != _categoryFilter) {
        return false;
      }
      if (query.isEmpty) return true;

      return product.name.toLowerCase().contains(query) ||
          product.sku.toLowerCase().contains(query) ||
          product.id.toLowerCase().contains(query);
    }).toList()
      ..sort(_sort.compare);
  }

  Future<void> _onRefresh() async {
    await ref.read(vendorProductsProvider.notifier).refresh();
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
      _categoryFilter = null;
    });
  }

  void _enterSelectionMode([String? productId]) {
    setState(() {
      _selectionMode = true;
      if (productId != null) {
        _selectedIds.add(productId);
      }
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _selectionMode = false;
      _selectedIds.clear();
    });
  }

  void _toggleSelected(String productId) {
    setState(() {
      if (_selectedIds.contains(productId)) {
        _selectedIds.remove(productId);
        if (_selectedIds.isEmpty) {
          _selectionMode = false;
        }
      } else {
        _selectedIds.add(productId);
      }
    });
  }

  void _handleProductTap(VendorProduct product) {
    if (_selectionMode) {
      _toggleSelected(product.id);
      return;
    }
    context.push(VendorRoutes.productEdit(product.id));
  }

  Future<void> _openSortSheet() async {
    final selected = await VendorProductSortSheet.show(context, _sort);
    if (selected != null && selected != _sort) {
      setState(() => _sort = selected);
    }
  }

  Future<void> _openCategoryFilter() async {
    final selected = await VendorProductCategoryFilterSheet.show(
      context,
      _categoryFilter,
    );
    if (selected != _categoryFilter) {
      setState(() => _categoryFilter = selected);
    }
  }

  Future<void> _confirmDelete() async {
    if (_selectedIds.isEmpty) return;

    await VendorProductDeleteSheet.show(
      context,
      ref,
      count: _selectedIds.length,
      productIds: _selectedIds.toList(),
      onDeleted: _exitSelectionMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(vendorProductsProvider);
    final hasCategoryFilter = _categoryFilter != null;

    return Scaffold(
      backgroundColor: AppColors.cream,
      floatingActionButton: _selectionMode
          ? null
          : FloatingActionButton(
              onPressed: () {
                HapticService.light();
                context.push(VendorRoutes.productsUpload);
              },
              backgroundColor: AppColors.espresso,
              foregroundColor: AppColors.warmWhite,
              child: const Icon(Icons.add_rounded),
            ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectionMode
                              ? '${_selectedIds.length} selected'
                              : 'Products',
                          style: AppTypography.sectionTitle,
                        ),
                      ),
                      if (_selectionMode)
                        _HeaderTextButton(
                          label: 'Cancel',
                          onTap: _exitSelectionMode,
                        )
                      else ...[
                        _HeaderTextButton(
                          label: 'Select',
                          onTap: () => _enterSelectionMode(),
                        ),
                        const SizedBox(width: 4),
                        _ViewModeToggle(
                          viewMode: _viewMode,
                          onChanged: (mode) => setState(() => _viewMode = mode),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _VendorProductsSearchField(
                          controller: _searchController,
                          enabled: !_selectionMode,
                          onChanged: (value) =>
                              setState(() => _searchQuery = value),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _FilterIconButton(
                        icon: Icons.sort_rounded,
                        isActive: _sort != VendorProductSort.newest,
                        onTap: _openSortSheet,
                      ),
                      const SizedBox(width: 8),
                      _FilterIconButton(
                        icon: Icons.tune_rounded,
                        isActive: hasCategoryFilter,
                        onTap: _openCategoryFilter,
                      ),
                    ],
                  ),
                  if (hasCategoryFilter) ...[
                    const SizedBox(height: 10),
                    _ActiveFilterChip(
                      label: vendorProductCategoryLabel(_categoryFilter),
                      onClear: () => setState(() => _categoryFilter = null),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: productsAsync.when(
                loading: () => _ProductsListShimmer(
                  viewMode: _viewMode,
                ),
                error: (_, __) => VendorProductsEmptyState(
                  onClearFilters: _clearFilters,
                ),
                data: (products) {
                  final filtered = _filterProducts(products);

                  if (filtered.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: AppColors.espresso,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        children: [
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.35,
                            child: VendorProductsEmptyState(
                              searchQuery: _searchQuery,
                              categoryId: _categoryFilter,
                              onClearFilters: _clearFilters,
                            ),
                          ),
                          SizedBox(
                            height: _selectionMode
                                ? 88
                                : BottomNavTokens.scrollBottomPadding,
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: AppColors.espresso,
                    child: _viewMode == _VendorProductViewMode.list
                        ? _buildList(filtered)
                        : _buildGrid(filtered),
                  );
                },
              ),
            ),
            if (_selectionMode)
              _BulkActionBar(
                count: _selectedIds.length,
                onDelete: _confirmDelete,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<VendorProduct> products) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        _selectionMode ? 88 : BottomNavTokens.scrollBottomPadding,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return VendorProductRow(
          product: product,
          selectionMode: _selectionMode,
          isSelected: _selectedIds.contains(product.id),
          onTap: () => _handleProductTap(product),
          onLongPress: () => _enterSelectionMode(product.id),
          onToggleSelected: () => _toggleSelected(product.id),
        );
      },
    );
  }

  Widget _buildGrid(List<VendorProduct> products) {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        _selectionMode ? 88 : BottomNavTokens.scrollBottomPadding,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.78,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return VendorProductGridTile(
          product: product,
          selectionMode: _selectionMode,
          isSelected: _selectedIds.contains(product.id),
          onTap: () => _handleProductTap(product),
          onLongPress: () => _enterSelectionMode(product.id),
          onToggleSelected: () => _toggleSelected(product.id),
        );
      },
    );
  }
}

class _HeaderTextButton extends StatelessWidget {
  const _HeaderTextButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.light();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.espresso,
          ),
        ),
      ),
    );
  }
}

class _ViewModeToggle extends StatelessWidget {
  const _ViewModeToggle({
    required this.viewMode,
    required this.onChanged,
  });

  final _VendorProductViewMode viewMode;
  final ValueChanged<_VendorProductViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.pill,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ViewModeButton(
            icon: Icons.view_list_rounded,
            selected: viewMode == _VendorProductViewMode.list,
            onTap: () => onChanged(_VendorProductViewMode.list),
          ),
          _ViewModeButton(
            icon: Icons.grid_view_rounded,
            selected: viewMode == _VendorProductViewMode.grid,
            onTap: () => onChanged(_VendorProductViewMode.grid),
          ),
        ],
      ),
    );
  }
}

class _ViewModeButton extends StatelessWidget {
  const _ViewModeButton({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.selection();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 32,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: selected ? AppColors.espresso : Colors.transparent,
          borderRadius: AppRadii.pill,
        ),
        child: Icon(
          icon,
          size: 18,
          color: selected ? AppColors.warmWhite : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _VendorProductsSearchField extends StatelessWidget {
  const _VendorProductsSearchField({
    required this.controller,
    required this.onChanged,
    this.enabled = true,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.pill,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
        style: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search products, SKU',
          hintStyle: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textMuted,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 22,
            color: AppColors.textSecondary,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          isDense: true,
        ),
      ),
    );
  }
}

class _FilterIconButton extends StatelessWidget {
  const _FilterIconButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.light();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isActive ? AppColors.accentBg : AppColors.warmWhite,
          borderRadius: AppRadii.pill,
          border: Border.all(
            color: isActive ? AppColors.accent : AppColors.creamDark,
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? AppColors.accent : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _ActiveFilterChip extends StatelessWidget {
  const _ActiveFilterChip({
    required this.label,
    required this.onClear,
  });

  final String label;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          HapticService.light();
          onClear();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accentBg,
            borderRadius: AppRadii.pill,
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.close_rounded,
                size: 16,
                color: AppColors.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BulkActionBar extends StatelessWidget {
  const _BulkActionBar({
    required this.count,
    required this.onDelete,
  });

  final int count;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        border: Border(
          top: BorderSide(color: AppColors.creamDark, width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.espresso.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: count == 0
              ? null
              : () {
                  HapticService.medium();
                  onDelete();
                },
          child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: count == 0
                  ? AppColors.rust.withValues(alpha: 0.35)
                  : AppColors.rust,
              borderRadius: AppRadii.pill,
            ),
            child: Text(
              count == 0 ? 'Select products to delete' : 'Delete selected',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.warmWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductsListShimmer extends StatelessWidget {
  const _ProductsListShimmer({required this.viewMode});

  final _VendorProductViewMode viewMode;

  @override
  Widget build(BuildContext context) {
    if (viewMode == _VendorProductViewMode.grid) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, AppSpacing.xxl),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.78,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => const ShimmerLoader(borderRadius: AppRadii.md),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, AppSpacing.xxl),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => const SizedBox(
        height: 76,
        child: ShimmerLoader(borderRadius: AppRadii.md),
      ),
    );
  }
}
