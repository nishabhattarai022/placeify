import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'wishlist_repository.dart';

class WishlistService {
  WishlistService({WishlistStore? repository})
    : _repository = repository ?? WishlistStore();

  final WishlistStore _repository;

  Future<WishlistPage> listMyWishlist(
    Session session, {
    PaginationInput? pagination,
  }) {
    return _repository.listItems(session, pagination: pagination);
  }

  Future<WishlistItem> addToWishlist(Session session, int productId) {
    return _repository.addItem(session, productId);
  }

  Future<void> removeFromWishlist(Session session, int productId) {
    return _repository.removeItem(session, productId);
  }

  Future<bool> toggleWishlist(Session session, int productId) {
    return _repository.toggleItem(session, productId);
  }

  Future<bool> isWishlisted(Session session, int productId) {
    return _repository.isWishlisted(session, productId);
  }
}
