import 'package:flutter_riverpod/legacy.dart';
import 'package:placeify_flutter/features/home/presentation/data/home_categories_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_room_provider.g.dart';

final selectedRoomProvider = StateProvider<String>((ref) => 'living');

@riverpod
List<RecommendProduct> recommendedProducts(Ref ref) {
  final roomId = ref.watch(selectedRoomProvider);
  return HomeCategoriesConfig.forRoom(roomId);
}
