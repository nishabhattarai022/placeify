import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Given Wishlist endpoint', (sessionBuilder, endpoints) {
    test(
      'when authenticated then listMyWishlist returns saved products',
      () async {
        final auth = await createAuthenticatedUser(sessionBuilder, endpoints);

        final setupSession = sessionBuilder.build();
        final seeded = await seedProductForUser(setupSession, auth.profile);
        await setupSession.close();

        await endpoints.wishlist.addToWishlist(
          auth.session,
          seeded.product.id!,
        );

        final page = await endpoints.wishlist.listMyWishlist(auth.session);

        expect(page.total, 1);
        expect(page.items, hasLength(1));
        expect(page.items.first.productId, seeded.product.id);
        expect(page.items.first.product?.name, 'Test Chair');
      },
    );

    test(
      'when toggling wishlist twice then item is removed',
      () async {
        final auth = await createAuthenticatedUser(sessionBuilder, endpoints);

        final setupSession = sessionBuilder.build();
        final seeded = await seedProductForUser(setupSession, auth.profile);
        await setupSession.close();

        final productId = seeded.product.id!;
        expect(
          await endpoints.wishlist.toggleWishlist(auth.session, productId),
          isTrue,
        );
        expect(
          await endpoints.wishlist.toggleWishlist(auth.session, productId),
          isFalse,
        );

        final page = await endpoints.wishlist.listMyWishlist(auth.session);
        expect(page.total, 0);
        expect(page.items, isEmpty);
      },
    );

    test(
      'when not authenticated then listMyWishlist throws',
      () async {
        await expectLater(
          endpoints.wishlist.listMyWishlist(sessionBuilder),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      },
    );
  });
}
