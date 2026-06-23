import 'package:placeify_client/placeify_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/config/placeify_server_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/data/serverpod_wishlist_repository.dart';
import '../../data/user_wishlist_mappers.dart';

part 'user_wishlist_provider.g.dart';

@Riverpod(keepAlive: true)
ServerpodWishlistRepository userWishlistRepository(Ref ref) {
  return ServerpodWishlistRepository();
}

@Riverpod(keepAlive: true)
class UserWishlist extends _$UserWishlist {
  @override
  Future<List<UserWishlistEntry>> build() async {
    if (!client.auth.isAuthenticated) return [];

    ref.listen(currentUserProvider, (previous, next) {
      if (!client.auth.isAuthenticated) {
        state = const AsyncData([]);
        return;
      }
      if (next.hasValue && previous?.value?.id != next.value?.id) {
        ref.invalidateSelf();
      }
    });

    return _loadEntries();
  }

  Future<List<UserWishlistEntry>> _loadEntries() async {
    final repo = ref.read(userWishlistRepositoryProvider);
    final page = await repo.listWishlist(
      pagination: PaginationInput(page: 1, pageSize: 100),
    );
    return UserWishlistMappers.fromApiItems(page.items);
  }

  Future<void> refresh() async {
    if (!client.auth.isAuthenticated) {
      state = const AsyncData([]);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadEntries);
  }

  Future<void> remove(String productId) async {
    final repo = ref.read(userWishlistRepositoryProvider);
    await repo.toggle(productId);
    ref.invalidateSelf();
  }
}
