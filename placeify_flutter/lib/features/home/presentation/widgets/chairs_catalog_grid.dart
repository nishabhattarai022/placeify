import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/catalog_category_utils.dart';
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
    final catalogAsync = ref.watch(catalogIndexProvider);

    return catalogAsync.when(
      loading: () => const SizedBox(
        height: 420,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (_) {
        final products = ref.watch(catalogProductsProvider).where((product) {
          return CatalogCategoryUtils.matchesUiCategory(
            product.categoryId,
            categoryId,
          );
        }).toList();

        return _CatalogGridBody(
          categoryId: categoryId,
          products: products,
        );
      },
    );
  }
}

class _CatalogGridBody extends StatelessWidget {
  const _CatalogGridBody({
    required this.categoryId,
    required this.products,
  });

  final String categoryId;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    if (categoryId != 'chairs') {
      return _SimpleProductGrid(products: products);
    }

    final p1 = products.isNotEmpty ? products[0] : null;
    final p5 = products.length > 1 ? products[1] : null;
    final p6 = products.length > 2 ? products[2] : null;
    final p3 = products.length > 3 ? products[3] : null;

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
                const SizedBox(height: ChairsCatalogTokens.columnGap),
                const ShowcaseShowroomCard(),
                const SizedBox(height: ChairsCatalogTokens.columnGap),
                if (p6 != null)
                  SizedBox(
                    height: ChairsCatalogTokens.compactCardHeight,
                    child: ChairsCatalogCompactCard(product: p6),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleProductGrid extends StatelessWidget {
  const _SimpleProductGrid({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < products.length; i++) ...[
          if (i > 0) const SizedBox(height: ChairsCatalogTokens.columnGap),
          ChairsCatalogWideCard(product: products[i]),
        ],
      ],
    );
  }
}
