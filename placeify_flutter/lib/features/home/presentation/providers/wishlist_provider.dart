import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../user/presentation/providers/user_wishlist_provider.dart';

part 'wishlist_provider.g.dart';

/// Product id → time saved. Backed by [userWishlistProvider] for a single
/// source of truth across home hearts, bookmarks, and profile wishlist.
@riverpod
class Wishlist extends _$Wishlist {
  @override
  Map<String, DateTime> build() {
    final entries = ref.watch(userWishlistProvider);
    return entries.maybeWhen(
      data: (list) => {
        for (final entry in list) entry.product.id: entry.savedAt,
      },
      orElse: () => {},
    );
  }

  bool isLiked(String productId) => state.containsKey(productId);

  Future<void> toggle(String productId) async {
    await ref.read(userWishlistProvider.notifier).toggle(productId);
  }
}
