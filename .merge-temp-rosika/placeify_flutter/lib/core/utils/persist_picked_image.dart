import 'dart:io';

/// Copies a picked photo into app temp storage so it stays readable on iOS.
abstract final class PersistPickedImage {
  static Future<String?> copyToTemp(String sourcePath) async {
    final trimmed = sourcePath.trim();
    if (trimmed.isEmpty) return null;

    final source = File(trimmed);
    if (!await source.exists()) return null;

    final extension = _extension(trimmed);
    final destination = File(
      '${Directory.systemTemp.path}/placeify_${DateTime.now().microsecondsSinceEpoch}$extension',
    );

    await source.copy(destination.path);
    return destination.path;
  }

  static Future<List<String>> copyAllToTemp(Iterable<String> sourcePaths) async {
    final persisted = <String>[];
    for (final path in sourcePaths) {
      final copied = await copyToTemp(path);
      if (copied != null) persisted.add(copied);
    }
    return persisted;
  }

  static String _extension(String path) {
    final dot = path.lastIndexOf('.');
    if (dot <= 0 || dot >= path.length - 1) return '.jpg';
    final ext = path.substring(dot).toLowerCase();
    const allowed = {'.jpg', '.jpeg', '.png', '.webp', '.heic', '.heif'};
    return allowed.contains(ext) ? ext : '.jpg';
  }
}
