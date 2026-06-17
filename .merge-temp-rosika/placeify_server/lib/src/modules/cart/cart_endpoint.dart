import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'cart_service.dart';

/// Authenticated shopping cart operations.
class CartEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final _service = CartService();

  Future<List<CartItem>> getCartItems(Session session) {
    return _service.getCartItems(session);
  }

  Future<CartItem> addToCart(
    Session session,
    int productId, {
    int quantity = 1,
  }) {
    return _service.addToCart(session, productId, quantity: quantity);
  }

  Future<CartItem> updateCartItemQuantity(
    Session session,
    int productId,
    int quantity,
  ) {
    return _service.updateCartItemQuantity(session, productId, quantity);
  }

  Future<void> removeFromCart(Session session, int productId) {
    return _service.removeFromCart(session, productId);
  }

  Future<void> clearCart(Session session) {
    return _service.clearCart(session);
  }
}
