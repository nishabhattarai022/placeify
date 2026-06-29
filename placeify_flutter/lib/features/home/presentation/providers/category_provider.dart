import 'package:placeify_flutter/features/shops/data/mock_consumer_shop_repository.dart';
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
List<ProductCategory> categories(Ref ref) => MockProductRepository.categories;

@riverpod
List<Product> filteredProducts(Ref ref) {
  final categoryId = ref.watch(selectedCategoryProvider);
  return MockProductRepository.products
      .where((p) => p.categoryId == categoryId)
      .toList();
}

@riverpod
Product? productById(Ref ref, String id) {
  final fromCatalog = ref.watch(catalogIndexProvider).value?[id];
  if (fromCatalog != null) return fromCatalog;

  final product = MockProductRepository.resolveProductById(id);
  if (product != null) return product;

  return MockConsumerShopRepository.productByIdSync(id);
}

String categoryTitle(String categoryId) {
  return MockProductRepository.categories
      .firstWhere((c) => c.id == categoryId)
      .label;
}
