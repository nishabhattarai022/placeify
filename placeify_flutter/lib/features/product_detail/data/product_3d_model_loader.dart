import 'dart:io';

import 'package:flutter/foundation.dart'
    show consolidateHttpClientResponseBytes, kIsWeb;
import 'package:path_provider/path_provider.dart';

/// Cached GLB on disk, ready for [NodeType.fileSystemAppFolderGLB].
class ArLocalModelFile {
  const ArLocalModelFile({
    required this.absolutePath,
    required this.relativePath,
  });

  final String absolutePath;

  /// Path relative to the app documents directory (used on iOS).
  final String relativePath;

  /// Value for [ARNode.uri] — platform-specific.
  String get arNodeUri {
    if (kIsWeb) return absolutePath;
    if (Platform.isIOS) return relativePath;
    return absolutePath;
  }
}

/// Downloads Tripo GLB files for in-app AR (local file load, not remote URL).
abstract final class Product3dModelLoader {
  static const _subdir = 'ar_models';

  static Future<ArLocalModelFile?> prepareForAr({
    required String remoteUrl,
    required String productId,
  }) async {
    if (kIsWeb || remoteUrl.isEmpty || productId.isEmpty) {
      return null;
    }

    final docsDir = await getApplicationDocumentsDirectory();
    final modelsDir = Directory('${docsDir.path}/$_subdir');
    if (!await modelsDir.exists()) {
      await modelsDir.create(recursive: true);
    }

    final fileName = 'product_$productId.glb';
    final file = File('${modelsDir.path}/$fileName');
    final relativePath = '$_subdir/$fileName';
    final metaFile = File('${modelsDir.path}/$fileName.url');

    if (await file.exists() &&
        await metaFile.exists() &&
        await file.length() > 0) {
      final cachedUrl = (await metaFile.readAsString()).trim();
      if (cachedUrl == remoteUrl) {
        return ArLocalModelFile(
          absolutePath: file.path,
          relativePath: relativePath,
        );
      }
    }

    try {
      final client = HttpClient();
      try {
        final request = await client.getUrl(Uri.parse(remoteUrl));
        final response = await request.close();
        if (response.statusCode != HttpStatus.ok) {
          return null;
        }
        final bytes = await consolidateHttpClientResponseBytes(response);
        if (bytes.isEmpty) return null;
        await file.writeAsBytes(bytes, flush: true);
        await metaFile.writeAsString(remoteUrl, flush: true);
        return ArLocalModelFile(
          absolutePath: file.path,
          relativePath: relativePath,
        );
      } finally {
        client.close(force: true);
      }
    } on Object {
      return null;
    }
  }
}
