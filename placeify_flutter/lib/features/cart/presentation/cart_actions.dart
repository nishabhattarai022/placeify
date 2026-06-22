import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_flutter/features/orders/domain/models/order_item.dart';

import 'providers/cart_provider.dart';

/// Adds a product to the cart and optionally opens the cart screen.
void addToCart(
  WidgetRef ref,
  BuildContext context,
  String productId, {
  int quantity = 1,
  bool openCart = true,
}) {
  ref.read(cartProvider.notifier).addProduct(productId, quantity: quantity);
  if (openCart) {
    context.push('/cart');
  }
}

/// Adds all order line items to the cart (reorder flow).
void reorderToCart(Ref ref, List<OrderItem> items) {
  final cart = ref.read(cartProvider.notifier);
  for (final item in items) {
    cart.addProduct(item.productId, quantity: item.quantity);
  }
}
