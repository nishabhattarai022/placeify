import 'dart:io';
import 'dart:typed_data';

import 'local_image_data.dart';

Future<LocalImageData?> readLocalImagePath(
  String source, {
  String? fileName,
}) async {
  var path = source.trim();
  if (path.isEmpty) return null;

  if (path.startsWith('file://')) {
    path = Uri.parse(path).toFilePath();
  }

  final file = File(path);
  if (!await file.exists()) return null;

  final bytes = await file.readAsBytes();
  final resolvedName = fileName?.trim().isNotEmpty == true
      ? fileName!.trim()
      : _fileNameFromPath(path);

  return LocalImageData(bytes: Uint8List.fromList(bytes), fileName: resolvedName);
}

String _fileNameFromPath(String path) {
  final normalized = path.replaceAll('\\', '/');
  final index = normalized.lastIndexOf('/');
  if (index < 0) return normalized;
  return normalized.substring(index + 1);
}
