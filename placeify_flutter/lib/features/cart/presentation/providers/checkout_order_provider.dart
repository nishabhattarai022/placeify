import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/config/placeify_server_client.dart';
import '../../../../core/debug/agent_debug_log.dart';
import '../../../../core/utils/vendor_purchase_policy.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/catalog_provider.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../../../profile/presentation/providers/profile_dashboard_provider.dart';
import '../../data/cart_api_errors.dart';
import '../../data/serverpod_cart_repository.dart';
import '../../domain/cart_totals.dart';
import '../../domain/checkout_flow_result.dart';
import '../../domain/checkout_payment_option.dart';
import '../../domain/constants/cart_strings.dart';
import 'cart_provider.dart';
import 'checkout_payment_provider.dart';

part 'checkout_order_provider.g.dart';

final _cartRepository = ServerpodCartRepository();

/// Places an order from checkout — separate from [Cart] to avoid provider cycles.
/// keepAlive: confirm() awaits network work; autoDispose would dispose this
/// notifier between awaits when nothing watches it (one-shot ref.read).
@Riverpod(keepAlive: true)
class CheckoutOrderAction extends _$CheckoutOrderAction {
  @override
  bool build() => false;

  Future<CheckoutFlowResult> confirm({required CartTotals totals}) async {
    // #region agent log
    agentDebugLog(
      location: 'checkout_order_provider.dart:confirm:entry',
      message: 'CheckoutOrderAction.confirm started',
      hypothesisId: 'H6',
      data: {
        'refMounted': ref.mounted,
        'keepAlive': true,
      },
      runId: 'post-fix',
    );
    // #endregion
    await client.auth.initialize();

    final paymentOption = ref.read(selectedPaymentMethodProvider);
    final localItems = ref.read(cartProvider);
    final user = ref.read(currentUserProvider).value;
    final hasAuth = client.auth.isAuthenticated;

    debugPrint('CHECKOUT DEBUG user: $user');
    debugPrint('CHECKOUT DEBUG token: ${hasAuth ? "exists" : "missing"}');
    debugPrint('CHECKOUT DEBUG cartItems: $localItems');
    debugPrint('CHECKOUT DEBUG cartItems length: ${localItems.length}');
    debugPrint('CHECKOUT DEBUG selectedPayment: $paymentOption');
    debugPrint('CHECKOUT DEBUG serverUrl: $serverUrl');

    if (!hasAuth || user == null) {
      return const CheckoutFlowFailure('Sign in to checkout');
    }

    if (paymentOption == null) {
      return const CheckoutFlowFailure(
        'Please select a payment method to continue.',
      );
    }

    if (paymentOption == CheckoutPaymentOption.khalti) {
      return const CheckoutFlowFailure(CartStrings.khaltiUnavailable);
    }

    if (localItems.isEmpty) {
      return const CheckoutFlowFailure(
        'Your cart is empty. Add products from Browse, then try again.',
      );
    }

    try {
      final serverItems =
          await ref.read(cartProvider.notifier).resolveServerCartForCheckout();

      // #region agent log
      agentDebugLog(
        location: 'checkout_order_provider.dart:confirm:serverCart',
        message: 'Resolved server cart for checkout',
        hypothesisId: 'H3',
        data: {
          'localLen': localItems.length,
          'serverLen': serverItems.length,
          'payment': paymentOption.name,
          'productIds': serverItems.map((e) => e.productId).take(8).toList(),
        },
      );
      // #endregion

      debugPrint('CHECKOUT DEBUG serverCart length: ${serverItems.length}');
      debugPrint('CHECKOUT DEBUG serverCart items: $serverItems');

      if (serverItems.isEmpty) {
        return const CheckoutFlowFailure(
          'Your cart items could not be saved to the server. '
          'Remove and re-add items while signed in, then try again.',
        );
      }

      final catalog = ref.read(catalogIndexProvider).value ?? {};
      await ref.read(catalogIndexProvider.notifier).ensureProducts(
            serverItems.map((item) => item.productId),
          );
      final resolvedCatalog = ref.read(catalogIndexProvider).value ?? catalog;
      for (final item in serverItems) {
        final product = resolvedCatalog[item.productId];
        if (product == null) {
          return CheckoutFlowFailure(
            'Cart item ${item.productId} is no longer available. '
            'Remove it and try again.',
          );
        }
        if (!VendorPurchasePolicy.canPurchase(
          user: user,
          productVendorId: product.vendorId,
        )) {
          return const CheckoutFlowFailure(
            VendorPurchasePolicy.checkoutBlockedMessage,
          );
        }
      }

      String shippingAddress = 'Kathmandu, Nepal';
      try {
        final profile = await client.user.getCurrentUser();
        final savedAddress = profile?.address?.trim();
        if (savedAddress != null && savedAddress.isNotEmpty) {
          shippingAddress = savedAddress;
        }
      } catch (error) {
        debugPrint('[checkout] getCurrentUser failed: $error');
      }

      final payload = CheckoutOrderPayload(
        items: serverItems,
        subtotal: totals.subtotal,
        total: totals.total,
        paymentMethod: paymentOption,
        paymentStatus: paymentOption.paymentStatusLabel,
      );

      debugPrint('CHECKOUT DEBUG payload: ${payload.toJson()}');
      debugPrint(
        'CHECKOUT DEBUG request body={shippingAddress: $shippingAddress, '
        'paymentMethod: ${paymentOption.apiMethod.name}}',
      );

      final result = await _cartRepository.checkout(
        shippingAddress,
        paymentMethod: paymentOption.apiMethod,
      );

      final orderId = result.order.id;
      if (orderId == null) {
        return CheckoutFlowFailure(
          CartApiErrors.message(
            StateError('ORDER_ID_MISSING'),
            fallback: 'Order placed but id was missing. Check My Orders.',
          ),
        );
      }

      // #region agent log
      agentDebugLog(
        location: 'checkout_order_provider.dart:confirm:success',
        message: 'Checkout API succeeded',
        hypothesisId: 'H6',
        data: {
          'orderId': orderId,
          'itemCount': result.itemCount,
          'payment': paymentOption.apiMethod.name,
          'localCartLen': ref.read(cartProvider).length,
          'refMounted': ref.mounted,
        },
        runId: 'post-fix',
      );
      // #endregion

      ref.invalidate(profileDashboardProvider);
      ref.invalidate(ordersProvider);

      debugPrint(
        'CHECKOUT DEBUG response success orderId=$orderId '
        'itemCount=${result.itemCount}',
      );

      // Delay local cart clear until after UI navigates — clearing here makes
      // CheckoutPaymentScreen rebuild as "empty cart" and kills success feedback.
      return CheckoutFlowSuccess(
        orderId: orderId,
        message: CartStrings.orderPlacedSuccess,
        payload: payload.toJson(),
      );
    } catch (error, stackTrace) {
      debugPrint('CHECKOUT DEBUG caught error: $error');
      debugPrint('CHECKOUT DEBUG stackTrace: $stackTrace');
      // #region agent log
      agentDebugLog(
        location: 'checkout_order_provider.dart:confirm:catch',
        message: 'Checkout API failed',
        hypothesisId: 'H6',
        data: {
          'error': error.toString(),
          'refMounted': ref.mounted,
          'isDisposedRef': error.toString().contains('disposed'),
        },
        runId: 'post-fix',
      );
      // #endregion
      try {
        await ref.read(cartProvider.notifier).refresh();
      } catch (refreshError, refreshStack) {
        debugPrint('[checkout] cart refresh after failure: $refreshError');
        debugPrint('$refreshStack');
      }
      return CheckoutFlowFailure(
        CartApiErrors.message(
          error,
          fallback: CartStrings.unableToPlaceOrder,
        ),
      );
    }
  }
}
