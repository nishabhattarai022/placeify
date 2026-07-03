import 'package:placeify_server/src/generated/product_search_input.dart';
import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/modules/product/catalog_seed.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

void main() {
  withServerpod('Catalog seed contract', (sessionBuilder, endpoints) {
    test(
      'seeds 18 demo products with images and Nisha browse categories',
      () async {
        final auth = await createAuthenticatedUser(
          sessionBuilder,
          endpoints,
          name: 'Catalog Seed User',
        );

        final setupSession = sessionBuilder.build();
        final legacyLights = await Category.db.insertRow(
          setupSession,
          Category(name: 'lights', description: 'Legacy'),
        );
        final legacyDecor = await Category.db.insertRow(
          setupSession,
          Category(name: 'decor', description: 'Legacy'),
        );
        await setupSession.close();

        final categories = await endpoints.product.listCategories(auth.session);
        expect(
          categories.map((category) => category.name).toList(),
          CatalogSeed.defaultCategoryNames,
        );
        expect(
          categories.any((category) => category.name == 'lights'),
          isFalse,
        );
        expect(
          categories.any((category) => category.name == 'decor'),
          isFalse,
        );

        final catalogPage = await endpoints.product.searchProducts(
          auth.session,
          ProductSearchInput(
            pagination: PaginationInput(page: 1, pageSize: 50),
          ),
        );
        final demoProducts = catalogPage.items
            .where((product) => CatalogSeed.demoProductNames.contains(product.name))
            .toList();
        expect(demoProducts, hasLength(18));

        for (final product in demoProducts) {
          expect(
            product.thumbnailUrl,
            startsWith('/uploads/catalog-seed/'),
            reason: '${product.name} missing thumbnailUrl',
          );
          expect(product.viewImageUrls, isNotNull);
          expect(product.viewImageUrls, isNotEmpty);
          for (final viewUrl in product.viewImageUrls!) {
            expect(viewUrl, startsWith('/uploads/catalog-seed/'));
          }
          expect(product.category?.name, isNotNull);
          expect(
            CatalogSeed.defaultCategoryNames,
            contains(product.category!.name),
          );
        }

        final cleanupSession = sessionBuilder.build();
        final lightsStillThere = await Category.db.findById(
          cleanupSession,
          legacyLights.id!,
        );
        final decorStillThere = await Category.db.findById(
          cleanupSession,
          legacyDecor.id!,
        );
        expect(lightsStillThere, isNull);
        expect(decorStillThere, isNull);
        await cleanupSession.close();
      },
    );
  });
}
