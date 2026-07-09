import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:placeify_flutter/data/furniture_categories.dart';
import 'package:placeify_flutter/features/home/domain/models/product.dart';
import 'package:placeify_flutter/screens/widgets/ar_product_card.dart';

/// My AR listing grouped by furniture category.
class ArProductsByCategorySliver extends StatelessWidget {
  const ArProductsByCategorySliver({
    required this.entries,
    required this.onProductTap,
    this.selectionMode = false,
    this.selectedIds = const {},
    super.key,
  });

  final List<({Product product, DateTime savedAt})> entries;
  final void Function(Product product) onProductTap;
  final bool selectionMode;
  final Set<String> selectedIds;

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<({Product product, DateTime savedAt})>>{};
    for (final entry in entries) {
      grouped.putIfAbsent(entry.product.categoryId, () => []).add(entry);
    }

    final sections = <Widget>[];
    for (final category in furnitureCategories) {
      final items = grouped[category.id];
      if (items == null || items.isEmpty) continue;

      sections.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Text(
              category.name,
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ),
      );

      sections.add(
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.66,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final entry = items[index];
                return ArProductCard(
                  product: entry.product,
                  savedAt: entry.savedAt,
                  selectionMode: selectionMode,
                  isSelected: selectedIds.contains(entry.product.id),
                  onTap: () => onProductTap(entry.product),
                );
              },
              childCount: items.length,
            ),
          ),
        ),
      );
    }

    final knownIds = furnitureCategories.map((c) => c.id).toSet();
    final otherItems = entries
        .where((e) => !knownIds.contains(e.product.categoryId))
        .toList();
    if (otherItems.isNotEmpty) {
      sections.add(
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Text(
              'Other',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      );
      sections.add(
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.66,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final entry = otherItems[index];
                return ArProductCard(
                  product: entry.product,
                  savedAt: entry.savedAt,
                  selectionMode: selectionMode,
                  isSelected: selectedIds.contains(entry.product.id),
                  onTap: () => onProductTap(entry.product),
                );
              },
              childCount: otherItems.length,
            ),
          ),
        ),
      );
    }

    if (sections.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverMainAxisGroup(slivers: [
      ...sections,
      SliverToBoxAdapter(
        child: SizedBox(height: selectionMode ? 160 : 100),
      ),
    ]);
  }
}
