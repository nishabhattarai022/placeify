import 'dart:typed_data';

/// In-memory image payload for uploads and previews (especially on web).
class LocalImageData {
  const LocalImageData({
    required this.bytes,
    required this.fileName,
  });

  final Uint8List bytes;
  final String fileName;
}
