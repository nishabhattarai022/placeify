import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wishlist_provider.g.dart';

/// Product id → time saved (newest first when listed).
@riverpod
class Wishlist extends _$Wishlist {
  @override
  Map<String, DateTime> build() => {};

  bool isLiked(String productId) => state.containsKey(productId);

  void toggle(String productId) {
    if (state.containsKey(productId)) {
      state = Map<String, DateTime>.from(state)..remove(productId);
    } else {
      state = Map<String, DateTime>.from(state)
        ..[productId] = DateTime.now();
    }
  }
}
