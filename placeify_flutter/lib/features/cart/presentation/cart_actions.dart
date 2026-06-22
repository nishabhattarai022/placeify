import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/toast_overlay.dart';
import '../../orders/domain/models/order_item.dart';
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
  } else {
    PlaceifyToast.show(
      context,
      'Added to cart — checkout to notify the vendor',
    );
  }
  if (openCart) {
    context.push('/cart');
  }
}

/// Adds all order line items to the cart (reorder flow).
Future<void> reorderToCart(Ref ref, List<OrderItem> items) async {
  final cart = ref.read(cartProvider.notifier);
  for (final item in items) {
    await cart.addProduct(item.productId, quantity: item.quantity);
  }
}
