import 'dart:convert';
import 'dart:typed_data';

/// Patches Tripo GLB materials for matte furniture rendering while keeping baked textures.
class GlbMaterialPatcher {
  const GlbMaterialPatcher();

  static const _magic = 0x46546C67; // "glTF"
  static const _version = 2;
  static const _jsonChunkType = 0x4E4F534A; // "JSON"
  static const _binChunkType = 0x004E4942; // "BIN\0"

  static final _metalNamePattern = RegExp(
    r'metal|steel|chrome|brass|iron|aluminum|aluminium|\bleg\b|\bfoot\b',
    caseSensitive: false,
  );

  /// Overrides roughness/metalness in the embedded glTF JSON chunk.
  ///
  /// Returns [glbBytes] unchanged when parsing or patching fails.
  Uint8List patchMaterials(
    Uint8List glbBytes, {
    double roughness = 0.85,
    double metallic = 0.0,
  }) {
    try {
      return _patch(
        glbBytes,
        defaultRoughness: roughness,
        defaultMetallic: metallic,
      );
    } catch (_) {
      return glbBytes;
    }
  }

  Uint8List _patch(
    Uint8List glbBytes, {
    required double defaultRoughness,
    required double defaultMetallic,
  }) {
    if (glbBytes.length < 12) {
      throw const FormatException('GLB file is too short');
    }

    final header = ByteData.sublistView(glbBytes, 0, 12);
    if (header.getUint32(0, Endian.little) != _magic) {
      throw const FormatException('Invalid GLB magic');
    }
    if (header.getUint32(4, Endian.little) != _version) {
      throw const FormatException('Unsupported GLB version');
    }

    var offset = 12;
    Uint8List? jsonChunk;
    Uint8List? binChunk;

    while (offset + 8 <= glbBytes.length) {
      final chunkHeader = ByteData.sublistView(glbBytes, offset, offset + 8);
      final chunkLength = chunkHeader.getUint32(0, Endian.little);
      final chunkType = chunkHeader.getUint32(4, Endian.little);
      offset += 8;

      if (chunkLength < 0 || offset + chunkLength > glbBytes.length) {
        throw const FormatException('Invalid GLB chunk length');
      }

      final chunkData = glbBytes.sublist(offset, offset + chunkLength);
      offset += chunkLength;

      if (chunkType == _jsonChunkType) {
        jsonChunk = chunkData;
      } else if (chunkType == _binChunkType) {
        binChunk = chunkData;
      }
    }

    if (jsonChunk == null || binChunk == null) {
      throw const FormatException('GLB is missing JSON or BIN chunk');
    }

    final jsonText = utf8.decode(jsonChunk).trimRight();
    final root = jsonDecode(jsonText);
    if (root is! Map<String, dynamic>) {
      throw const FormatException('GLB JSON root must be an object');
    }

    final materials = root['materials'];
    if (materials is List) {
      for (var i = 0; i < materials.length; i++) {
        final material = materials[i];
        if (material is Map<String, dynamic>) {
          materials[i] = _patchMaterial(
            material,
            defaultRoughness: defaultRoughness,
            defaultMetallic: defaultMetallic,
          );
        } else if (material is Map) {
          materials[i] = _patchMaterial(
            Map<String, dynamic>.from(material),
            defaultRoughness: defaultRoughness,
            defaultMetallic: defaultMetallic,
          );
        }
      }
    }

    final encodedJson = utf8.encode(jsonEncode(root));
    final paddedJson = _padTo4ByteBoundary(encodedJson);
    final jsonChunkBytes = Uint8List.fromList(paddedJson);
    final binChunkBytes = Uint8List.fromList(binChunk);

    final totalLength =
        12 + 8 + jsonChunkBytes.length + 8 + binChunkBytes.length;
    final output = Uint8List(totalLength);
    final out = ByteData.sublistView(output);

    out.setUint32(0, _magic, Endian.little);
    out.setUint32(4, _version, Endian.little);
    out.setUint32(8, totalLength, Endian.little);

    var writeOffset = 12;
    writeOffset = _writeChunk(
      output,
      writeOffset,
      jsonChunkBytes,
      _jsonChunkType,
    );
    _writeChunk(output, writeOffset, binChunkBytes, _binChunkType);

    return output;
  }

  Map<String, dynamic> _patchMaterial(
    Map<String, dynamic> material, {
    required double defaultRoughness,
    required double defaultMetallic,
  }) {
    final name = material['name']?.toString().toLowerCase() ?? '';
    final isMetal = _metalNamePattern.hasMatch(name);

    final roughness = isMetal ? 0.4 : defaultRoughness;
    final metallic = isMetal ? 0.35 : defaultMetallic;

    final pbr = _materialMap(material['pbrMetallicRoughness']);
    pbr['roughnessFactor'] = roughness;
    pbr['metallicFactor'] = metallic;
    material['pbrMetallicRoughness'] = pbr;

    if (material.containsKey('emissiveFactor')) {
      material['emissiveFactor'] = [0.0, 0.0, 0.0];
    }

    return material;
  }

  Map<String, dynamic> _materialMap(Object? value) {
    if (value is Map<String, dynamic>) return Map<String, dynamic>.from(value);
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  List<int> _padTo4ByteBoundary(List<int> bytes) {
    final remainder = bytes.length % 4;
    if (remainder == 0) return bytes;
    return [...bytes, ...List.filled(4 - remainder, 0x20)];
  }

  int _writeChunk(
    Uint8List output,
    int offset,
    Uint8List chunkData,
    int chunkType,
  ) {
    final header = ByteData.sublistView(output, offset, offset + 8);
    header.setUint32(0, chunkData.length, Endian.little);
    header.setUint32(4, chunkType, Endian.little);
    output.setRange(offset + 8, offset + 8 + chunkData.length, chunkData);
    return offset + 8 + chunkData.length;
  }
}
