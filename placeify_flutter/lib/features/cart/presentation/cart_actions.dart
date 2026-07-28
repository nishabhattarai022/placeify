import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_flutter/features/orders/domain/models/order_item.dart';

import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../../core/debug/agent_debug_log.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../home/presentation/providers/catalog_provider.dart';
import '../data/product_id_codec.dart';
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

/// Result of reordering an order into the cart.
class ReorderToCartResult {
  const ReorderToCartResult({
    required this.addedCount,
    required this.skipped,
  });

  final int addedCount;
  final List<String> skipped;

  bool get hasAdditions => addedCount > 0;
  bool get hasSkips => skipped.isNotEmpty;
}

/// Places an order using cart, totals, and selected payment method providers.
Future<CheckoutFlowResult> confirmCheckoutOrder(
  WidgetRef ref, {
  required CartTotals totals,
  required String shippingAddress,
}) {
  return ref.read(checkoutOrderActionProvider.notifier).confirm(
        totals: totals,
        shippingAddress: shippingAddress,
      );
}

/// Adds order line items to the cart with availability checks (reorder flow).
Future<ReorderToCartResult> reorderToCart(Ref ref, List<OrderItem> items) async {
  final cart = ref.read(cartProvider.notifier);
  final catalog = ref.read(catalogIndexProvider.notifier);
  var addedCount = 0;
  final skipped = <String>[];

  // Ensure catalog entries exist before addProduct lookups.
  await catalog.ensureProducts(
    items.map((item) => ProductIdCodec.normalizeUiProductId(item.productId)),
  );
  final index = ref.read(catalogIndexProvider).value ?? {};

  for (final item in items) {
    final uiId = ProductIdCodec.normalizeUiProductId(item.productId);
    final product = index[uiId];
    if (product == null) {
      skipped.add(
        '${item.productName}: This product is no longer available.',
      );
      // #region agent log
      agentDebugLog(
        location: 'cart_actions.dart:reorderToCart',
        message: 'Reorder skipped product',
        hypothesisId: 'O2',
        data: {
          'productId': uiId,
          'productName': item.productName,
          'reason': 'not_in_catalog',
        },
      );
      // #endregion
      continue;
    }

    final error = await cart.addProduct(uiId, quantity: item.quantity);
    if (error != null) {
      skipped.add('${item.productName}: $error');
      // #region agent log
      agentDebugLog(
        location: 'cart_actions.dart:reorderToCart',
        message: 'Reorder add failed',
        hypothesisId: 'O2',
        data: {
          'productId': uiId,
          'productName': item.productName,
          'reason': error,
        },
      );
      // #endregion
      continue;
    }
    addedCount += item.quantity;
  }

  return ReorderToCartResult(addedCount: addedCount, skipped: skipped);
}
