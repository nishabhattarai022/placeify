import 'package:riverpod_annotation/riverpod_annotation.dart';

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
  final all = ref.watch(catalogProductsProvider);
  final filtered =
      all.where((product) => product.categoryId == categoryId).toList();
  if (filtered.isNotEmpty) return filtered;
  return all;
}

@riverpod
Product? productById(Ref ref, String id) {
  return ref.watch(catalogIndexProvider).value?[id];
}

String categoryTitle(String categoryId) {
  return MockProductRepository.categories
      .firstWhere((c) => c.id == categoryId)
      .label;
}
