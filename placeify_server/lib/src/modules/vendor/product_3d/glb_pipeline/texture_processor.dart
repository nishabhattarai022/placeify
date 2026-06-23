import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import 'furniture_material_profile.dart';
import 'glb_container.dart';

/// Generates missing PBR maps and compresses textures for AR.
final class TextureProcessor {
  TextureProcessor({this.maxTextureSize = 2048});

  final int maxTextureSize;

  /// Per-material generated texture indices.
  final Map<int, int> generatedNormals = {};
  final Map<int, int> generatedMetallicRoughness = {};

  void processAll(GlbContainer container, FurnitureMaterialProfile profile) {
    generatedNormals.clear();
    generatedMetallicRoughness.clear();

    final materials = container.materials();
    for (var materialIndex = 0; materialIndex < materials.length; materialIndex++) {
      _processMaterial(container, materialIndex, profile);
    }
  }

  void _processMaterial(
    GlbContainer container,
    int materialIndex,
    FurnitureMaterialProfile profile,
  ) {
    final material = container.materials()[materialIndex];
    final pbr = material['pbrMetallicRoughness'];
    if (pbr is! Map) return;

    final baseColorImage = _resolveBaseColorImage(container, pbr);
    if (baseColorImage == null) return;

    final resized = _resizeIfNeeded(baseColorImage);
    final recompressed = _encodeJpeg(resized, quality: 88);

    final baseColorImageIndex = container.addImageFromBytes(
      recompressed,
      mimeType: 'image/jpeg',
    );
    final baseColorTextureIndex = container.addTexture(imageIndex: baseColorImageIndex);
    pbr['baseColorTexture'] = {'index': baseColorTextureIndex};

    final hasNormal = material['normalTexture'] != null;
    if (!hasNormal) {
      final normalBytes = _generateNormalMap(resized);
      final normalImageIndex = container.addImageFromBytes(
        normalBytes,
        mimeType: 'image/png',
      );
      final normalTextureIndex = container.addTexture(imageIndex: normalImageIndex);
      generatedNormals[materialIndex] = normalTextureIndex;
    }

    final hasMr = pbr['metallicRoughnessTexture'] != null;
    if (!hasMr) {
      final mrBytes = _generateMetallicRoughnessMap(resized, profile);
      final mrImageIndex = container.addImageFromBytes(
        mrBytes,
        mimeType: 'image/png',
      );
      final mrTextureIndex = container.addTexture(imageIndex: mrImageIndex);
      generatedMetallicRoughness[materialIndex] = mrTextureIndex;
    }

    final materials = container.materials();
    materials[materialIndex] = material;
    container.setMaterials(materials);
  }

  img.Image? _resolveBaseColorImage(GlbContainer container, Map pbr) {
    final baseTex = pbr['baseColorTexture'];
    if (baseTex is Map) {
      final texIndex = baseTex['index'] as int?;
      if (texIndex != null) {
        final imageIndex = _textureSourceIndex(container, texIndex);
        if (imageIndex != null) {
          return _decodeImage(container.readImageBytes(imageIndex));
        }
      }
    }

    // Fallback: first embedded image in the file.
    if (container.images().isNotEmpty) {
      return _decodeImage(container.readImageBytes(0));
    }
    return null;
  }

  int? _textureSourceIndex(GlbContainer container, int textureIndex) {
    final textures = container.textures();
    if (textureIndex < 0 || textureIndex >= textures.length) return null;
    return textures[textureIndex]['source'] as int?;
  }

  img.Image? _decodeImage(Uint8List bytes) {
    try {
      return img.decodeImage(bytes);
    } on Object {
      return null;
    }
  }

  img.Image _resizeIfNeeded(img.Image source) {
    final longest = math.max(source.width, source.height);
    if (longest <= maxTextureSize) return source;
    final scale = maxTextureSize / longest;
    return img.copyResize(
      source,
      width: (source.width * scale).round(),
      height: (source.height * scale).round(),
      interpolation: img.Interpolation.linear,
    );
  }

  Uint8List _encodeJpeg(img.Image image, {required int quality}) {
    return Uint8List.fromList(img.encodeJpg(image, quality: quality));
  }

  /// Tangent-space normal map derived from albedo luminance (fabric weave detail).
  Uint8List _generateNormalMap(img.Image albedo) {
    final width = albedo.width;
    final height = albedo.height;
    final heightMap = Float32List(width * height);

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final pixel = albedo.getPixel(x, y);
        heightMap[y * width + x] =
            (0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b) / 255.0;
      }
    }

    // Light blur to reduce noise before normal extraction.
    _boxBlur(heightMap, width, height, radius: 1);

    final normal = img.Image(width: width, height: height, numChannels: 3);
    const strength = 2.5;

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final left = heightMap[y * width + (x - 1).clamp(0, width - 1)];
        final right = heightMap[y * width + (x + 1).clamp(0, width - 1)];
        final up = heightMap[(y - 1).clamp(0, height - 1) * width + x];
        final down = heightMap[(y + 1).clamp(0, height - 1) * width + x];

        var nx = (left - right) * strength;
        var ny = (up - down) * strength;
        var nz = 1.0;

        final length = math.sqrt(nx * nx + ny * ny + nz * nz);
        nx /= length;
        ny /= length;
        nz /= length;

        normal.setPixelRgb(
          x,
          y,
          ((nx * 0.5 + 0.5) * 255).round().clamp(0, 255),
          ((ny * 0.5 + 0.5) * 255).round().clamp(0, 255),
          ((nz * 0.5 + 0.5) * 255).round().clamp(0, 255),
        );
      }
    }

    return Uint8List.fromList(img.encodePng(normal));
  }

  /// glTF metallic-roughness: R=metallic, G=roughness (linear).
  Uint8List _generateMetallicRoughnessMap(
    img.Image albedo,
    FurnitureMaterialProfile profile,
  ) {
    final width = albedo.width;
    final height = albedo.height;
    final mr = img.Image(width: width, height: height, numChannels: 3);

    final baseRoughness = profile.targetRoughness;
    final metallicByte = (profile.metallic * 255).round().clamp(0, 255);

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final pixel = albedo.getPixel(x, y);
        final lum = (0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b) / 255.0;
        // Subtle roughness variation from luminance — avoids flat painted look.
        final variation = (lum - 0.5) * 0.08;
        final roughness =
            (baseRoughness + variation).clamp(profile.roughnessMin, profile.roughnessMax);
        final roughnessByte = (roughness * 255).round().clamp(0, 255);
        mr.setPixelRgb(x, y, metallicByte, roughnessByte, 0);
      }
    }

    return Uint8List.fromList(img.encodePng(mr));
  }

  void _boxBlur(Float32List data, int width, int height, {required int radius}) {
    if (radius <= 0) return;
    final copy = Float32List.fromList(data);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        var sum = 0.0;
        var count = 0;
        for (var dy = -radius; dy <= radius; dy++) {
          for (var dx = -radius; dx <= radius; dx++) {
            final nx = (x + dx).clamp(0, width - 1);
            final ny = (y + dy).clamp(0, height - 1);
            sum += copy[ny * width + nx];
            count++;
          }
        }
        data[y * width + x] = sum / count;
      }
    }
  }
}
