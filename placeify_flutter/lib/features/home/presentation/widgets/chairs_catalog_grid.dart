import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../chairs_catalog_tokens.dart';
import '../providers/catalog_provider.dart';
import 'chairs_catalog_compact_card.dart';
import 'chairs_catalog_wide_card.dart';
import 'showcase_showroom_card.dart';

/// Staggered product grid for category showcase — live catalog data only.
class ChairsCatalogGrid extends ConsumerWidget {
  const ChairsCatalogGrid({this.categoryId = 'chairs', super.key});

  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogAsync = ref.watch(catalogIndexProvider);

    return catalogAsync.when(
      loading: () => const SizedBox(
        height: 320,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (_) {
        final products = ref.watch(browseCategoryProductsProvider(categoryId));
        if (products.isEmpty) return const SizedBox.shrink();

        final widePrimary = products.isNotEmpty ? products[0] : null;
        final wideSecondary = products.length > 3 ? products[3] : null;
        final compactTop = products.length > 1 ? products[1] : null;
        final compactBottom = products.length > 2 ? products[2] : null;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: ChairsCatalogTokens.leftFlex,
                child: Column(
                  children: [
                    if (widePrimary != null)
                      SizedBox(
                        height: ChairsCatalogTokens.wideCardHeightPrimary,
                        child: ChairsCatalogWideCard(
                          key: ValueKey(widePrimary.id),
                          product: widePrimary,
                        ),
                      ),
                    if (widePrimary != null && wideSecondary != null)
                      const SizedBox(height: ChairsCatalogTokens.columnGap),
                    if (wideSecondary != null)
                      SizedBox(
                        height: ChairsCatalogTokens.wideCardHeightSecondary,
                        child: ChairsCatalogWideCard(
                          key: ValueKey(wideSecondary.id),
                          product: wideSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: ChairsCatalogTokens.columnGap),
              Expanded(
                flex: ChairsCatalogTokens.rightFlex,
                child: Column(
                  children: [
                    if (compactTop != null)
                      SizedBox(
                        height: ChairsCatalogTokens.compactCardHeight,
                        child: ChairsCatalogCompactCard(
                          key: ValueKey(compactTop.id),
                          product: compactTop,
                        ),
                      ),
                    if (compactTop != null) ...[
                      const SizedBox(height: ChairsCatalogTokens.columnGap),
                      const ShowcaseShowroomCard(),
                      const SizedBox(height: ChairsCatalogTokens.columnGap),
                    ],
                    if (compactBottom != null)
                      SizedBox(
                        height: ChairsCatalogTokens.compactCardHeight,
                        child: ChairsCatalogCompactCard(
                          key: ValueKey(compactBottom.id),
                          product: compactBottom,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
