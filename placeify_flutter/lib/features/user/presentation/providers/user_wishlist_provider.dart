import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../profile/data/serverpod_wishlist_repository.dart';

part 'user_wishlist_provider.g.dart';

@Riverpod(keepAlive: true)
ServerpodWishlistRepository userWishlistRepository(Ref ref) {
  return ServerpodWishlistRepository();
}
