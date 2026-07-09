import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ar_pending_selection_provider.g.dart';

/// Product ids picked in the current AR session (before tapping Done).
@riverpod
class ArPendingSelection extends _$ArPendingSelection {
  @override
  Set<String> build() => {};

  bool contains(String productId) => state.contains(productId);

  void toggle(String productId) {
    if (state.contains(productId)) {
      state = Set<String>.from(state)..remove(productId);
    } else {
      state = Set<String>.from(state)..add(productId);
    }
  }

  void clear() => state = {};
}
