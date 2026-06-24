import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../cart/data/product_id_codec.dart';
import '../domain/repositories/profile_repository.dart';

/// Serverpod-backed wishlist API (data layer only).
class ServerpodWishlistRepository {
  Future<WishlistPage> listWishlist({PaginationInput? pagination}) async {
    _requireAuthenticated();
    return client.wishlist.listMyWishlist(pagination: pagination);
  }

  Future<bool> toggle(String productId) async {
    _requireAuthenticated();
    final id = _requireDatabaseId(productId);
    return client.wishlist.toggleWishlist(id);
  }

  Future<void> add(String productId) async {
    _requireAuthenticated();
    final id = _requireDatabaseId(productId);
    await client.wishlist.addToWishlist(id);
  }

  Future<void> remove(String productId) async {
    _requireAuthenticated();
    final id = _requireDatabaseId(productId);
    await client.wishlist.removeFromWishlist(id);
  }

  int _requireDatabaseId(String productId) {
    final id = ProductIdCodec.toDatabaseId(
      ProductIdCodec.normalizeUiProductId(productId),
    );
    if (id == null) {
      throw ArgumentError(
        'This product cannot be saved yet. '
        'Use items from the live catalog (Browse), not shop previews.',
      );
    }
    return id;
  }

  void _requireAuthenticated() {
    if (!client.auth.isAuthenticated) {
      throw ProfileException('Sign in to view wishlist');
    }
  }
}
