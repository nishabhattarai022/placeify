import 'dart:io';

import 'package:placeify_server/src/modules/product/catalog_seed_image_storage.dart';
import 'package:placeify_server/src/shared/server_static_paths.dart';
import 'package:test/test.dart';

import '../../integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Catalog seed image storage', (sessionBuilder, endpoints) {
    test('materializes bundled assets under /uploads/catalog-seed/', () async {
      final session = sessionBuilder.build();
      try {
        final url = await CatalogSeedImageStorage.resolveUrl(
          session,
          'tola_lounge_chair.jpg',
        );
        expect(url, '/uploads/catalog-seed/tola_lounge_chair.jpg');

        final file = ServerStaticPaths.fileFromUrlPath(url);
        expect(file.existsSync(), isTrue);
        expect(file.lengthSync(), greaterThan(0));
      } finally {
        await session.close();
      }
    });
  });

  test('bundled catalog_seed assets exist in the repo', () {
    final candidates = [
      'assets/catalog_seed/tola_lounge_chair.jpg',
      'placeify_server/assets/catalog_seed/tola_lounge_chair.jpg',
    ];
    expect(
      candidates.any((path) => File(path).existsSync()),
      isTrue,
      reason: 'Expected catalog seed assets under assets/catalog_seed/',
    );
  });
}
