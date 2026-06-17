import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../cart/data/product_id_codec.dart';
import '../../data/mock_product_repository.dart';
import '../../domain/models/category.dart';
import '../../domain/models/product.dart';
import '../../../shops/data/mock_consumer_shop_repository.dart';
import 'catalog_provider.dart';

part 'category_provider.g.dart';

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String build() => 'chairs';

  void select(String categoryId) => state = categoryId;
}

@riverpod
List<ProductCategory> categories(Ref ref) =>
    MockProductRepository.categories;

@riverpod
List<Product> filteredProducts(Ref ref) {
  final categoryId = ref.watch(selectedCategoryProvider);
  final catalogAsync = ref.watch(catalogIndexProvider);

  return catalogAsync.when(
    data: (catalog) {
      return catalog.values
          .where((p) => p.categoryId == categoryId)
          .toList()
        ..sort((a, b) => ProductIdCodec.compareNewestFirst(a.id, b.id));
    },
    loading: () => const [],
    error: (_, __) => MockProductRepository.products
        .where((p) => p.categoryId == categoryId)
        .toList(),
  );
}

@riverpod
Product? productById(Ref ref, String id) {
  final catalogAsync = ref.watch(catalogIndexProvider);

  return catalogAsync.when(
    data: (catalog) =>
        catalog[id] ?? MockConsumerShopRepository.productByIdSync(id),
    loading: () => MockConsumerShopRepository.productByIdSync(id),
    error: (_, __) {
      try {
        return MockProductRepository.products.firstWhere((p) => p.id == id);
      } catch (_) {
        return MockConsumerShopRepository.productByIdSync(id);
      }
    },
  );
}

String categoryTitle(String categoryId) {
  return MockProductRepository.categories
          .firstWhere((c) => c.id == categoryId)
          .label;
}
