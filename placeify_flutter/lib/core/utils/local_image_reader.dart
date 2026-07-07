import 'local_image_data.dart';
import 'local_image_store.dart';

import 'local_image_reader_stub.dart'
    if (dart.library.io) 'local_image_reader_io.dart'
    if (dart.library.html) 'local_image_reader_web.dart';

/// Reads image bytes from in-memory URIs, local file paths, or web blob URLs.
abstract final class LocalImageReader {
  static Future<LocalImageData?> read(
    String source, {
    String? fileName,
  }) async {
    final trimmed = source.trim();
    if (trimmed.isEmpty) return null;

    final stored = LocalImageStore.readUri(trimmed);
    if (stored != null) return stored;

    return readLocalImagePath(trimmed, fileName: fileName);
  }
}
