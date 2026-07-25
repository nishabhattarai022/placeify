import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/product.dart';
import '../chairs_catalog_tokens.dart';
import '../providers/catalog_provider.dart';
import 'chairs_catalog_compact_card.dart';
import 'chairs_catalog_wide_card.dart';

/// Staggered chairs showcase driven by the live catalog (not mock `p*` ids).
class ChairsCatalogGrid extends ConsumerWidget {
  const ChairsCatalogGrid({this.categoryId = 'chairs', super.key});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (categoryId != 'chairs') {
      return const SizedBox.shrink();
    }

    final products = ref.watch(catalogProductsByCategoryProvider(categoryId));
    if (products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Text(
          'No products found.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black.withValues(alpha: 0.45),
          ),
        ),
      );
    }

    Product? at(int index) =>
        index < products.length ? products[index] : null;

    final p0 = at(0);
    final p1 = at(1);
    final p2 = at(2);
    final p3 = at(3);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: ChairsCatalogTokens.leftFlex,
            child: Column(
              children: [
                if (p0 != null)
                  SizedBox(
                    height: ChairsCatalogTokens.wideCardHeightPrimary,
                    child: ChairsCatalogWideCard(product: p0),
                  ),
                const SizedBox(height: ChairsCatalogTokens.columnGap),
                if (p3 != null)
                  SizedBox(
                    height: ChairsCatalogTokens.wideCardHeightSecondary,
                    child: ChairsCatalogWideCard(product: p3),
                  ),
              ],
            ),
          ),
          const SizedBox(width: ChairsCatalogTokens.columnGap),
          Expanded(
            flex: ChairsCatalogTokens.rightFlex,
            child: Column(
              children: [
                if (p1 != null)
                  SizedBox(
                    height: ChairsCatalogTokens.compactCardHeight,
                    child: ChairsCatalogCompactCard(product: p1),
                  ),
                if (p1 != null) const SizedBox(height: ChairsCatalogTokens.columnGap),
                if (p2 != null)
                  SizedBox(
                    height: ChairsCatalogTokens.compactCardHeight,
                    child: ChairsCatalogCompactCard(product: p2),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
