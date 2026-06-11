import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

/// Reads, scales, and textures glTF binary (GLB) furniture templates.
class GlbCustomizer {
  GlbCustomizer._();

  static Uint8List customize({
    required Uint8List templateBytes,
    required Uint8List textureJpegBytes,
    required double widthCm,
    required double depthCm,
    required double heightCm,
  }) {
    final parsed = _GlbDocument.parse(templateBytes);
    final bounds = parsed.computeBounds();

    final targetW = widthCm / 100;
    final targetD = depthCm / 100;
    final targetH = heightCm / 100;

    final scaleX = bounds.width > 0 ? targetW / bounds.width : 1.0;
    final scaleY = bounds.height > 0 ? targetH / bounds.height : 1.0;
    final scaleZ = bounds.depth > 0 ? targetD / bounds.depth : 1.0;

    parsed.applyRootScale([scaleX, scaleY, scaleZ]);
    parsed.applyProductTexture(textureJpegBytes);
    return parsed.encode();
  }
}

class _Bounds {
  const _Bounds({
    required this.minX,
    required this.minY,
    required this.minZ,
    required this.maxX,
    required this.maxY,
    required this.maxZ,
  });

  final double minX;
  final double minY;
  final double minZ;
  final double maxX;
  final double maxY;
  final double maxZ;

  double get width => maxX - minX;
  double get height => maxY - minY;
  double get depth => maxZ - minZ;
}

class _GlbDocument {
  _GlbDocument(this.json, this.bin);

  final Map<String, dynamic> json;
  Uint8List bin;

  static _GlbDocument parse(Uint8List bytes) {
    if (bytes.length < 20) {
      throw FormatException('GLB too small (${bytes.length} bytes)');
    }
    final header = ByteData.sublistView(bytes, 0, 12);
    final magic = header.getUint32(0, Endian.little);
    if (magic != 0x46546C67) {
      throw FormatException('Not a GLB file');
    }
    final version = header.getUint32(4, Endian.little);
    if (version != 2) {
      throw FormatException('Unsupported GLB version $version');
    }

    var offset = 12;
    Map<String, dynamic>? jsonMap;
    Uint8List? binChunk;

    while (offset + 8 <= bytes.length) {
      final chunkHeader = ByteData.sublistView(bytes, offset, offset + 8);
      final chunkLength = chunkHeader.getUint32(0, Endian.little);
      final chunkType = chunkHeader.getUint32(4, Endian.little);
      offset += 8;
      final chunkData = bytes.sublist(offset, offset + chunkLength);
      offset += chunkLength;

      if (chunkType == 0x4E4F534A) {
        jsonMap = jsonDecode(utf8.decode(chunkData)) as Map<String, dynamic>;
      } else if (chunkType == 0x004E4942) {
        binChunk = Uint8List.fromList(chunkData);
      }
    }

    if (jsonMap == null) {
      throw FormatException('GLB missing JSON chunk');
    }
    return _GlbDocument(jsonMap, binChunk ?? Uint8List(0));
  }

  _Bounds computeBounds() {
    var minX = double.infinity;
    var minY = double.infinity;
    var minZ = double.infinity;
    var maxX = -double.infinity;
    var maxY = -double.infinity;
    var maxZ = -double.infinity;

    final meshes = json['meshes'] as List<dynamic>? ?? [];
    final accessors = json['accessors'] as List<dynamic>? ?? [];
    final bufferViews = json['bufferViews'] as List<dynamic>? ?? [];

    for (final mesh in meshes) {
      final primitives = (mesh as Map<String, dynamic>)['primitives'] as List?;
      if (primitives == null) continue;
      for (final primitive in primitives) {
        final attrs = (primitive as Map<String, dynamic>)['attributes']
            as Map<String, dynamic>?;
        final positionIndex = attrs?['POSITION'];
        if (positionIndex == null) continue;

        final accessor = accessors[positionIndex as int] as Map<String, dynamic>;
        final viewIndex = accessor['bufferView'] as int;
        final view = bufferViews[viewIndex] as Map<String, dynamic>;
        final byteOffset = (view['byteOffset'] as int?) ?? 0;
        final accessorOffset = (accessor['byteOffset'] as int?) ?? 0;
        final count = accessor['count'] as int;
        final start = byteOffset + accessorOffset;

        for (var i = 0; i < count; i++) {
          final base = start + i * 12;
          if (base + 12 > bin.length) break;
          final x = ByteData.sublistView(bin, base, base + 4)
              .getFloat32(0, Endian.little);
          final y = ByteData.sublistView(bin, base + 4, base + 8)
              .getFloat32(0, Endian.little);
          final z = ByteData.sublistView(bin, base + 8, base + 12)
              .getFloat32(0, Endian.little);
          minX = math.min(minX, x);
          minY = math.min(minY, y);
          minZ = math.min(minZ, z);
          maxX = math.max(maxX, x);
          maxY = math.max(maxY, y);
          maxZ = math.max(maxZ, z);
        }
      }
    }

    if (!minX.isFinite) {
      return const _Bounds(
        minX: 0,
        minY: 0,
        minZ: 0,
        maxX: 0.6,
        maxY: 0.85,
        maxZ: 0.6,
      );
    }

    return _Bounds(
      minX: minX,
      minY: minY,
      minZ: minZ,
      maxX: maxX,
      maxY: maxY,
      maxZ: maxZ,
    );
  }

  void applyRootScale(List<double> scale) {
    final scenes = json['scenes'] as List<dynamic>?;
    if (scenes == null || scenes.isEmpty) return;

    final scene = scenes[0] as Map<String, dynamic>;
    final rootNodes = (scene['nodes'] as List<dynamic>?)?.cast<int>() ?? [];
    if (rootNodes.isEmpty) return;

    final nodes = (json['nodes'] as List<dynamic>?) ?? [];
    final scaleNodeIndex = nodes.length;
    nodes.add({
      'name': 'placeify_scaled_root',
      'children': rootNodes,
      'scale': scale,
    });
    json['nodes'] = nodes;
    scene['nodes'] = [scaleNodeIndex];
  }

  void applyProductTexture(Uint8List textureBytes) {
    final buffers = (json['buffers'] as List<dynamic>?) ?? [];
    final bufferViews = (json['bufferViews'] as List<dynamic>?) ?? [];
    final images = (json['images'] as List<dynamic>?) ?? [];
    final textures = (json['textures'] as List<dynamic>?) ?? [];
    final materials = (json['materials'] as List<dynamic>?) ?? [];
    final samplers = (json['samplers'] as List<dynamic>?) ?? [];

    if (samplers.isEmpty) {
      samplers.add({
        'magFilter': 9729,
        'minFilter': 9987,
        'wrapS': 10497,
        'wrapT': 10497,
      });
      json['samplers'] = samplers;
    }

    final alignedLength = _align4(textureBytes.length);
    final paddedTexture = Uint8List(alignedLength);
    paddedTexture.setRange(0, textureBytes.length, textureBytes);

    final binBuilder = BytesBuilder(copy: false);
    if (bin.isNotEmpty) {
      binBuilder.add(bin);
    }
    final textureOffset = _align4(binBuilder.length);
    if (textureOffset > binBuilder.length) {
      binBuilder.add(Uint8List(textureOffset - binBuilder.length));
    }
    binBuilder.add(paddedTexture);
    bin = binBuilder.toBytes();

    final textureBufferViewIndex = bufferViews.length;
    bufferViews.add({
      'buffer': 0,
      'byteOffset': textureOffset,
      'byteLength': textureBytes.length,
    });

    if (buffers.isEmpty) {
      buffers.add({'byteLength': bin.length});
    } else {
      (buffers[0] as Map<String, dynamic>)['byteLength'] = bin.length;
    }

    final imageIndex = images.length;
    images.add({
      'mimeType': 'image/jpeg',
      'bufferView': textureBufferViewIndex,
    });

    final textureIndex = textures.length;
    textures.add({
      'sampler': 0,
      'source': imageIndex,
    });

    json['buffers'] = buffers;
    json['bufferViews'] = bufferViews;
    json['images'] = images;
    json['textures'] = textures;

    if (materials.isEmpty) return;

    final targetMaterial = _primaryMaterialIndex(materials);
    final material = Map<String, dynamic>.from(
      materials[targetMaterial] as Map<String, dynamic>,
    );
    final pbr = Map<String, dynamic>.from(
      (material['pbrMetallicRoughness'] as Map<String, dynamic>?) ?? {},
    );
    pbr['baseColorTexture'] = {'index': textureIndex};
    pbr['metallicFactor'] = 0;
    pbr['roughnessFactor'] = 0.85;
    pbr.remove('baseColorFactor');
    material['pbrMetallicRoughness'] = pbr;
    material.remove('normalTexture');
    material.remove('occlusionTexture');
    materials[targetMaterial] = material;
    json['materials'] = materials;
  }

  int _primaryMaterialIndex(List<dynamic> materials) {
    for (var i = 0; i < materials.length; i++) {
      final name =
          ((materials[i] as Map<String, dynamic>)['name'] as String? ?? '')
              .toLowerCase();
      if (name.contains('fabric') ||
          name.contains('uphol') ||
          name.contains('cushion') ||
          name.contains('seat')) {
        return i;
      }
    }
    return 0;
  }

  Uint8List encode() {
    final jsonBytes = utf8.encode(jsonEncode(json));
    final paddedJson = Uint8List(_align4(jsonBytes.length));
    paddedJson.setRange(0, jsonBytes.length, jsonBytes);
    for (var i = jsonBytes.length; i < paddedJson.length; i++) {
      paddedJson[i] = 0x20;
    }

    final paddedBin = Uint8List(_align4(bin.length));
    paddedBin.setRange(0, bin.length, bin);

    final totalLength = 12 + 8 + paddedJson.length + 8 + paddedBin.length;
    final output = BytesBuilder();
    final header = ByteData(12);
    header.setUint32(0, 0x46546C67, Endian.little);
    header.setUint32(4, 2, Endian.little);
    header.setUint32(8, totalLength, Endian.little);
    output.add(header.buffer.asUint8List());

    final jsonHeader = ByteData(8);
    jsonHeader.setUint32(0, paddedJson.length, Endian.little);
    jsonHeader.setUint32(4, 0x4E4F534A, Endian.little);
    output
      ..add(jsonHeader.buffer.asUint8List())
      ..add(paddedJson);

    if (paddedBin.isNotEmpty) {
      final binHeader = ByteData(8);
      binHeader.setUint32(0, paddedBin.length, Endian.little);
      binHeader.setUint32(4, 0x004E4942, Endian.little);
      output
        ..add(binHeader.buffer.asUint8List())
        ..add(paddedBin);
    }

    return output.toBytes();
  }

  static int _align4(int value) => (value + 3) & ~3;
}
