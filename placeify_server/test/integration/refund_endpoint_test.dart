import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Given Refund endpoint', (sessionBuilder, endpoints) {
    test(
      'when authenticated then createRefundRequest stores a pending refund',
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
