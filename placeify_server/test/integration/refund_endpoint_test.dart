import 'package:placeify_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Given Refund endpoint', (sessionBuilder, endpoints) {
    test(
      'when authenticated then createRefundRequest stores pending refund and syncs order',
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

        final created = await endpoints.refund.createRefundRequest(
          auth.session,
          order.id!,
          'Item arrived damaged',
        );

        expect(created.orderId, order.id);
        expect(created.status.name, 'pending');
        expect(created.refundAmount, seeded.product.price);
        expect(created.reason, 'Item arrived damaged');
        expect(created.orderNumber, 'ORD-${order.id}');
        expect(created.referenceNumber, 'RFN-${created.id}');

        final verifySession = sessionBuilder.build();
        final updatedOrder = await Order.db.findById(verifySession, order.id!);
        await verifySession.close();
        expect(updatedOrder?.status, OrderStatus.returnRequested);

        final dashboard = await endpoints.user.getDashboard(auth.session);
        expect(dashboard.refundCount, 1);

        final refunds = await endpoints.refund.listMyRefundRequests(
          auth.session,
        );
        expect(refunds, hasLength(1));
        expect(refunds.first.id, created.id);
      },
    );

    test(
      'when order is not delivered then createRefundRequest is rejected',
      () async {
        final auth = await createAuthenticatedUser(sessionBuilder, endpoints);

        final setupSession = sessionBuilder.build();
        final seeded = await seedProductForUser(setupSession, auth.profile);
        final order = await seedOrderForUser(
          setupSession,
          auth.profile,
          seeded.product,
        );
        await Order.db.updateRow(
          setupSession,
          order.copyWith(status: OrderStatus.shipped),
        );
        await setupSession.close();

        await expectLater(
          endpoints.refund.createRefundRequest(
            auth.session,
            order.id!,
            'Too early',
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'when return window expired then createRefundRequest is rejected',
      () async {
        final auth = await createAuthenticatedUser(sessionBuilder, endpoints);

        final setupSession = sessionBuilder.build();
        final seeded = await seedProductForUser(setupSession, auth.profile);
        final order = await seedOrderForUser(
          setupSession,
          auth.profile,
          seeded.product,
        );
        await Order.db.updateRow(
          setupSession,
          order.copyWith(
            placedAt: DateTime.now().toUtc().subtract(const Duration(days: 20)),
          ),
        );
        await setupSession.close();

        await expectLater(
          endpoints.refund.createRefundRequest(
            auth.session,
            order.id!,
            'Too late',
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'when duplicate pending refund then createRefundRequest is rejected',
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

        await endpoints.refund.createRefundRequest(
          auth.session,
          order.id!,
          'Wrong size',
        );

        await expectLater(
          endpoints.refund.createRefundRequest(
            auth.session,
            order.id!,
            'Duplicate request',
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test(
      'when not authenticated then listMyRefundRequests throws',
      () async {
        await expectLater(
          endpoints.refund.listMyRefundRequests(sessionBuilder),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      },
    );
  });
}
