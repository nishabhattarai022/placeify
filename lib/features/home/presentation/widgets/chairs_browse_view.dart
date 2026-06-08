import 'package:flutter/material.dart';

import 'chairs_catalog_grid.dart';
import 'chairs_catalog_header.dart';

/// Category catalog body with configurable title and masonry grid.
class CategoryCatalogView extends StatelessWidget {
  const CategoryCatalogView({
    required this.title,
    required this.subtitle,
    required this.categoryId,
    super.key,
  });

  final String title;
  final String subtitle;
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChairsCatalogHeader(
          title: title,
          subtitle: subtitle,
        ),
        ChairsCatalogGrid(categoryId: categoryId),
      ],
    );
  }
}

/// Backward-compatible alias for chairs-only usage.
class ChairsBrowseView extends StatelessWidget {
  const ChairsBrowseView({super.key});

  static const _chairsSubtitle =
      'Repurposed Materials, Unique Style,\nSustainable Comfort.';

  @override
  Widget build(BuildContext context) {
    return const CategoryCatalogView(
      title: 'CHAIRS',
      subtitle: _chairsSubtitle,
      categoryId: 'chairs',
    );
  }
}

/// Re-export for generic category screens that reuse the header pattern.
typedef ChairsBrowseHeader = ChairsCatalogHeader;
