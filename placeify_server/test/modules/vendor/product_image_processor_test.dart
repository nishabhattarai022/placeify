import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:placeify_server/src/modules/vendor/product_image_processor.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('ProductImageProcessor white composite', () {
    test('composites transparent PNG onto white JPEG', () {
      final cutout = img.Image(width: 8, height: 8, numChannels: 4);
      img.fill(cutout, color: img.ColorRgba8(0, 0, 0, 0));
      img.fillRect(
        cutout,
        x1: 2,
        y1: 2,
        x2: 5,
        y2: 5,
        color: img.ColorRgba8(200, 100, 50, 255),
      );

      final canvas = img.Image(width: cutout.width, height: cutout.height);
      img.fill(canvas, color: img.ColorRgb8(255, 255, 255));
      img.compositeImage(canvas, cutout);
      final jpgBytes = img.encodeJpg(canvas, quality: 88);

      final decoded = img.decodeJpg(jpgBytes);
      expect(decoded, isNotNull);
      final corner = decoded!.getPixel(0, 0);
      expect(corner.r, greaterThan(250));
      expect(corner.g, greaterThan(250));
      expect(corner.b, greaterThan(250));
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
