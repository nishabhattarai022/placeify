import 'package:placeify_server/src/generated/order_status.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Given User dashboard endpoints', (sessionBuilder, endpoints) {
    test(
      'when authenticated then getDashboard returns live counts',
      () async {
        final auth = await createAuthenticatedUser(sessionBuilder, endpoints);

        final setupSession = sessionBuilder.build();
        final seeded = await seedProductForUser(setupSession, auth.profile);
        await seedOrderForUser(setupSession, auth.profile, seeded.product);
        await endpoints.wishlist.addToWishlist(
          auth.session,
          seeded.product.id!,
        );
        await setupSession.close();

        final dashboard = await endpoints.user.getDashboard(auth.session);

        expect(dashboard.profile.name, 'Test User');
        expect(dashboard.orderCount, 1);
        expect(dashboard.wishlistCount, 1);
        expect(dashboard.refundCount, 0);
      },
    );

    test(
      'when authenticated then listMyOrders returns order summaries',
      () async {
        final auth = await createAuthenticatedUser(sessionBuilder, endpoints);

        final setupSession = sessionBuilder.build();
        final seeded = await seedProductForUser(setupSession, auth.profile);
        final order = await seedOrderForUser(
          setupSession,
          auth.profile,
          seeded.product,
        );
        await setupSession.close();

        final orders = await endpoints.user.listMyOrders(
          auth.session,
          limit: 20,
          offset: 0,
        );

        expect(orders, hasLength(1));
        expect(orders.first.id, order.id);
        expect(orders.first.status, OrderStatus.delivered);
        expect(orders.first.totalAmount, seeded.product.price);
        expect(orders.first.primaryProductName, contains('Test Chair'));
      },
    );

    test(
      'when filtering by status then listMyOrders returns matching orders',
      () async {
        final auth = await createAuthenticatedUser(sessionBuilder, endpoints);

        final setupSession = sessionBuilder.build();
        final seeded = await seedProductForUser(setupSession, auth.profile);
        await seedOrderForUser(setupSession, auth.profile, seeded.product);
        await setupSession.close();

        final pending = await endpoints.user.listMyOrders(
          auth.session,
          limit: 20,
          offset: 0,
          status: OrderStatus.pending,
        );
        final delivered = await endpoints.user.listMyOrders(
          auth.session,
          limit: 20,
          offset: 0,
          status: OrderStatus.delivered,
        );

        expect(pending, isEmpty);
        expect(delivered, hasLength(1));
      },
    );

    test(
      'when not authenticated then getDashboard throws',
      () async {
        await expectLater(
          endpoints.user.getDashboard(sessionBuilder),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      },
    );

    test(
      'when not authenticated then listMyOrders throws',
      () async {
        await expectLater(
          endpoints.user.listMyOrders(
            sessionBuilder,
            limit: 20,
            offset: 0,
          ),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      },
    );
  });
}
