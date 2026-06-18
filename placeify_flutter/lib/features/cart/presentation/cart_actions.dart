import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/toast_overlay.dart';
import 'providers/cart_provider.dart';

/// Adds a product to the cart and optionally opens the cart screen.
Future<void> addToCart(
  WidgetRef ref,
  BuildContext context,
  String productId, {
  int quantity = 1,
  bool openCart = true,
}) async {
  final message =
      await ref.read(cartProvider.notifier).addProduct(productId, quantity: quantity);
  if (!context.mounted) return;
  if (message != null) {
    PlaceifyToast.show(context, message);
  }
  if (openCart) {
    context.push('/cart');
  }
}
