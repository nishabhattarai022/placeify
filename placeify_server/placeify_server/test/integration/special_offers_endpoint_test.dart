import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given special offers endpoint', (sessionBuilder, endpoints) {
    test(
      'listSpecialOffers returns active offers linked to catalog products',
      () async {
        final offers = await endpoints.product.listSpecialOffers(
          sessionBuilder,
          limit: 12,
        );

        expect(offers.length, greaterThanOrEqualTo(4));

        final productIds = <int>{};
        for (final offer in offers) {
          expect(offer.productId, greaterThan(0));
          expect(offer.productName, isNotEmpty);
          expect(offer.originalPrice, greaterThan(offer.discountedPrice));
          expect(offer.discountPercent, inInclusiveRange(1, 99));
          expect(offer.tagline, isNotEmpty);
          expect(offer.cardColorHex, isNotEmpty);
          productIds.add(offer.productId);
        }

        expect(productIds.length, offers.length);

        for (final productId in productIds) {
          final product = await endpoints.product.getProduct(
            sessionBuilder,
            productId,
          );
          expect(product, isNotNull);
          expect(
            offers.any(
              (offer) =>
                  offer.productId == productId &&
                  offer.productName == product!.name,
            ),
            isTrue,
          );
        }
      },
    );
  });
}
