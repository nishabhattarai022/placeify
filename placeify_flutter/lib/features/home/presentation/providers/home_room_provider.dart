import 'package:flutter_riverpod/legacy.dart';
import 'package:placeify_flutter/features/home/presentation/data/home_categories_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'catalog_provider.dart';

part 'home_room_provider.g.dart';

final selectedRoomProvider = StateProvider<String>((ref) => 'living');

@riverpod
List<RecommendProduct> recommendedProducts(Ref ref) {
  final roomId = ref.watch(selectedRoomProvider);
  final products = ref.watch(catalogProductsProvider);
  if (products.isEmpty) return const [];

  final preferredCategories = HomeCategoriesConfig.catalogCategoriesForRoom(
    roomId,
  );

  final matched = products
      .where((product) => preferredCategories.contains(product.categoryId))
      .take(2)
      .toList();

  if (matched.length < 2) {
    final extras = products
        .where((product) => !matched.contains(product))
        .take(2 - matched.length);
    matched.addAll(extras);
  }

  return [
    for (final product in matched)
      HomeCategoriesConfig.fromProduct(
        product,
        id: 'rec-${product.id}-$roomId',
        roomIds: [roomId],
      ),
  ];
}
