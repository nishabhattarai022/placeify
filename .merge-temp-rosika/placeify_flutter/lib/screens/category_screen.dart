import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_spacing.dart';
import '../core/services/haptic_service.dart';
import '../core/widgets/placeify_bottom_sheet.dart';
import '../data/furniture_categories.dart';
import '../features/cart/data/product_id_codec.dart';
import '../features/home/data/mock_product_repository.dart';
import '../features/home/domain/models/product.dart';
import '../features/home/presentation/providers/catalog_provider.dart';
import 'widgets/category_product_list_tile.dart';

enum _SortOption { featured, priceAsc, priceDesc, nameAsc }

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({required this.category, super.key});

  final FurnitureCategory category;

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  _SortOption _sort = _SortOption.featured;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(catalogIndexProvider.notifier).refresh();
    });
  }

  List<Product> _products(Map<String, Product>? catalog) {
    final list = catalog != null
        ? catalog.values
            .where((p) => p.categoryId == widget.category.id)
            .toList()
        : MockProductRepository.products
            .where((p) => p.categoryId == widget.category.id)
            .toList();

    switch (_sort) {
      case _SortOption.featured:
        return List<Product>.from(list)
          ..sort((a, b) => ProductIdCodec.compareNewestFirst(a.id, b.id));
      case _SortOption.priceAsc:
        return List<Product>.from(list)
          ..sort((a, b) => a.price.compareTo(b.price));
      case _SortOption.priceDesc:
        return List<Product>.from(list)
          ..sort((a, b) => b.price.compareTo(a.price));
      case _SortOption.nameAsc:
        return List<Product>.from(list)
          ..sort((a, b) => a.name.compareTo(b.name));
    }
  }

  void _openSortSheet() {
    HapticService.light();
    PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PlaceifyBottomSheetHeader(
              title: 'Sort by',
              subtitle: 'Choose how items are ordered',
            ),
            const SizedBox(height: AppSpacing.lg),
            PlaceifySelectTile(
              label: 'Featured',
              selected: _sort == _SortOption.featured,
              onTap: () => _applySort(sheetContext, _SortOption.featured),
            ),
            PlaceifySelectTile(
              label: 'Price: Low to High',
              selected: _sort == _SortOption.priceAsc,
              onTap: () => _applySort(sheetContext, _SortOption.priceAsc),
            ),
            PlaceifySelectTile(
              label: 'Price: High to Low',
              selected: _sort == _SortOption.priceDesc,
              onTap: () => _applySort(sheetContext, _SortOption.priceDesc),
            ),
            PlaceifySelectTile(
              label: 'Name: A to Z',
              selected: _sort == _SortOption.nameAsc,
              onTap: () => _applySort(sheetContext, _SortOption.nameAsc),
            ),
          ],
        );
      },
    );
  }

  void _applySort(BuildContext sheetContext, _SortOption option) {
    if (_sort != option) {
      HapticService.selection();
      setState(() => _sort = option);
    }
    Navigator.pop(sheetContext);
  }

  @override
  Widget build(BuildContext context) {
    final catalogAsync = ref.watch(catalogIndexProvider);
    final products = catalogAsync.when(
      data: _products,
      loading: () => _products(null),
      error: (_, __) => _products(null),
    );
    final count = products.length;
    final displayName = categoryDisplayName(widget.category);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F4),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 20,
                            color: Colors.black87,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$displayName ($count)',
                      style: GoogleFonts.dmSans(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: _Breadcrumb(category: widget.category)),
                        GestureDetector(
                          onTap: _openSortSheet,
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Sort by',
                                style: GoogleFonts.dmSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.unfold_more_rounded,
                                size: 18,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            if (products.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyCategoryState(
                  categoryName: displayName,
                  onBrowse: () => context.go('/browse'),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index < products.length - 1 ? 32 : 0,
                        ),
                        child: CategoryProductListTile(product: product),
                      );
                    },
                    childCount: products.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.category});

  final FurnitureCategory category;

  @override
  Widget build(BuildContext context) {
    final segmentStyle = GoogleFonts.dmSans(
      fontSize: 12,
      color: Colors.black38,
    );
    final separatorStyle = GoogleFonts.dmSans(
      fontSize: 12,
      color: Colors.black26,
    );
    final currentStyle = GoogleFonts.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    );

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        GestureDetector(
          onTap: () => context.go('/browse'),
          child: Text('All categories', style: segmentStyle),
        ),
        Text(' / ', style: separatorStyle),
        Text(categoryDisplayName(category), style: currentStyle),
      ],
    );
  }
}

class _EmptyCategoryState extends StatelessWidget {
  const _EmptyCategoryState({
    required this.categoryName,
    required this.onBrowse,
  });

  final String categoryName;
  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No $categoryName listed yet.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              color: Colors.black38,
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: onBrowse,
            child: Text(
              'Browse all categories',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
