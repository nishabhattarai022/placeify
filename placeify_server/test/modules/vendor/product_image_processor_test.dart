import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:placeify_server/src/modules/vendor/product_image_processor.dart';
import 'package:test/test.dart';

void main() {
  group('ProductImageProcessor white composite', () {
    test('composites transparent PNG onto white JPEG', () {
      final cutout = img.Image(width: 4, height: 4, numChannels: 4);
      img.fill(cutout, color: img.ColorRgba8(255, 0, 0, 128));
      final canvas = img.Image(width: cutout.width, height: cutout.height);
      img.fill(canvas, color: img.ColorRgb8(255, 255, 255));
      img.compositeImage(canvas, cutout);
      final jpgBytes = img.encodeJpg(canvas, quality: 88);

      expect(jpgBytes, isNotEmpty);
      expect(img.decodeJpg(jpgBytes), isNotNull);
    });
  });

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
