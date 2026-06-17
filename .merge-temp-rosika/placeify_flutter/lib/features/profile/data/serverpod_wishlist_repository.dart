import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../cart/data/product_id_codec.dart';
import '../domain/repositories/profile_repository.dart';

/// Serverpod-backed wishlist API (data layer only).
class ServerpodWishlistRepository {
  Future<WishlistPage> listWishlist({PaginationInput? pagination}) async {
    if (!client.auth.isAuthenticated) {
      throw ProfileException('Sign in to view wishlist');
    }
    return client.wishlist.listMyWishlist(pagination: pagination);
  }

  Future<bool> toggle(String productId) async {
    if (!client.auth.isAuthenticated) return false;
    final id = ProductIdCodec.toDatabaseId(productId);
    if (id == null) return false;
    return client.wishlist.toggleWishlist(id);
  }
}
