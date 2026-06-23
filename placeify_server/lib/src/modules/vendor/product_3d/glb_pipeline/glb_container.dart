import 'dart:convert';
import 'dart:typed_data';

/// Parsed GLB container (glTF 2.0 binary).
final class GlbContainer {
  GlbContainer({
    required this.json,
    required this.binary,
  });

  final Map<String, dynamic> json;
  Uint8List binary;

  static const _magic = 0x46546C67; // 'glTF'
  static const _version = 2;
  static const _jsonChunkType = 0x4E4F534A; // 'JSON'
  static const _binChunkType = 0x004E4942; // 'BIN\0'

  static GlbContainer parse(Uint8List bytes) {
    if (bytes.length < 12) {
      throw FormatException('GLB file too small (${bytes.length} bytes).');
    }

    final header = ByteData.sublistView(bytes, 0, 12);
    if (header.getUint32(0, Endian.little) != _magic) {
      throw FormatException('Invalid GLB magic header.');
    }
    if (header.getUint32(4, Endian.little) != _version) {
      throw FormatException('Unsupported GLB version.');
    }

    var offset = 12;
    Map<String, dynamic>? jsonMap;
    Uint8List bin = Uint8List(0);

    while (offset + 8 <= bytes.length) {
      final chunkHeader = ByteData.sublistView(bytes, offset, offset + 8);
      final chunkLength = chunkHeader.getUint32(0, Endian.little);
      final chunkType = chunkHeader.getUint32(4, Endian.little);
      offset += 8;

      if (offset + chunkLength > bytes.length) {
        throw FormatException('GLB chunk exceeds file length.');
      }

      final chunkData = bytes.sublist(offset, offset + chunkLength);
      offset += chunkLength;
      final padding = (4 - (chunkLength % 4)) % 4;
      offset += padding;

      if (chunkType == _jsonChunkType) {
        final decoded = jsonDecode(utf8.decode(chunkData));
        if (decoded is! Map<String, dynamic>) {
          throw FormatException('GLB JSON chunk is not an object.');
        }
        jsonMap = decoded;
      } else if (chunkType == _binChunkType) {
        bin = Uint8List.fromList(chunkData);
      }
    }

    if (jsonMap == null) {
      throw FormatException('GLB missing JSON chunk.');
    }

    return GlbContainer(json: jsonMap, binary: bin);
  }

  Uint8List build() {
    final jsonBytes = utf8.encode(jsonEncode(json));
    final jsonPadded = _padTo4(jsonBytes);
    final binPadded = _padTo4(binary);

    final totalLength = 12 + 8 + jsonPadded.length + 8 + binPadded.length;
    final out = BytesBuilder(copy: false);
    final header = ByteData(12);
    header.setUint32(0, _magic, Endian.little);
    header.setUint32(4, _version, Endian.little);
    header.setUint32(8, totalLength, Endian.little);
    out.add(header.buffer.asUint8List());

    out.add(_chunkHeader(jsonPadded.length, _jsonChunkType));
    out.add(jsonPadded);

    out.add(_chunkHeader(binPadded.length, _binChunkType));
    out.add(binPadded);

    return out.takeBytes();
  }

  List<Map<String, dynamic>> materials() {
    final raw = json['materials'];
    if (raw is! List) return [];
    return raw.map((m) => Map<String, dynamic>.from(m as Map)).toList();
  }

  void setMaterials(List<Map<String, dynamic>> materials) {
    json['materials'] = materials;
  }

  List<Map<String, dynamic>> images() {
    final raw = json['images'];
    if (raw is! List) return [];
    return raw.map((m) => Map<String, dynamic>.from(m as Map)).toList();
  }

  void setImages(List<Map<String, dynamic>> images) {
    json['images'] = images;
  }

  List<Map<String, dynamic>> textures() {
    final raw = json['textures'];
    if (raw is! List) return [];
    return raw.map((m) => Map<String, dynamic>.from(m as Map)).toList();
  }

  void setTextures(List<Map<String, dynamic>> textures) {
    json['textures'] = textures;
  }

  List<Map<String, dynamic>> accessors() {
    final raw = json['accessors'];
    if (raw is! List) return [];
    return raw.map((m) => Map<String, dynamic>.from(m as Map)).toList();
  }

  void setAccessors(List<Map<String, dynamic>> accessors) {
    json['accessors'] = accessors;
  }

  List<Map<String, dynamic>> bufferViews() {
    final raw = json['bufferViews'];
    if (raw is! List) return [];
    return raw.map((m) => Map<String, dynamic>.from(m as Map)).toList();
  }

  void setBufferViews(List<Map<String, dynamic>> bufferViews) {
    json['bufferViews'] = bufferViews;
  }

  List<Map<String, dynamic>> buffers() {
    final raw = json['buffers'];
    if (raw is! List) return [];
    return raw.map((m) => Map<String, dynamic>.from(m as Map)).toList();
  }

  void setBuffers(List<Map<String, dynamic>> buffers) {
    json['buffers'] = buffers;
  }

  Map<String, dynamic> extensionsUsed() {
    final raw = json['extensionsUsed'];
    if (raw is! List) return {};
    return {for (final e in raw) e.toString(): true};
  }

  void addExtensionUsed(String name) {
    final used = extensionsUsed();
    used[name] = true;
    json['extensionsUsed'] = used.keys.toList();
  }

  void removeExtensionUsed(String name) {
    final used = extensionsUsed();
    used.remove(name);
    if (used.isEmpty) {
      json.remove('extensionsUsed');
    } else {
      json['extensionsUsed'] = used.keys.toList();
    }
  }

  Uint8List readImageBytes(int imageIndex) {
    final images = this.images();
    if (imageIndex < 0 || imageIndex >= images.length) {
      throw RangeError('Image index $imageIndex out of range.');
    }
    final image = images[imageIndex];

    final bufferViewIndex = image['bufferView'] as int?;
    if (bufferViewIndex != null) {
      return _readBufferView(bufferViewIndex);
    }

    final uri = image['uri'] as String?;
    if (uri != null && uri.startsWith('data:')) {
      final comma = uri.indexOf(',');
      if (comma == -1) throw FormatException('Invalid data URI in image.');
      return base64Decode(uri.substring(comma + 1));
    }

    throw FormatException('Image $imageIndex has no bufferView or data URI.');
  }

  Uint8List _readBufferView(int bufferViewIndex) {
    final views = bufferViews();
    if (bufferViewIndex < 0 || bufferViewIndex >= views.length) {
      throw RangeError('BufferView $bufferViewIndex out of range.');
    }
    final view = views[bufferViewIndex];
    final byteOffset = view['byteOffset'] as int? ?? 0;
    final byteLength = view['byteLength'] as int;
    return binary.sublist(byteOffset, byteOffset + byteLength);
  }

  /// Appends [data] to the BIN chunk and returns the new bufferView index.
  int appendBinary(Uint8List data) {
    final views = bufferViews();
    final byteOffset = binary.length;
    final newBinary = Uint8List(byteOffset + data.length);
    newBinary.setRange(0, byteOffset, binary);
    newBinary.setRange(byteOffset, byteOffset + data.length, data);
    binary = newBinary;

    final bufferViewIndex = views.length;
    views.add({
      'buffer': 0,
      'byteOffset': byteOffset,
      'byteLength': data.length,
    });
    setBufferViews(views);

    final buffers = this.buffers();
    if (buffers.isEmpty) {
      buffers.add({'byteLength': binary.length});
    } else {
      buffers[0] = {'byteLength': binary.length};
    }
    setBuffers(buffers);

    return bufferViewIndex;
  }

  int addImageFromBytes(Uint8List imageBytes, {required String mimeType}) {
    final bufferViewIndex = appendBinary(imageBytes);
    final images = this.images();
    final imageIndex = images.length;
    images.add({
      'bufferView': bufferViewIndex,
      'mimeType': mimeType,
    });
    setImages(images);
    return imageIndex;
  }

  int addTexture({required int imageIndex}) {
    final textures = this.textures();
    final textureIndex = textures.length;
    textures.add({'source': imageIndex});
    setTextures(textures);
    return textureIndex;
  }

  static Uint8List _padTo4(List<int> data) {
    final remainder = data.length % 4;
    if (remainder == 0) return Uint8List.fromList(data);
    return Uint8List.fromList([...data, ...List.filled(4 - remainder, 0x20)]);
  }

  static Uint8List _chunkHeader(int length, int type) {
    final header = ByteData(8);
    header.setUint32(0, length, Endian.little);
    header.setUint32(4, type, Endian.little);
    return header.buffer.asUint8List();
  }
}
