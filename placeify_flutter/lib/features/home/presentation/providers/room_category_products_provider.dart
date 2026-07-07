import 'package:placeify_client/placeify_client.dart' hide Product;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/catalog_product_mapper.dart';
import '../../domain/models/product.dart';
import 'catalog_provider.dart';

part 'room_category_products_provider.g.dart';

@riverpod
Future<List<Product>> roomCategoryProducts(Ref ref, String category) async {
  final trimmed = category.trim();
  if (trimmed.isEmpty) return const [];

  final repo = ref.watch(catalogRepositoryProvider);
  final page = await repo.search(
    categoryName: trimmed,
    pagination: PaginationInput(page: 1, pageSize: 100),
  );

  final products = <Product>[];
  for (final item in page.items) {
    products.add(await CatalogProductMapper.toUiProduct(item));
  }
  return products;
}
