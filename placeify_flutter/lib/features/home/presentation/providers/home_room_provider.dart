import 'package:flutter_riverpod/legacy.dart';
import 'package:placeify_flutter/features/home/presentation/data/home_categories_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'catalog_provider.dart';

part 'home_room_provider.g.dart';

final selectedRoomProvider = StateProvider<String>((ref) => 'living');

@riverpod
List<RecommendProduct> recommendedProducts(Ref ref) {
  final roomId = ref.watch(selectedRoomProvider);
  ref.watch(catalogIndexProvider);
  final catalog = ref.watch(homeRecommendedProductsProvider(roomId));
  if (catalog.isNotEmpty) {
    return [
      for (final product in catalog.take(2))
        HomeCategoriesConfig.fromProduct(
          product,
          id: 'rec-$roomId-${product.id}',
          roomIds: [roomId],
        ),
    ];
  }
  return HomeCategoriesConfig.forRoom(roomId);
}
