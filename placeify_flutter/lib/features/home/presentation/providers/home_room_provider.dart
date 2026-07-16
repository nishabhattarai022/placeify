import 'package:flutter_riverpod/legacy.dart';
import 'package:placeify_flutter/features/home/data/marketplace_highlights_mapper.dart';
import 'package:placeify_flutter/features/home/presentation/data/home_categories_config.dart';
import 'package:placeify_flutter/features/home/presentation/providers/catalog_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_room_provider.g.dart';

final selectedRoomProvider = StateProvider<String>((ref) => 'living');

@riverpod
Future<List<RecommendProduct>> recommendedProducts(Ref ref) async {
  final roomId = ref.watch(selectedRoomProvider);
  final highlights = await ref.watch(marketplaceHighlightsProvider.future);

  final roomMatches = await MarketplaceHighlightsMapper.toRecommendProducts(
    highlights.recentProducts,
    roomId: roomId,
  );
  if (roomMatches.isNotEmpty) return roomMatches;

  final general = await MarketplaceHighlightsMapper.toRecommendProducts(
    highlights.recentProducts,
  );
  if (general.isNotEmpty) return general;

  // Never fabricate recommend cards — empty section until live catalog exists.
  return const [];
}
