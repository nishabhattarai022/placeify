import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/catalog_category_labels.dart';
import '../../data/home_room_catalog.dart';
import '../../domain/models/category.dart';
import '../../domain/models/product.dart';
import 'home_room_provider.dart';
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
  final index = ref.watch(catalogIndexProvider).value;
  if (index == null || index.isEmpty) {
    return const [
      ProductCategory(
        id: 'chairs',
        label: 'Chairs',
        svgIconAssetPath: 'assets/icons/ic_chair.svg',
      ),
    ];
  }

  final categoryIds = index.values.map((product) => product.categoryId).toSet()
    ..removeWhere((id) => id.trim().isEmpty);

  final sorted = categoryIds.toList()..sort();
  return [
    for (final id in sorted)
      ProductCategory(
        id: id,
        label: CatalogCategoryLabels.label(id),
        svgIconAssetPath: CatalogCategoryLabels.iconAsset(id),
      ),
  ];
}

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

@riverpod
List<Product> homeFeaturedProducts(Ref ref) {
  final roomId = ref.watch(selectedRoomProvider);
  final all = ref.watch(catalogProductsProvider);
  if (all.isEmpty) return const [];

  final roomCategories = HomeRoomCatalog.categoriesForRoom(roomId);
  final filtered = all
      .where((product) => roomCategories.contains(product.categoryId))
      .toList();

  return (filtered.isNotEmpty ? filtered : all).take(2).toList();
}

String categoryTitle(String categoryId) {
  return CatalogCategoryLabels.label(categoryId);
}
