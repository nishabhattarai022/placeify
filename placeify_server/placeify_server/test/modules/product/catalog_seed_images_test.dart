import 'package:placeify_server/src/modules/product/catalog_seed.dart';
import 'package:placeify_server/src/modules/product/catalog_seed_images.dart';
import 'package:test/test.dart';

void main() {
  group('CatalogSeedImages', () {
    test('defines images for all 18 demo products', () {
      expect(CatalogSeed.demoProductNames, hasLength(18));

      for (final name in CatalogSeed.demoProductNames) {
        final images = CatalogSeedImages.forProduct(name);
        expect(images.thumbnail, isNotEmpty);
        expect(images.views, isNotEmpty);
        expect(images.views, isNot(contains(images.thumbnail)));
      }
    });

    test('assigns a unique thumbnail file to every demo product', () {
      final thumbnails = CatalogSeed.demoProductNames
          .map((name) => CatalogSeedImages.forProduct(name).thumbnail)
          .toList();

      expect(thumbnails.toSet(), hasLength(thumbnails.length));
      for (final thumbnail in thumbnails) {
        expect(thumbnail, startsWith('product_'));
      }
    });
  });
}
