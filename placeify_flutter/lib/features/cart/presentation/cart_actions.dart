import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_client/placeify_client.dart' hide Order, OrderItem;
import 'package:placeify_flutter/features/orders/domain/models/order_item.dart';

import '../../../core/services/haptic_service.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../domain/constants/cart_strings.dart';
import 'providers/cart_provider.dart';

/// Adds a product to the cart, shows feedback, and optionally opens the cart.
Future<void> addToCart(
  WidgetRef ref,
  BuildContext context,
  String productId, {
  int quantity = 1,
  bool openCart = true,
}) async {
  HapticService.medium();
  final message = await ref
      .read(cartProvider.notifier)
      .addProduct(productId, quantity: quantity);
  if (!context.mounted) return;

  if (message != null) {
    PlaceifyToast.show(context, message);
    if (message.toLowerCase().contains('sign in')) {
      context.push('/login');
    }
    return;
  }

  PlaceifyToast.show(context, CartStrings.itemAddedSuccess);
  if (openCart) {
    context.push('/cart');
  }
}

/// Places a server order from the current cart (COD). Keeps Nisha cart UI intact.
Future<void> checkoutCart(WidgetRef ref, BuildContext context) async {
  HapticService.medium();

  if (ref.read(currentUserProvider).value == null) {
    PlaceifyToast.show(context, CartStrings.signInToCheckout);
    context.push('/login');
    return;
  }

  final message = await ref
      .read(cartProvider.notifier)
      .checkout(
        paymentMethod: PaymentMethod.cod,
      );
  if (!context.mounted) return;

  PlaceifyToast.show(context, message);

  if (message.startsWith('Order #')) {
    context.push('/profile/orders');
  }
}

/// Adds all order line items to the cart (reorder flow).
Future<void> reorderToCart(Ref ref, List<OrderItem> items) async {
  final cart = ref.read(cartProvider.notifier);
  for (final item in items) {
    await cart.addProduct(item.productId, quantity: item.quantity);
  }
}
