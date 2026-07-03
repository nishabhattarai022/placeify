import 'package:placeify_server/src/generated/checkout_request.dart';
import 'package:placeify_server/src/generated/pagination_input.dart';
import 'package:placeify_server/src/generated/payment_method.dart';
import 'package:placeify_server/src/generated/product_search_input.dart';
import 'package:placeify_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Product catalog ratings', (sessionBuilder, endpoints) {
    test(
      'searchProducts returns reviewCount and averageRating without extra review calls',
      () async {
        final auth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Rating Catalog User',
        );

        final categories = await endpoints.product.listCategories(auth.session);
        expect(categories, isNotEmpty);

        final page = await endpoints.product.searchProducts(
          auth.session,
          ProductSearchInput(
            pagination: PaginationInput(page: 1, pageSize: 50),
          ),
        );
        expect(page.items, isNotEmpty);

        for (final product in page.items) {
          expect(product.reviewCount, greaterThanOrEqualTo(0));
          expect(product.averageRating, greaterThanOrEqualTo(0));
          expect(product.averageRating, lessThanOrEqualTo(5));
        }
      },
    );

    test('submitReview updates product rating summary on the product row', () async {
      final auth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Rating Review User',
      );

      final setupSession = sessionBuilder.build();
      final seeded = await seedProductForUser(setupSession, auth.profile);
      await setupSession.close();

      final productId = seeded.product.id!;
      final before = await endpoints.product.getProduct(auth.session, productId);
      expect(before, isNotNull);
      expect(before!.reviewCount, 0);
      expect(before.averageRating, 0);

      await endpoints.cart.addToCart(auth.session, productId, quantity: 1);
      final checkout = await endpoints.checkout.checkout(
        auth.session,
        CheckoutRequest(
          shippingAddress: 'Kathmandu, Nepal',
          paymentMethod: PaymentMethod.cod,
        ),
      );
      final orderId = checkout.order.id!;

      await endpoints.review.submitReview(
        auth.session,
        productId,
        orderId,
        4,
        comment: 'Solid build quality.',
      );

      final after = await endpoints.product.getProduct(auth.session, productId);
      expect(after, isNotNull);
      expect(after!.reviewCount, 1);
      expect(after.averageRating, 4);

      final searchPage = await endpoints.product.searchProducts(
        auth.session,
        ProductSearchInput(query: seeded.product.name),
      );
      final listed = searchPage.items.firstWhere((item) => item.id == productId);
      expect(listed.reviewCount, 1);
      expect(listed.averageRating, 4);
    });
  });
}
