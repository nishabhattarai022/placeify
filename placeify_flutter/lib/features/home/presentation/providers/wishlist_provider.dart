import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wishlist_provider.g.dart';

/// Product id → time saved (newest first when listed).
@riverpod
class Wishlist extends _$Wishlist {
  @override
  Map<String, DateTime> build() {
    final now = DateTime.now();
    return {
      'p6': now.subtract(const Duration(minutes: 12)),
      'p4': now.subtract(const Duration(hours: 2)),
      'p2': now.subtract(const Duration(hours: 5)),
      'p5': now.subtract(const Duration(days: 1)),
      'p1': now.subtract(const Duration(days: 2)),
      'p3': now.subtract(const Duration(days: 3)),
    };
  }

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
