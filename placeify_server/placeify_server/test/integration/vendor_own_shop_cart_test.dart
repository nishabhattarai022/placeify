import 'package:placeify_server/src/generated/pagination_input.dart';
import 'package:placeify_server/src/generated/placeify_exception.dart';
import 'package:placeify_server/src/generated/product_search_input.dart';
import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/modules/product/catalog_seed.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Vendor own-shop cart policy', (sessionBuilder, endpoints) {
    test('consumer can add seeded catalog products to cart', () async {
      final auth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Catalog Customer',
      );

      await endpoints.product.listCategories(auth.session);

      final profile = await endpoints.user.getCurrentUser(auth.session);
      expect(profile?.role, UserRole.consumer);

      final page = await endpoints.product.searchProducts(
        auth.session,
        ProductSearchInput(
          pagination: PaginationInput(page: 1, pageSize: 5),
        ),
      );
      expect(page.items, isNotEmpty);

      final productId = page.items.first.id!;
      final cartItem = await endpoints.cart.addToCart(
        auth.session,
        productId,
        quantity: 1,
      );
      expect(cartItem.productId, productId);
    });

    test('demo catalog vendor is not the logged-in consumer account', () async {
      final auth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Ownership Check User',
      );

      await endpoints.product.listCategories(auth.session);

      final setupSession = sessionBuilder.build();
      final demoVendor = await Vendor.db.findFirstRow(
        setupSession,
        where: (row) => row.shopName.equals(CatalogSeed.demoStoreName),
      );
      final catalogOwner = await User.db.findFirstRow(
        setupSession,
        where: (row) => row.email.equals(CatalogSeed.catalogVendorEmail),
      );
      await setupSession.close();

      expect(demoVendor, isNotNull);
      expect(catalogOwner, isNotNull);
      expect(demoVendor!.userId, catalogOwner!.id);
      expect(demoVendor.userId, isNot(auth.profile.id));
    });

    test('vendor cannot add own shop product but can add catalog product',
        () async {
      final vendorAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Own Shop Vendor',
      );

      final setupSession = sessionBuilder.build();
      final ownVendor = await Vendor.db.insertRow(
        setupSession,
        Vendor(
          userId: vendorAuth.profile.id!,
          shopName: 'Own Shop ${DateTime.now().microsecondsSinceEpoch}',
          description: 'Own shop',
        ),
      );
      final ownProduct = await Product.db.insertRow(
        setupSession,
        Product(
          vendorId: ownVendor.id!,
          name: 'Own Chair',
          description: 'Own product',
          price: 99,
          status: ProductStatus.active,
        ),
      );
      await setupSession.close();

      await endpoints.user.becomeVendor(vendorAuth.session);

      await expectLater(
        endpoints.cart.addToCart(
          vendorAuth.session,
          ownProduct.id!,
          quantity: 1,
        ),
        throwsA(
          isA<PlaceifyException>().having(
            (error) => error.code,
            'code',
            'OWN_SHOP_PURCHASE_FORBIDDEN',
          ),
        ),
      );

      await endpoints.product.listCategories(vendorAuth.session);
      final catalogPage = await endpoints.product.searchProducts(
        vendorAuth.session,
        ProductSearchInput(
          pagination: PaginationInput(page: 1, pageSize: 5),
        ),
      );
      final catalogProduct = catalogPage.items.firstWhere(
        (product) => product.vendorId != ownVendor.id,
      );

      final cartItem = await endpoints.cart.addToCart(
        vendorAuth.session,
        catalogProduct.id!,
        quantity: 1,
      );
      expect(cartItem.productId, catalogProduct.id);
    });

    test('unauthenticated addToCart is rejected', () async {
      await expectLater(
        endpoints.cart.addToCart(sessionBuilder, 1, quantity: 1),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });
  });
}
