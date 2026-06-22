import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/config/placeify_server_client.dart';
import '../domain/cart_line_item.dart';
import 'product_id_codec.dart';

/// Persists cart and checkout through the Placeify backend.
class ServerpodCartRepository {
  Future<List<CartLineItem>> fetchItems() async {
    _requireAuthenticated();
    final items = await client.cart.getCartItems();
    return [
      for (final item in items)
        CartLineItem(
          productId: ProductIdCodec.fromDatabaseId(item.productId),
          quantity: item.quantity,
        ),
    ];
  }

  Future<void> addProduct(String productId, {int quantity = 1}) async {
    final id = _requireDatabaseId(productId);
    _requireAuthenticated();
    await client.cart.addToCart(id, quantity: quantity);
  }

  Future<void> setQuantity(String productId, int quantity) async {
    final id = _requireDatabaseId(productId);
    _requireAuthenticated();
    await client.cart.updateCartItemQuantity(id, quantity);
  }

  Future<void> removeProduct(String productId) async {
    final id = _requireDatabaseId(productId);
    _requireAuthenticated();
    await client.cart.removeFromCart(id);
  }

  Future<CheckoutResult> checkout(
    String shippingAddress, {
    PaymentMethod paymentMethod = PaymentMethod.mockOnline,
  }) async {
    _requireAuthenticated();
    return client.checkout.checkout(
      CheckoutRequest(
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
      ),
    );
  }

  int _requireDatabaseId(String productId) {
    final id = ProductIdCodec.toDatabaseId(productId);
    if (id == null) {
      throw ArgumentError(
        'This product cannot be added to cart yet. '
        'Use items from the live catalog (Browse), not shop previews.',
      );
    }
    return id;
  }

  void _requireAuthenticated() {
    if (!client.auth.isAuthenticated) {
      throw StateError('Sign in to sync your cart with the server.');
    }
  }
}
