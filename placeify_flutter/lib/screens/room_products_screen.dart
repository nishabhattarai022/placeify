import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_spacing.dart';
import '../core/services/haptic_service.dart';
import '../core/widgets/placeify_bottom_sheet.dart';
import '../features/home/domain/models/product.dart';
import '../features/home/presentation/providers/room_category_products_provider.dart';
import 'widgets/category_product_list_tile.dart';

enum _SortOption { featured, priceAsc, priceDesc, nameAsc }

/// Product listing for a home room category (e.g. Living Room).
class RoomProductsScreen extends ConsumerStatefulWidget {
  const RoomProductsScreen({required this.category, super.key});

  final String category;

  @override
  ConsumerState<RoomProductsScreen> createState() => _RoomProductsScreenState();
}

class _RoomProductsScreenState extends ConsumerState<RoomProductsScreen> {
  _SortOption _sort = _SortOption.featured;

  List<Product> _sortedProducts(List<Product> list) {
    switch (_sort) {
      case _SortOption.featured:
        return list;
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
    final productsAsync = ref.watch(
      roomCategoryProductsProvider(widget.category),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F4),
      body: SafeArea(
        child: productsAsync.when(
          loading: () => _RoomProductsScaffold(
            category: widget.category,
            onBack: () => context.pop(),
            onSort: _openSortSheet,
            titleCount: null,
            body: const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 48),
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          ),
          error: (_, __) => _RoomProductsScaffold(
            category: widget.category,
            onBack: () => context.pop(),
            onSort: _openSortSheet,
            titleCount: 0,
            body: _EmptyRoomCategoryState(
              categoryName: widget.category,
              onBrowse: () => context.go('/browse'),
            ),
          ),
          data: (List<Product> rawProducts) {
            final products = _sortedProducts(rawProducts);
            return _RoomProductsScaffold(
              category: widget.category,
              onBack: () => context.pop(),
              onSort: _openSortSheet,
              titleCount: products.length,
              body: products.isEmpty
                  ? _EmptyRoomCategoryState(
                      categoryName: widget.category,
                      onBrowse: () => context.go('/browse'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      physics: const BouncingScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < products.length - 1 ? 32 : 0,
                          ),
                          child: CategoryProductListTile(product: product),
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}

class _RoomProductsScaffold extends StatelessWidget {
  const _RoomProductsScaffold({
    required this.category,
    required this.onBack,
    required this.onSort,
    required this.titleCount,
    required this.body,
  });

  final String category;
  final VoidCallback onBack;
  final VoidCallback onSort;
  final int? titleCount;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final countSuffix = titleCount == null ? '' : ' ($titleCount)';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: onBack,
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
                '$category$countSuffix',
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
                  Expanded(
                    child: _RoomBreadcrumb(category: category),
                  ),
                  GestureDetector(
                    onTap: onSort,
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
        Expanded(child: body),
      ],
    );
  }
}

class _RoomBreadcrumb extends StatelessWidget {
  const _RoomBreadcrumb({required this.category});

  final String category;

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
          onTap: () => context.go('/home'),
          child: Text('Home', style: segmentStyle),
        ),
        Text(' / ', style: separatorStyle),
        Text(category, style: currentStyle),
      ],
    );
  }
}

class _EmptyRoomCategoryState extends StatelessWidget {
  const _EmptyRoomCategoryState({
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
            'No products found.',
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
