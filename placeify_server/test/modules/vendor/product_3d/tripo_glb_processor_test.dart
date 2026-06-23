import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:placeify_server/src/modules/vendor/product_3d/glb_pipeline/furniture_material_profile.dart';
import 'package:placeify_server/src/modules/vendor/product_3d/glb_pipeline/glb_container.dart';
import 'package:placeify_server/src/modules/vendor/product_3d/glb_pipeline/tripo_glb_processor.dart';
import 'package:test/test.dart';

void main() {
  group('FurnitureMaterialProfile', () {
    test('detects fabric from catalog materials', () {
      final profile = FurnitureMaterialProfile.fromCatalogMaterials(
        'Gray fabric upholstery, solid wood legs',
      );
      expect(profile.surfaceType, FurnitureSurfaceType.fabric);
      expect(profile.metallic, 0.0);
      expect(profile.targetRoughness, greaterThan(0.74));
    });

    test('detects wood', () {
      final profile = FurnitureMaterialProfile.fromCatalogMaterials('Oak wood');
      expect(profile.surfaceType, FurnitureSurfaceType.wood);
      expect(profile.targetRoughness, closeTo(0.5, 0.11));
    });
  });

  group('TripoGlbProcessor', () {
    test('converts minimal GLB to PBR metallic-roughness', () {
      final raw = _minimalTexturedGlb();
      final result = TripoGlbProcessor().process(
        raw,
        catalogMaterials: 'Gray fabric',
      );

      expect(result.bytes, isNotEmpty);
      expect(result.materialCount, 1);
      expect(result.generatedNormalMaps, 1);
      expect(result.generatedRoughnessMaps, 1);

      final parsed = GlbContainer.parse(result.bytes);
      final material = parsed.materials().single;
      final pbr = material['pbrMetallicRoughness'] as Map;
      expect(pbr['metallicFactor'], 1.0);
      expect(pbr['roughnessFactor'], 1.0);
      expect(material['normalTexture'], isNotNull);
      expect(pbr['baseColorTexture'], isNotNull);
      expect(pbr['metallicRoughnessTexture'], isNotNull);

      final asset = parsed.json['asset'] as Map;
      expect(asset['generator'], 'Placeify TripoGLBProcessor');
    });
  });
}

/// Tiny textured GLB with a valid 4×4 PNG albedo.
Uint8List _minimalTexturedGlb() {
  final png = img.Image(width: 4, height: 4);
  for (var y = 0; y < 4; y++) {
    for (var x = 0; x < 4; x++) {
      png.setPixelRgb(x, y, 140, 140, 140);
    }
  }
  final pngBytes = Uint8List.fromList(img.encodePng(png));

  final container = GlbContainer(
    json: {
      'asset': {'version': '2.0'},
      'materials': [
        {
          'name': 'TripoMaterial',
          'pbrMetallicRoughness': {
            'baseColorFactor': [0.5, 0.5, 0.5, 1.0],
          },
        },
      ],
      'images': [
        {'mimeType': 'image/png'},
      ],
      'textures': [
        {'source': 0},
      ],
      'buffers': [
        {'byteLength': pngBytes.length},
      ],
      'bufferViews': [
        {
          'buffer': 0,
          'byteOffset': 0,
          'byteLength': pngBytes.length,
        },
      ],
    },
    binary: pngBytes,
  );

  // Wire base color texture on the material.
  final materials = container.materials();
  materials[0]['pbrMetallicRoughness'] = {
    'baseColorTexture': {'index': 0},
    'baseColorFactor': [1.0, 1.0, 1.0, 1.0],
  };
  container.setMaterials(materials);

  final images = container.images();
  images[0]['bufferView'] = 0;
  images[0]['mimeType'] = 'image/png';
  container.setImages(images);

  return container.build();
}
