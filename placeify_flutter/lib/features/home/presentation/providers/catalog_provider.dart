import 'package:placeify_client/placeify_client.dart' hide Product;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../cart/data/product_id_codec.dart';
import '../../data/catalog_product_mapper.dart';
import '../../data/serverpod_product_repository.dart';
import '../../domain/models/product.dart';

part 'catalog_provider.g.dart';

@Riverpod(keepAlive: true)
ServerpodProductRepository catalogRepository(Ref ref) {
  return ServerpodProductRepository();
}

/// All active marketplace products (seed + vendor listings).
@Riverpod(keepAlive: true)
class CatalogIndex extends _$CatalogIndex {
  @override
  Future<Map<String, Product>> build() async {
    return _loadIndex();
  }

  Future<Map<String, Product>> _loadIndex() async {
    final repo = ref.read(catalogRepositoryProvider);
    final page = await repo.search(
      pagination: PaginationInput(page: 1, pageSize: 200),
    );

    final index = <String, Product>{};
    for (final item in page.items) {
      final ui = await CatalogProductMapper.toUiProduct(item);
      index[ui.id] = ui;
    }
    return index;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadIndex);
  }

  /// Fetches any catalog products missing from the in-memory index (e.g. cart lines).
  Future<void> ensureProducts(Iterable<String> productIds) async {
    final current = state.value ?? {};
    final missing = productIds
        .where((id) => id.trim().isNotEmpty && current[id] == null)
        .toSet();
    if (missing.isEmpty) return;

    final repo = ref.read(catalogRepositoryProvider);
    final additions = <String, Product>{};

    for (final id in missing) {
      final apiProduct = await repo.getByUiId(id);
      if (apiProduct == null) continue;
      final ui = await CatalogProductMapper.toUiProduct(apiProduct);
      additions[ui.id] = ui;
    }

    if (additions.isEmpty) return;
    state = AsyncData({...current, ...additions});
  }
}

@riverpod
List<Product> catalogProducts(Ref ref) {
  final index = ref.watch(catalogIndexProvider).value;
  if (index == null) return const [];
  final products = index.values.toList()
    ..sort((a, b) => ProductIdCodec.compareNewestFirst(a.id, b.id));
  return products;
}

@riverpod
Future<List<Product>> catalogProductsByCategory(
  Ref ref,
  String categoryId,
) async {
  final repo = ref.read(catalogRepositoryProvider);
  final page = await repo.search(
    categoryName: categoryId,
    pagination: PaginationInput(page: 1, pageSize: 200),
  );

  return [
    for (final item in page.items)
      await CatalogProductMapper.toUiProduct(item),
  ];
}

@riverpod
Future<Product?> productDetail(Ref ref, String id) async {
  final cached = ref.watch(catalogIndexProvider).value?[id];
  if (cached != null) return cached;

  final apiProduct =
      await ref.read(catalogRepositoryProvider).getByUiId(id);
  if (apiProduct == null) return null;

  return CatalogProductMapper.toUiProduct(apiProduct);
}
