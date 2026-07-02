import 'package:flutter_riverpod/legacy.dart';
import 'package:placeify_flutter/features/home/presentation/data/home_categories_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'room_category_products_provider.dart';

part 'home_room_provider.g.dart';

final selectedRoomProvider = StateProvider<String>((ref) => 'living');

@riverpod
Future<List<RecommendProduct>> recommendedProducts(Ref ref) async {
  final roomId = ref.watch(selectedRoomProvider);
  final category = HomeCategoriesConfig.apiCategoryForRoom(roomId);
  final products = await ref.watch(roomCategoryProductsProvider(category).future);

  return [
    for (final product in products.take(2))
      HomeCategoriesConfig.fromProduct(
        product,
        id: 'rec-$roomId-${product.id}',
        roomIds: [roomId],
      ),
  ];
}
