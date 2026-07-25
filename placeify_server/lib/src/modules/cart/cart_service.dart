import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'cart_repository.dart';

class CartService {
  CartService({CartStore? repository})
    : _repository = repository ?? CartStore();

  final CartStore _repository;

  Future<List<CartItem>> getCartItems(Session session) {
    return _repository.listItems(session);
  }

  Future<CartItem> addToCart(
    Session session,
    int productId, {
    int quantity = 1,
  }) {
    return _repository.addItem(session, productId, quantity: quantity);
  }

  Future<CartItem> updateCartItemQuantity(
    Session session,
    int productId,
    int quantity,
  ) {
    return _repository.updateQuantity(session, productId, quantity);
  }

  Future<void> removeFromCart(Session session, int productId) {
    return _repository.removeItem(session, productId);
  }

  Future<void> clearCart(Session session) {
    return _repository.clear(session);
  }
}
