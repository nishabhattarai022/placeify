import 'package:flutter_riverpod/legacy.dart';
import 'package:placeify_flutter/features/home/data/marketplace_highlights_mapper.dart';
import 'package:placeify_flutter/features/home/presentation/data/home_categories_config.dart';
import 'package:placeify_flutter/features/home/presentation/providers/catalog_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_room_provider.g.dart';

final selectedRoomProvider = StateProvider<String>((ref) => 'living');

@riverpod
Future<List<RecommendProduct>> recommendedProducts(Ref ref) async {
  ref.watch(catalogIndexProvider);
  final roomId = ref.watch(selectedRoomProvider);
  final products = ref.watch(catalogProductsProvider);
  if (products.isEmpty) return const [];

  final roomMatches = products
      .where((product) => MarketplaceHighlightsMapper.matchesRoom(
            product.categoryId,
            roomId,
          ))
      .take(4)
      .toList();

  if (roomMatches.length >= 4) {
    return MarketplaceHighlightsMapper.recommendFromUiProducts(
      roomMatches,
      roomId: roomId,
    );
  }

  final seen = roomMatches.map((product) => product.id).toSet();
  final filler = products
      .where((product) => !seen.contains(product.id))
      .take(4 - roomMatches.length);
  final combined = [...roomMatches, ...filler];

  return MarketplaceHighlightsMapper.recommendFromUiProducts(
    combined,
    roomId: roomId,
  );
}
