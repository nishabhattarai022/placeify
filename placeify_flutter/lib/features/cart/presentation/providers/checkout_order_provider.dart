import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/config/placeify_server_client.dart';
import '../../../../core/utils/vendor_purchase_policy.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/catalog_provider.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../../../profile/presentation/providers/profile_dashboard_provider.dart';
import '../../../shops/data/mock_consumer_shop_repository.dart';
import '../../data/cart_api_errors.dart';
import '../../data/serverpod_cart_repository.dart';
import '../../domain/cart_totals.dart';
import '../../domain/checkout_flow_result.dart';
import '../../domain/checkout_payment_option.dart';
import 'cart_provider.dart';
import 'checkout_payment_provider.dart';

part 'checkout_order_provider.g.dart';

final _cartRepository = ServerpodCartRepository();

/// Places an order from checkout — separate from [Cart] to avoid provider cycles.
@riverpod
class CheckoutOrderAction extends _$CheckoutOrderAction {
  @override
  bool build() => false;

  Future<CheckoutFlowResult> confirm({required CartTotals totals}) async {
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

    if (localItems.isEmpty) {
      return const CheckoutFlowFailure(
        'Your cart is empty. Add products from Browse, then try again.',
      );
    }

    try {
      final serverItems =
          await ref.read(cartProvider.notifier).resolveServerCartForCheckout();

      debugPrint('CHECKOUT DEBUG serverCart length: ${serverItems.length}');
      debugPrint('CHECKOUT DEBUG serverCart items: $serverItems');

      if (serverItems.isEmpty) {
        return const CheckoutFlowFailure(
          'Your cart items could not be saved to the server. '
          'Remove and re-add items while signed in, then try again.',
        );
      }

      final catalog = ref.read(catalogIndexProvider).value ?? {};
      for (final item in serverItems) {
        final product =
            catalog[item.productId] ??
            MockConsumerShopRepository.productByIdSync(item.productId);
        if (!VendorPurchasePolicy.canPurchase(
          user: user,
          productVendorId: product?.vendorId,
        )) {
          return const CheckoutFlowFailure(
            VendorPurchasePolicy.checkoutBlockedMessage,
          );
        }
      }

      const shippingAddress = 'Kathmandu, Nepal';
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

      ref.read(cartProvider.notifier).replaceItems(const []);
      ref.invalidate(profileDashboardProvider);
      ref.invalidate(ordersProvider);

      final orderId = result.order.id;
      if (orderId == null) {
        return CheckoutFlowFailure(
          CartApiErrors.message(
            StateError('ORDER_ID_MISSING'),
            fallback: 'Order placed but id was missing. Check My Orders.',
          ),
        );
      }

      debugPrint(
        'CHECKOUT DEBUG response success orderId=$orderId '
        'itemCount=${result.itemCount}',
      );

      return CheckoutFlowSuccess(
        orderId: orderId,
        message: 'Order #$orderId placed successfully',
        payload: payload.toJson(),
      );
    } catch (error, stackTrace) {
      debugPrint('CHECKOUT DEBUG caught error: $error');
      debugPrint('CHECKOUT DEBUG stackTrace: $stackTrace');
      try {
        await ref.read(cartProvider.notifier).refresh();
      } catch (refreshError, refreshStack) {
        debugPrint('[checkout] cart refresh after failure: $refreshError');
        debugPrint('$refreshStack');
      }
      return CheckoutFlowFailure(
        CartApiErrors.message(
          error,
          fallback: 'Checkout failed. Add items while signed in and try again.',
        ),
      );
    }
  }
}
