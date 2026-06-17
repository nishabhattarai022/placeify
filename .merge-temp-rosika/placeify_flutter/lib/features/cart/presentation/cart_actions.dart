import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
