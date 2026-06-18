import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/product.dart';
import '../chairs_catalog_tokens.dart';
import '../providers/catalog_provider.dart';
import 'chairs_catalog_compact_card.dart';
import 'chairs_catalog_wide_card.dart';
import 'showcase_showroom_card.dart';

class ChairsCatalogGrid extends ConsumerWidget {
  const ChairsCatalogGrid({this.categoryId = 'chairs', super.key});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (categoryId != 'chairs') {
      return const SizedBox.shrink();
    }

    final productsAsync =
        ref.watch(catalogProductsByCategoryProvider(categoryId));

    return productsAsync.when(
      loading: () => const SizedBox(
        height: 320,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (products) => _ChairsLayout(products: products),
    );
  }
}

class _ChairsLayout extends StatelessWidget {
  const _ChairsLayout({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    final p1 = _at(products, 0);
    final p5 = _at(products, 1);
    final p6 = _at(products, 2);
    final p3 = _at(products, 3);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: ChairsCatalogTokens.leftFlex,
            child: Column(
              children: [
                if (p1 != null)
                  SizedBox(
                    height: ChairsCatalogTokens.wideCardHeightPrimary,
                    child: ChairsCatalogWideCard(product: p1),
                  ),
                if (p1 != null && p3 != null)
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
                if (p5 != null)
                  SizedBox(
                    height: ChairsCatalogTokens.compactCardHeight,
                    child: ChairsCatalogCompactCard(product: p5),
                  ),
                if (p5 != null)
                  const SizedBox(height: ChairsCatalogTokens.columnGap),
                const ShowcaseShowroomCard(),
                if (p6 != null) ...[
                  const SizedBox(height: ChairsCatalogTokens.columnGap),
                  SizedBox(
                    height: ChairsCatalogTokens.compactCardHeight,
                    child: ChairsCatalogCompactCard(product: p6),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Product? _at(List<Product> products, int index) {
    if (index < 0 || index >= products.length) return null;
    return products[index];
  }
}
