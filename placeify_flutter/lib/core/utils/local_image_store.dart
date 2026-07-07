import 'dart:typed_data';

import 'local_image_data.dart';

/// Holds picked image bytes keyed by [scheme] URIs (required on web).
abstract final class LocalImageStore {
  static const scheme = 'placeify-local://';

  static int _counter = 0;
  static final Map<String, LocalImageData> _entries = {};

  static String register(Uint8List bytes, String fileName) {
    final id = 'img-${DateTime.now().microsecondsSinceEpoch}-${_counter++}';
    _entries[id] = LocalImageData(bytes: bytes, fileName: fileName);
    return '$scheme$id';
  }

  static LocalImageData? get(String id) => _entries[id];

  static LocalImageData? readUri(String uri) {
    if (!uri.startsWith(scheme)) return null;
    return _entries[uri.substring(scheme.length)];
  }

  static void remove(String uri) {
    if (!uri.startsWith(scheme)) return;
    _entries.remove(uri.substring(scheme.length));
  }
}
