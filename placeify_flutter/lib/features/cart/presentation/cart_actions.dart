import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_flutter/features/orders/domain/models/order_item.dart';

import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../domain/cart_totals.dart';
import '../domain/checkout_flow_result.dart';
import '../domain/constants/cart_strings.dart';
import 'providers/cart_provider.dart';
import 'providers/checkout_order_provider.dart';
import 'providers/checkout_payment_provider.dart';

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

/// Opens checkout payment selection (does not place an order).
Future<void> navigateToCheckout(WidgetRef ref, BuildContext context) async {
  HapticService.medium();

  if (ref.read(currentUserProvider).value == null ||
      !client.auth.isAuthenticated) {
    PlaceifyToast.show(context, CartStrings.signInToCheckout);
    context.push('/login');
    return;
  }

  if (ref.read(cartProvider).isEmpty) {
    PlaceifyToast.show(context, CartStrings.emptyCartCheckout);
    return;
  }

  ref.read(selectedPaymentMethodProvider.notifier).clear();
  context.push('/cart/checkout');
}

/// Places an order using cart, totals, and selected payment method providers.
Future<CheckoutFlowResult> confirmCheckoutOrder(
  WidgetRef ref, {
  required CartTotals totals,
}) {
  return ref
      .read(checkoutOrderActionProvider.notifier)
      .confirm(totals: totals);
}

/// Adds all order line items to the cart (reorder flow).
Future<void> reorderToCart(Ref ref, List<OrderItem> items) async {
  final cart = ref.read(cartProvider.notifier);
  for (final item in items) {
    await cart.addProduct(item.productId, quantity: item.quantity);
  }
}
