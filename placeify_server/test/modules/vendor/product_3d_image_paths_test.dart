import 'package:placeify_server/src/modules/vendor/product_3d/product_3d_image_paths.dart';
import 'package:test/test.dart';

void main() {
  group('Product3dImagePaths', () {
    test('tripoSourceCandidatesForCatalog derives sibling paths', () {
      expect(
        Product3dImagePaths.tripoSourceCandidatesForCatalog(
          '/uploads/1739123456_chair.jpg',
        ),
        [
          '/uploads/1739123456_chair_tripo.jpg',
          '/uploads/1739123456_chair_tripo.jpeg',
          '/uploads/1739123456_chair_tripo.png',
          '/uploads/1739123456_chair_tripo.webp',
        ],
      );
    });

    test('tripoStoragePathForCatalog preserves original extension', () {
      expect(
        Product3dImagePaths.tripoStoragePathForCatalog(
          catalogStoragePath: '/uploads/1739123456_chair.jpg',
          originalExtension: '.png',
        ),
        '/uploads/1739123456_chair_tripo.png',
      );
    });
  });
}
