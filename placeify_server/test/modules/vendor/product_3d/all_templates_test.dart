import 'dart:io';
import 'dart:typed_data';

import 'package:test/test.dart';

import 'package:placeify_server/src/modules/vendor/product_3d/glb_customizer.dart';

void main() {
  final textureBytes = File(
    '../placeify_flutter/assets/images/categories/chair.jpg',
  ).readAsBytesSync();

  for (final name in ['chairs.glb', 'sofas.glb', 'default.glb']) {
    test('customize $name', () {
      final templateBytes = File(
        'web/static/models/templates/$name',
      ).readAsBytesSync();
      final output = GlbCustomizer.customize(
        templateBytes: templateBytes,
        textureJpegBytes: textureBytes,
        widthCm: 70,
        depthCm: 68,
        heightCm: 85,
      );
      expect(output.length, greaterThan(1000));
      final magic =
          ByteData.sublistView(output, 0, 4).getUint32(0, Endian.little);
      expect(magic, 0x46546C67);
    });
  }
}
