import 'dart:convert';
import 'dart:typed_data';

import 'package:test/test.dart';

import 'package:placeify_server/src/modules/vendor/product_3d/glb_material_patcher.dart';

void main() {
  group('GlbMaterialPatcher', () {
    test('patches material roughness and metalness in JSON chunk', () {
      final glb = _minimalGlb(
        materials: [
          {
            'name': 'fabric_upholstery',
            'pbrMetallicRoughness': {
              'baseColorTexture': {'index': 0},
              'metallicFactor': 1.0,
              'roughnessFactor': 0.1,
            },
            'emissiveFactor': [0.5, 0.5, 0.5],
          },
          {
            'name': 'metal_leg',
            'pbrMetallicRoughness': {
              'metallicFactor': 0.9,
              'roughnessFactor': 0.2,
            },
          },
        ],
      );

      final patched = const GlbMaterialPatcher().patchMaterials(glb);
      expect(patched, isNot(same(glb)));

      final json = _readGlbJson(patched);
      final materials = json['materials'] as List<dynamic>;

      final fabric = materials[0] as Map<String, dynamic>;
      final fabricPbr = fabric['pbrMetallicRoughness'] as Map<String, dynamic>;
      expect(fabricPbr['roughnessFactor'], 0.85);
      expect(fabricPbr['metallicFactor'], 0.0);
      expect(fabricPbr['baseColorTexture'], isNotNull);
      expect(fabric['emissiveFactor'], [0.0, 0.0, 0.0]);

      final metal = materials[1] as Map<String, dynamic>;
      final metalPbr = metal['pbrMetallicRoughness'] as Map<String, dynamic>;
      expect(metalPbr['roughnessFactor'], 0.4);
      expect(metalPbr['metallicFactor'], 0.35);
    });

    test('returns original bytes when GLB is invalid', () {
      final invalid = Uint8List.fromList([1, 2, 3]);
      final patched = const GlbMaterialPatcher().patchMaterials(invalid);
      expect(patched, same(invalid));
    });
  });
}

Uint8List _minimalGlb({required List<Map<String, dynamic>> materials}) {
  final jsonBytes = utf8.encode(
    jsonEncode({
      'asset': {'version': '2.0'},
      'materials': materials,
    }),
  );
  final paddedJson = [...jsonBytes];
  while (paddedJson.length % 4 != 0) {
    paddedJson.add(0x20);
  }

  final binChunk = Uint8List.fromList([0, 1, 2, 3]);
  final totalLength = 12 + 8 + paddedJson.length + 8 + binChunk.length;
  final output = Uint8List(totalLength);
  final out = ByteData.sublistView(output);

  out.setUint32(0, 0x46546C67, Endian.little);
  out.setUint32(4, 2, Endian.little);
  out.setUint32(8, totalLength, Endian.little);

  var offset = 12;
  offset = _writeChunk(output, offset, Uint8List.fromList(paddedJson), 0x4E4F534A);
  _writeChunk(output, offset, binChunk, 0x004E4942);

  return output;
}

int _writeChunk(Uint8List output, int offset, Uint8List data, int type) {
  final header = ByteData.sublistView(output, offset, offset + 8);
  header.setUint32(0, data.length, Endian.little);
  header.setUint32(4, type, Endian.little);
  output.setRange(offset + 8, offset + 8 + data.length, data);
  return offset + 8 + data.length;
}

Map<String, dynamic> _readGlbJson(Uint8List glb) {
  final chunkLength = ByteData.sublistView(glb, 12, 16).getUint32(0, Endian.little);
  final jsonBytes = glb.sublist(20, 20 + chunkLength);
  return jsonDecode(utf8.decode(jsonBytes).trimRight()) as Map<String, dynamic>;
}
