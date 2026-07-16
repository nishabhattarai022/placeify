import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/domain/models/product.dart';
import '../../home/presentation/providers/catalog_provider.dart';
import '../../home/presentation/providers/category_provider.dart';
import 'product_id_codec.dart';

/// Resolves live catalog products for cart add, totals, and checkout.
abstract final class CartProductResolver {
  static Set<String> _lookupIds(String productId) {
    final raw = productId.trim();
    if (raw.isEmpty) return const {};

    final normalized = ProductIdCodec.normalizeUiProductId(raw);
    return {
      raw,
      normalized,
      if (normalized != raw) normalized,
    };
  }

  /// Fast lookup for providers that already warmed the catalog.
  static Product? resolveSync(Ref ref, String productId) {
    for (final id in _lookupIds(productId)) {
      final product = ref.read(productByIdProvider(id));
      if (product != null) return product;
    }

    final catalog = ref.read(catalogIndexProvider).value;
    if (catalog != null) {
      for (final id in _lookupIds(productId)) {
        final product = catalog[id];
        if (product != null) return product;
      }
    }

    return null;
  }

  /// Ensures the product exists in memory before cart mutations.
  static Future<Product?> resolve(Ref ref, String productId) async {
    final ids = _lookupIds(productId);
    if (ids.isEmpty) return null;

    await ref.read(catalogIndexProvider.notifier).ensureProducts(ids);

    final cached = resolveSync(ref, productId);
    if (cached != null) return cached;

    final normalized = ProductIdCodec.normalizeUiProductId(productId);
    return ref.read(productDetailProvider(normalized).future);
  }
}
