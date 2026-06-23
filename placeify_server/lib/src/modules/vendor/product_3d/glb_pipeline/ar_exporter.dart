import 'dart:typed_data';

import 'glb_container.dart';

/// Final AR export pass — ensures color management metadata is correct.
final class ArExporter {
  const ArExporter();

  Uint8List export(GlbContainer container) {
    _ensureAssetMetadata(container);
    _tagTextureColorSpaces(container);
    return container.build();
  }

  void _ensureAssetMetadata(GlbContainer container) {
    final asset = Map<String, dynamic>.from(
      container.json['asset'] as Map? ?? {},
    );
    asset['generator'] = 'Placeify TripoGLBProcessor';
    asset['version'] = '2.0';
    container.json['asset'] = asset;
  }

  /// Documents intended color spaces for downstream renderers.
  ///
  /// glTF 2.0: baseColor is sRGB; metallicRoughness and normal are linear.
  void _tagTextureColorSpaces(GlbContainer container) {
    final textures = container.textures();
    final materials = container.materials();

    final srgbTextureIndices = <int>{};
    final linearTextureIndices = <int>{};

    for (final material in materials) {
      final pbr = material['pbrMetallicRoughness'];
      if (pbr is Map) {
        final base = pbr['baseColorTexture'];
        if (base is Map && base['index'] is int) {
          srgbTextureIndices.add(base['index'] as int);
        }
        final mr = pbr['metallicRoughnessTexture'];
        if (mr is Map && mr['index'] is int) {
          linearTextureIndices.add(mr['index'] as int);
        }
      }
      final normal = material['normalTexture'];
      if (normal is Map && normal['index'] is int) {
        linearTextureIndices.add(normal['index'] as int);
      }
    }

    for (var i = 0; i < textures.length; i++) {
      final texture = Map<String, dynamic>.from(textures[i]);
      if (srgbTextureIndices.contains(i)) {
        texture['name'] = 'baseColor_sRGB';
      } else if (linearTextureIndices.contains(i)) {
        texture['name'] = 'linearData';
      }
      textures[i] = texture;
    }
    container.setTextures(textures);
  }
}
