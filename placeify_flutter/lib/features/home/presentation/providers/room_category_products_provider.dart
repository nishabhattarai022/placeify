import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/catalog_category_utils.dart';
import '../../domain/models/product.dart';
import 'catalog_provider.dart';

part 'room_category_products_provider.g.dart';

@riverpod
Future<List<Product>> roomCategoryProducts(Ref ref, String category) async {
  final trimmed = category.trim();
  if (trimmed.isEmpty) return const [];

  await ref.watch(catalogIndexProvider.future);

  final roomId = CatalogCategoryUtils.roomIdForLabel(trimmed);
  if (roomId != null) {
    return ref.watch(roomCatalogProductsProvider(roomId));
  }

  final furnitureCategory = CatalogCategoryUtils.furnitureCategoryForQuery(trimmed);
  if (furnitureCategory != null) {
    return ref.watch(browseCategoryProductsProvider(furnitureCategory.id));
  }

  final normalized = trimmed.toLowerCase();
  if (CatalogCategoryUtils.nishaBrowseCategoryIds.contains(normalized) ||
      normalized == 'lights') {
    final uiId = normalized == 'lights' ? 'lighting' : normalized;
    return ref.watch(browseCategoryProductsProvider(uiId));
  }

  return const [];
}
