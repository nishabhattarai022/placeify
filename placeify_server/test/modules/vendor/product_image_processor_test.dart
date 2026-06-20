import 'dart:typed_data';

import 'package:placeify_server/src/modules/vendor/product_image_processor.dart';
import 'package:test/test.dart';

void main() {
  group('ProcessedProductImage', () {
    test('stores extension and flag', () {
      final result = ProcessedProductImage(
        bytes: Uint8List(0),
        extension: '.jpg',
        backgroundRemoved: true,
      );
      expect(result.extension, '.jpg');
      expect(result.backgroundRemoved, isTrue);
    });
  });
}
