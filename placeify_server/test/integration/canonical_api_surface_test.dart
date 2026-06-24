import 'package:placeify_server/src/generated/placeify_exception.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

/// Ensures duplicate consumer APIs stay deprecated in favour of the `user` module.
void main() {
  withServerpod('Canonical API surface', (sessionBuilder, endpoints) {
    test(
      'order module endpoints are deprecated for consumer apps',
      () async {
        final auth = await createAuthenticatedUser(sessionBuilder, endpoints);

        await expectLater(
          endpoints.order.listMyOrders(auth.session),
          throwsA(
            predicate<PlaceifyException>(
              (error) => error.code == 'DEPRECATED_ENDPOINT',
            ),
          ),
        );

        await expectLater(
          endpoints.order.getOrder(auth.session, 1),
          throwsA(
            predicate<PlaceifyException>(
              (error) => error.code == 'DEPRECATED_ENDPOINT',
            ),
          ),
        );

        await expectLater(
          endpoints.order.listDeliveryUpdates(auth.session, 1),
          throwsA(
            predicate<PlaceifyException>(
              (error) => error.code == 'DEPRECATED_ENDPOINT',
            ),
          ),
        );
      },
    );
  });
}
