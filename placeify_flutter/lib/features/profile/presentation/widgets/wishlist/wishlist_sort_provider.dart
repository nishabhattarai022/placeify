import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/providers/shared_preferences_provider.dart';
import 'wishlist_sort.dart';

part 'wishlist_sort_provider.g.dart';

const _prefsKey = 'wishlist_sort';

@Riverpod(keepAlive: true)
class WishlistSortNotifier extends _$WishlistSortNotifier {
  @override
  WishlistSort build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return _parseStored(prefs.getString(_prefsKey));
  }

  void select(WishlistSort sort) {
    state = sort;
    ref.read(sharedPreferencesProvider).setString(_prefsKey, sort.name);
  }

  WishlistSort _parseStored(String? stored) {
    if (stored == null) return WishlistSort.newestFirst;
    for (final option in WishlistSort.values) {
      if (option.name == stored) return option;
    }
    return WishlistSort.newestFirst;
  }
}
