import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../cart/data/product_id_codec.dart';
import '../../data/mock_product_repository.dart';
import '../../domain/models/category.dart';
import '../../domain/models/product.dart';
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
  final catalog = ref.watch(catalogIndexProvider).value;
  if (catalog != null && catalog.isNotEmpty) {
    final products = catalog.values
        .where((p) => p.categoryId == categoryId)
        .toList()
      ..sort((a, b) => ProductIdCodec.compareNewestFirst(a.id, b.id));
    return products;
  }
  return MockProductRepository.products
      .where((p) => p.categoryId == categoryId)
      .toList();
}

@riverpod
Product? productById(Ref ref, String id) {
  final catalog = ref.watch(catalogIndexProvider).value;
  if (catalog != null) {
    return catalog[id];
  }
  try {
    return MockProductRepository.products.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
}

String categoryTitle(String categoryId) {
  return MockProductRepository.categories
          .firstWhere((c) => c.id == categoryId)
          .label;
}
