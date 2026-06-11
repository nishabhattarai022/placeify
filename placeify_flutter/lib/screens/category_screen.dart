import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/furniture_categories.dart';
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

  List<Product> _sorted(List<Product> list) {
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
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sort by',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _SortTile(
                  label: 'Featured',
                  selected: _sort == _SortOption.featured,
                  onTap: () => _applySort(_SortOption.featured),
                ),
                _SortTile(
                  label: 'Price: Low to High',
                  selected: _sort == _SortOption.priceAsc,
                  onTap: () => _applySort(_SortOption.priceAsc),
                ),
                _SortTile(
                  label: 'Price: High to Low',
                  selected: _sort == _SortOption.priceDesc,
                  onTap: () => _applySort(_SortOption.priceDesc),
                ),
                _SortTile(
                  label: 'Name: A to Z',
                  selected: _sort == _SortOption.nameAsc,
                  onTap: () => _applySort(_SortOption.nameAsc),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _applySort(_SortOption option) {
    Navigator.pop(context);
    setState(() => _sort = option);
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync =
        ref.watch(catalogProductsByCategoryProvider(widget.category.id));
    final displayName = categoryDisplayName(widget.category);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F4),
      body: SafeArea(
        child: productsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _CategoryScaffold(
            displayName: displayName,
            category: widget.category,
            child: Center(
              child: Text(
                'Could not load products',
                style: GoogleFonts.dmSans(color: Colors.black38),
              ),
            ),
          ),
          data: (List<Product> products) {
            final sorted = _sorted(products);
            final count = sorted.length;

            return _CategoryScaffold(
              displayName: '$displayName ($count)',
              category: widget.category,
              onSortTap: _openSortSheet,
              child: sorted.isEmpty
                  ? _EmptyCategoryState(
                      categoryName: displayName,
                      onBrowse: () => context.go('/browse'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      physics: const BouncingScrollPhysics(),
                      itemCount: sorted.length,
                      itemBuilder: (context, index) {
                        final product = sorted[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < sorted.length - 1 ? 32 : 0,
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

class _CategoryScaffold extends StatelessWidget {
  const _CategoryScaffold({
    required this.displayName,
    required this.category,
    required this.child,
    this.onSortTap,
  });

  final String displayName;
  final FurnitureCategory category;
  final Widget child;
  final VoidCallback? onSortTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
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
                displayName,
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
                  Expanded(child: _Breadcrumb(category: category)),
                  if (onSortTap != null)
                    GestureDetector(
                      onTap: onSortTap,
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
        Expanded(child: child),
      ],
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

class _SortTile extends StatelessWidget {
  const _SortTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: Colors.black87,
        ),
      ),
      trailing: selected
          ? const Icon(Icons.check_rounded, size: 20, color: Colors.black87)
          : null,
      onTap: onTap,
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
