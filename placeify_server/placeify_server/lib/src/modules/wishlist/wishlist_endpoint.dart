import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'wishlist_service.dart';

/// Wishlist management for authenticated customers.
class WishlistEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final _service = WishlistService();

  Future<WishlistPage> listMyWishlist(
    Session session, {
    PaginationInput? pagination,
  }) {
    return _service.listMyWishlist(session, pagination: pagination);
  }

  Future<WishlistItem> addToWishlist(Session session, int productId) {
    return _service.addToWishlist(session, productId);
  }

  Future<void> removeFromWishlist(Session session, int productId) {
    return _service.removeFromWishlist(session, productId);
  }

  Future<bool> toggleWishlist(Session session, int productId) {
    return _service.toggleWishlist(session, productId);
  }

  Future<bool> isWishlisted(Session session, int productId) {
    return _service.isWishlisted(session, productId);
  }
}
