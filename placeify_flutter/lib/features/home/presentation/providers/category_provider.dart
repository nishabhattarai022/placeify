import 'package:placeify_flutter/data/furniture_categories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../cart/data/product_id_codec.dart';
import '../../data/catalog_category_utils.dart';
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
      ),
  ];
}

@riverpod
List<Product> filteredProducts(Ref ref) {
  final categoryId = ref.watch(selectedCategoryProvider);
  final index = ref.watch(catalogIndexProvider).value;
  if (index == null) return const [];

  final products = index.values
      .where((product) => CatalogCategoryUtils.matchesUiCategory(
            product.categoryId,
            categoryId,
          ))
      .toList()
    ..sort((a, b) => ProductIdCodec.compareNewestFirst(a.id, b.id));

  return products;
}

@riverpod
Product? productById(Ref ref, String id) {
  ref.watch(catalogIndexProvider);
  return ref.watch(catalogIndexProvider).value?[id];
}

String categoryTitle(String categoryId) {
  return furnitureCategoryById(categoryId)?.name ?? categoryId;
}
