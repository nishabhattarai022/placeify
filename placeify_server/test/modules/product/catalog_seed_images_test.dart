import 'dart:io';

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

    test('bundled thumbnail bytes are unique across demo products', () {
      final assetsDir = Directory('assets/catalog_seed');
      expect(assetsDir.existsSync(), isTrue);

      final bytesByFile = <String, List<int>>{};
      for (final name in CatalogSeed.demoProductNames) {
        final fileName = CatalogSeedImages.forProduct(name).thumbnail;
        final file = File('${assetsDir.path}/$fileName');
        expect(file.existsSync(), isTrue, reason: 'missing $fileName');

        final bytes = file.readAsBytesSync();
        for (final entry in bytesByFile.entries) {
          expect(
            entry.value,
            isNot(equals(bytes)),
            reason: '$fileName shares bytes with ${entry.key}',
          );
        }
        bytesByFile[fileName] = bytes;
      }
    });

    test('legacy orphan products are listed for deactivation', () {
      expect(CatalogSeed.legacyOrphanProductNames, isNotEmpty);
      for (final name in CatalogSeed.legacyOrphanProductNames) {
        expect(CatalogSeed.demoProductNames, isNot(contains(name)));
      }
    });
  });
}
