import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ar_saved_products_provider.g.dart';

/// Product id → time saved (newest first when listed).
@Riverpod(keepAlive: true)
class ArSavedProducts extends _$ArSavedProducts {
  @override
  Map<String, DateTime> build() => {};

  bool isSaved(String productId) => state.containsKey(productId);

  void toggle(String productId) {
    if (state.containsKey(productId)) {
      state = Map<String, DateTime>.from(state)..remove(productId);
    } else {
      state = Map<String, DateTime>.from(state)
        ..[productId] = DateTime.now();
    }
  }

  void addAll(Iterable<String> productIds) {
    if (productIds.isEmpty) return;
    final now = DateTime.now();
    final next = Map<String, DateTime>.from(state);
    for (final id in productIds) {
      next[id] = now;
    }
    state = next;
  }
}
