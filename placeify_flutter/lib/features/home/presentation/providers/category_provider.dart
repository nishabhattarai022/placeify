import 'package:placeify_flutter/data/furniture_categories.dart';
import 'package:placeify_flutter/features/shops/data/mock_consumer_shop_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
List<ProductCategory> categories(Ref ref) {
  ref.watch(catalogIndexProvider);
  return [
    for (final category in furnitureCategories)
      ProductCategory(
        id: category.id,
        label: category.name,
        svgIconAssetPath: category.svgIconAssetPath,
        isActive: category.id == 'chairs',
      ),
  ];
}

@riverpod
List<Product> filteredProducts(Ref ref) {
  final categoryId = ref.watch(selectedCategoryProvider);
  ref.watch(catalogIndexProvider);
  return ref.watch(browseCategoryProductsProvider(categoryId));
}

@riverpod
Product? productById(Ref ref, String id) {
  final fromCatalog = ref.watch(catalogIndexProvider).value?[id];
  if (fromCatalog != null) return fromCatalog;

  return MockConsumerShopRepository.productByIdSync(id);
}

String categoryTitle(String categoryId) {
  final category = furnitureCategoryById(categoryId);
  if (category != null) return category.name;
  return categoryId;
}
