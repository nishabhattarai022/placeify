import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'local_image_data.dart';

Future<LocalImageData?> readLocalImagePath(
  String source, {
  String? fileName,
}) async {
  final trimmed = source.trim();
  if (trimmed.isEmpty) return null;

  if (!trimmed.startsWith('blob:') &&
      !trimmed.startsWith('http://') &&
      !trimmed.startsWith('https://')) {
    return null;
  }

  try {
    final response = await http
        .get(Uri.parse(trimmed))
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) return null;

    final resolvedName = fileName?.trim().isNotEmpty == true
        ? fileName!.trim()
        : 'product.jpg';

    return LocalImageData(
      bytes: Uint8List.fromList(response.bodyBytes),
      fileName: resolvedName,
    );
  } catch (_) {
    return null;
  }
}
