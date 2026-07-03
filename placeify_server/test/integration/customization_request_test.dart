import 'package:placeify_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Customization requests', (sessionBuilder, endpoints) {
    test('createRequest links user, product, and vendor', () async {
      final auth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Customization User',
      );

      final setupSession = sessionBuilder.build();
      final seeded = await seedProductForUser(setupSession, auth.profile);
      await setupSession.close();

      final productId = seeded.product.id!;
      final request = await endpoints.customization.createRequest(
        auth.session,
        productId,
        'Please build this chair in walnut with darker cushions.',
      );

      expect(request.id, isNotNull);
      expect(request.productId, productId);
      expect(request.vendorId, seeded.product.vendorId);
      expect(request.userId, auth.profile.id);
      expect(request.status, RequestStatus.pending);

      final mine = await endpoints.customization.listMyRequests(
        auth.session,
        limit: 20,
        offset: 0,
      );
      expect(mine.any((row) => row.id == request.id), isTrue);
    });
  });
}
