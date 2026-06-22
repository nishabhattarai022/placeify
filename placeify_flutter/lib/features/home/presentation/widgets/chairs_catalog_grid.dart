import 'package:flutter/material.dart';

import '../../data/mock_product_repository.dart';
import '../../domain/models/product.dart';
import '../chairs_catalog_tokens.dart';
import '../data/category_showcase_config.dart';
import 'chairs_catalog_compact_card.dart';
import 'chairs_catalog_wide_card.dart';
import 'showcase_showroom_card.dart';

class ChairsCatalogGrid extends StatelessWidget {
  const ChairsCatalogGrid({this.categoryId = 'chairs', super.key});

  final String categoryId;

  Product? _product(String id) {
    try {
      return MockProductRepository.products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (categoryId != 'chairs') {
      return const SizedBox.shrink();
    }

    final ids = CategoryShowcaseConfig.chairProductIds();
    final p1 = ids.isNotEmpty ? _product(ids[0]) : null;
    final p5 = ids.length > 1 ? _product(ids[1]) : null;
    final p6 = ids.length > 2 ? _product(ids[2]) : null;
    final p3 = ids.length > 3 ? _product(ids[3]) : null;

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
