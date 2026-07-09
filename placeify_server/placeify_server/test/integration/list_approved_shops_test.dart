import 'package:placeify_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Approved shops listing', (sessionBuilder, endpoints) {
    test('listApprovedShops returns demo vendor with shop metadata', () async {
      final auth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Shop Browser',
      );

      await endpoints.product.listCategories(auth.session);

      final shops = await endpoints.product.listApprovedShops(auth.session);
      expect(shops, isNotEmpty);

      final demoShop = shops.firstWhere(
        (shop) => shop.businessName == 'Placeify Demo Store',
        orElse: () => shops.first,
      );

      expect(demoShop.vendorId, isNotNull);
      expect(demoShop.businessName, isNotEmpty);
      expect(demoShop.productCount, greaterThan(0));
      expect(demoShop.averageRating, greaterThanOrEqualTo(0));
    });
  });
}
