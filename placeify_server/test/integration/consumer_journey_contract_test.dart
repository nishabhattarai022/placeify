import 'package:placeify_server/src/generated/checkout_request.dart';
import 'package:placeify_server/src/generated/delivery_stage.dart';
import 'package:placeify_server/src/generated/order_payment_status.dart';
import 'package:placeify_server/src/generated/order_status.dart';
import 'package:placeify_server/src/generated/payment_method.dart';
import 'package:placeify_server/src/generated/payment_transaction_status.dart';
import 'package:placeify_server/src/generated/placeify_exception.dart';
import 'package:placeify_server/src/generated/product_search_input.dart';
import 'package:placeify_server/src/generated/protocol.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

/// End-to-end contract test for the canonical consumer API surface.
///
/// If this test fails, either the backend broke the contract or the contract
/// doc (`docs/CONSUMER_API_CONTRACT.md`) must be updated intentionally.
void main() {
  withServerpod('Consumer API contract journey', (sessionBuilder, endpoints) {
    test(
      'auth → catalog → cart → checkout → orders → wishlist → refund → notifications',
      () async {
        // ── 1. Auth & profile ─────────────────────────────────────────────
        final auth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Contract User',
        );

        final updated = await endpoints.user.updateProfile(
          auth.session,
          'Contract User',
          phone: '9800000000',
          address: 'Kathmandu, Nepal',
        );
        expect(updated.phone, '9800000000');
        expect(updated.address, 'Kathmandu, Nepal');

        var dashboard = await endpoints.user.getDashboard(auth.session);
        expect(dashboard.profile.name, 'Contract User');
        expect(dashboard.orderCount, 0);
        expect(dashboard.wishlistCount, 0);
        expect(dashboard.cartItemCount, 0);
        expect(dashboard.refundCount, 0);

        // ── 2. Catalog ────────────────────────────────────────────────────
        final setupSession = sessionBuilder.build();
        final seeded = await seedProductForUser(setupSession, auth.profile);
        await setupSession.close();

        final productId = seeded.product.id!;
        final searchPage = await endpoints.product.searchProducts(
          auth.session,
          ProductSearchInput(query: 'Test Chair'),
        );
        expect(searchPage.items.any((p) => p.id == productId), isTrue);

        final product = await endpoints.product.getProduct(
          auth.session,
          productId,
        );
        expect(product, isNotNull);
        expect(product!.name, 'Test Chair');
        expect(product.price, seeded.product.price);

        // ── 3. Cart & checkout ────────────────────────────────────────────
        await endpoints.cart.addToCart(auth.session, productId, quantity: 2);

        final cartItems = await endpoints.cart.getCartItems(auth.session);
        expect(cartItems, hasLength(1));
        expect(cartItems.first.productId, productId);
        expect(cartItems.first.quantity, 2);

        dashboard = await endpoints.user.getDashboard(auth.session);
        expect(dashboard.cartItemCount, 2);

        final checkout = await endpoints.checkout.checkout(
          auth.session,
          CheckoutRequest(
            shippingAddress: 'Kathmandu, Nepal',
            paymentMethod: PaymentMethod.cod,
          ),
        );
        expect(checkout.itemCount, 2);
        expect(checkout.order.id, isNotNull);
        expect(checkout.order.shippingAddress, 'Kathmandu, Nepal');

        final orderId = checkout.order.id!;
        expect((await endpoints.cart.getCartItems(auth.session)), isEmpty);

        // ── 4. Orders ─────────────────────────────────────────────────────
        final summaries = await endpoints.user.listMyOrders(
          auth.session,
          limit: 20,
          offset: 0,
        );
        expect(summaries, hasLength(1));
        expect(summaries.first.id, orderId);
        expect(summaries.first.itemCount, 2);
        expect(summaries.first.orderPaymentStatus, OrderPaymentStatus.unpaid);
        expect(summaries.first.primaryProductName, contains('Test Chair'));

        final detail = await endpoints.user.getMyOrder(auth.session, orderId);
        expect(detail.id, orderId);
        expect(detail.shippingAddress, 'Kathmandu, Nepal');
        expect(detail.items, hasLength(1));
        expect(detail.items.first.productId, productId);
        expect(detail.items.first.quantity, 2);
        expect(detail.payment.status, PaymentTransactionStatus.pending);
        expect(detail.payment.paymentMethod, PaymentMethod.cod);

        final payment = await endpoints.user.getMyOrderPayment(
          auth.session,
          orderId,
        );
        expect(payment.orderId, orderId);
        expect(payment.status, PaymentTransactionStatus.pending);

        await expectLater(
          endpoints.user.completePayment(auth.session, orderId),
          throwsA(
            predicate<PlaceifyException>(
              (error) =>
                  error.code == 'FORBIDDEN' &&
                  error.message.contains('vendor'),
            ),
          ),
        );

        dashboard = await endpoints.user.getDashboard(auth.session);
        expect(dashboard.orderCount, 1);
        expect(dashboard.cartItemCount, 0);

        // ── 5. Wishlist ───────────────────────────────────────────────────
        expect(
          await endpoints.wishlist.toggleWishlist(auth.session, productId),
          isTrue,
        );
        final wishlist = await endpoints.wishlist.listMyWishlist(auth.session);
        expect(wishlist.total, 1);
        expect(wishlist.items.first.productId, productId);

        dashboard = await endpoints.user.getDashboard(auth.session);
        expect(dashboard.wishlistCount, 1);

        // ── 6. Refund (delivered order seeded separately) ─────────────────
        final refundSetup = sessionBuilder.build();
        final deliveredOrder = await seedOrderForUser(
          refundSetup,
          auth.profile,
          seeded.product,
        );
        await refundSetup.close();

        final refund = await endpoints.refund.createRefundRequest(
          auth.session,
          deliveredOrder.id!,
          'Contract test refund',
        );
        expect(refund.orderId, deliveredOrder.id);
        expect(refund.status.name, 'pending');

        final refunds = await endpoints.refund.listMyRefundRequests(
          auth.session,
        );
        expect(refunds.any((r) => r.id == refund.id), isTrue);

        dashboard = await endpoints.user.getDashboard(auth.session);
        expect(dashboard.refundCount, 1);

        // ── 7. Notifications ──────────────────────────────────────────────
        final prefs = await endpoints.notification.getPreferences(auth.session);
        expect(prefs.orderUpdates, isTrue);

        final updatedPrefs = await endpoints.notification.updatePreferences(
          auth.session,
          promotions: true,
        );
        expect(updatedPrefs.promotions, isTrue);

        final unread =
            await endpoints.notification.unreadInAppNotificationCount(
          auth.session,
        );
        expect(unread, greaterThanOrEqualTo(0));

        final inApp = await endpoints.notification.listInAppNotifications(
          auth.session,
          limit: 10,
          offset: 0,
        );
        expect(inApp, isA<List<InAppNotificationSummary>>());

        // ── 8. AR history (empty is valid) ────────────────────────────────
        final arSessions = await endpoints.user.listMyArSessions(
          auth.session,
          limit: 10,
          offset: 0,
        );
        expect(arSessions, isA<List<UserArSessionSummary>>());

        // ── 9. Cancel live checkout order (cleanup + cancel contract) ─────
        dashboard = await endpoints.user.getDashboard(auth.session);
        expect(dashboard.orderCount, 2);

        final cancelled = await endpoints.user.cancelMyOrder(
          auth.session,
          orderId,
          'Contract test cleanup',
        );
        expect(cancelled.status, OrderStatus.cancelled);

        dashboard = await endpoints.user.getDashboard(auth.session);
        expect(dashboard.orderCount, 1);
      },
    );

    test('unauthenticated calls reject with auth exception', () async {
      await expectLater(
        endpoints.user.getDashboard(sessionBuilder),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
      await expectLater(
        endpoints.cart.getCartItems(sessionBuilder),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
      await expectLater(
        endpoints.checkout.checkout(
          sessionBuilder,
          CheckoutRequest(shippingAddress: 'Kathmandu'),
        ),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });
  });
}
