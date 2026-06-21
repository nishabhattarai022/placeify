import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/product.dart';
import '../providers/catalog_provider.dart';
import '../chairs_catalog_tokens.dart';
import 'chairs_catalog_compact_card.dart';
import 'chairs_catalog_wide_card.dart';
import 'showcase_showroom_card.dart';

class ChairsCatalogGrid extends ConsumerWidget {
  const ChairsCatalogGrid({this.categoryId = 'chairs', super.key});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(catalogIndexProvider);
    final products = ref.watch(catalogProductsByCategoryProvider(categoryId));

    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return _CatalogLayout(products: products);
  }
}

class _CatalogLayout extends StatelessWidget {
  const _CatalogLayout({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final slots = products.take(4).toList();
    final p1 = slots.isNotEmpty ? slots[0] : null;
    final p5 = slots.length > 1 ? slots[1] : null;
    final p6 = slots.length > 2 ? slots[2] : null;
    final p3 = slots.length > 3 ? slots[3] : null;

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
