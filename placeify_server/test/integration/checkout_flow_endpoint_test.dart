import 'package:placeify_server/src/generated/checkout_request.dart';
import 'package:placeify_server/src/generated/order_status.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Given checkout flow', (sessionBuilder, endpoints) {
    test(
      'when cart has items then checkout creates order and clears cart',
      () async {
        final auth = await createAuthenticatedUser(sessionBuilder, endpoints);

        final setupSession = sessionBuilder.build();
        final seeded = await seedProductForUser(setupSession, auth.profile);
        await setupSession.close();

        final productId = seeded.product.id!;

        await endpoints.cart.addToCart(auth.session, productId, quantity: 2);

        final cartBefore = await endpoints.cart.getCartItems(auth.session);
        expect(cartBefore, hasLength(1));
        expect(cartBefore.first.productId, productId);
        expect(cartBefore.first.quantity, 2);
        expect(cartBefore.first.unitPrice, seeded.product.price);

        final dashboardWithCart =
            await endpoints.user.getDashboard(auth.session);
        expect(dashboardWithCart.cartItemCount, 2);

        final result = await endpoints.checkout.checkout(
          auth.session,
          CheckoutRequest(shippingAddress: 'Kathmandu, Nepal'),
        );

        expect(result.itemCount, 2);
        expect(result.order.id, isNotNull);
        expect(result.order.status, OrderStatus.pending);
        expect(result.order.totalAmount, seeded.product.price * 2);
        expect(result.order.shippingAddress, 'Kathmandu, Nepal');

        final cartAfter = await endpoints.cart.getCartItems(auth.session);
        expect(cartAfter, isEmpty);

        final orders = await endpoints.user.listMyOrders(
          auth.session,
          limit: 20,
          offset: 0,
        );
        expect(orders, hasLength(1));
        expect(orders.first.id, result.order.id);
        expect(orders.first.status, OrderStatus.pending);
        expect(orders.first.totalAmount, seeded.product.price * 2);
        expect(orders.first.itemCount, 2);
        expect(orders.first.primaryProductName, contains('Test Chair'));

        final dashboard = await endpoints.user.getDashboard(auth.session);
        expect(dashboard.orderCount, 1);
        expect(dashboard.cartItemCount, 0);
      },
    );

    test(
      'when cart is empty then checkout is rejected',
      () async {
        final auth = await createAuthenticatedUser(sessionBuilder, endpoints);

        await expectLater(
          endpoints.checkout.checkout(
            auth.session,
            CheckoutRequest(shippingAddress: 'Kathmandu, Nepal'),
          ),
          throwsA(
            predicate<Exception>(
              (error) => error.toString().contains('CART_EMPTY'),
            ),
          ),
        );
      },
    );

    test(
      'when profile row is missing then cart and checkout still work',
      () async {
        final authSession = await createAuthSessionOnly(sessionBuilder);

        final setupSession = sessionBuilder.build();
        final vendorAuth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Vendor User',
        );
        final seeded = await seedProductForUser(
          setupSession,
          vendorAuth.profile,
        );
        await setupSession.close();

        await endpoints.cart.addToCart(
          authSession,
          seeded.product.id!,
          quantity: 1,
        );

        final profile = await endpoints.user.getCurrentUser(authSession);
        expect(profile, isNotNull);
        expect(profile!.name, 'User');

        final result = await endpoints.checkout.checkout(
          authSession,
          CheckoutRequest(shippingAddress: 'Kathmandu, Nepal'),
        );

        expect(result.itemCount, 1);
        expect(result.order.id, isNotNull);
      },
    );

    test(
      'when not authenticated then checkout throws',
      () async {
        await expectLater(
          endpoints.checkout.checkout(
            sessionBuilder,
            CheckoutRequest(shippingAddress: 'Kathmandu, Nepal'),
          ),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      },
    );
  });
}
