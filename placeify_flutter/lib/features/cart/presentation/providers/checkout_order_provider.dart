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
@Riverpod(keepAlive: true)
class CheckoutOrderAction extends _$CheckoutOrderAction {
  @override
  bool build() => false;

  Future<CheckoutFlowResult> confirm({required CartTotals totals}) async {
    try {
      final paymentOption = ref.read(selectedPaymentMethodProvider);
      final localItems = ref.read(cartProvider);
      final user = ref.read(currentUserProvider).value;
      final cartNotifier = ref.read(cartProvider.notifier);
      final catalog = ref.read(catalogIndexProvider).value ?? {};

      await client.auth.initialize();
      final hasAuth = client.auth.isAuthenticated;

      debugPrint('CONFIRM_ORDER_DEBUG selectedPayment: $paymentOption');
      debugPrint('CONFIRM_ORDER_DEBUG user: $user');
      debugPrint(
        'CONFIRM_ORDER_DEBUG token: ${hasAuth ? "exists" : "missing"}',
      );
      debugPrint('CONFIRM_ORDER_DEBUG cartItems: $localItems');
      debugPrint('CONFIRM_ORDER_DEBUG serverUrl: $serverUrl');

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

      final serverItems = await cartNotifier.resolveServerCartForCheckout();

      debugPrint('CONFIRM_ORDER_DEBUG serverCartItems: $serverItems');

      if (serverItems.isEmpty) {
        return const CheckoutFlowFailure(
          'Your cart items could not be saved to the server. '
          'Remove and re-add items while signed in, then try again.',
        );
      }

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

      debugPrint('CONFIRM_ORDER_DEBUG payload: ${payload.toJson()}');
      debugPrint(
        'CONFIRM_ORDER_DEBUG requestBody={shippingAddress: $shippingAddress, '
        'paymentMethod: ${paymentOption.apiMethod.name}}',
      );

      final result = await _cartRepository.checkout(
        shippingAddress,
        paymentMethod: paymentOption.apiMethod,
      );

      debugPrint('CONFIRM_ORDER_DEBUG responseStatus: success');
      debugPrint('CONFIRM_ORDER_DEBUG responseData: $result');

      if (ref.mounted) {
        cartNotifier.replaceItems(const []);
        ref.invalidate(profileDashboardProvider);
        ref.invalidate(ordersProvider);
      }

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
        'CONFIRM_ORDER_DEBUG responseSuccess orderId=$orderId '
        'itemCount=${result.itemCount}',
      );

      return CheckoutFlowSuccess(
        orderId: orderId,
        message: 'Order confirmed successfully',
        payload: payload.toJson(),
      );
    } catch (error, stackTrace) {
      debugPrint('CONFIRM_ORDER_DEBUG caughtError: $error');
      debugPrint('CONFIRM_ORDER_DEBUG stackTrace: $stackTrace');
      try {
        if (ref.mounted) {
          await ref.read(cartProvider.notifier).refresh();
        }
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
