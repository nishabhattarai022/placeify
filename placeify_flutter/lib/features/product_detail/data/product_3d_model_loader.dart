import 'dart:io';

import 'package:flutter/foundation.dart' show consolidateHttpClientResponseBytes, kIsWeb;
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

  /// In-memory cache so the same product GLB is not re-read from disk per session.
  static final Map<String, ArLocalModelFile> _memoryCache = {};

  static Future<void> invalidateCache(String productId) async {
    if (kIsWeb || productId.isEmpty) return;

    _memoryCache.remove(productId);

    final docsDir = await getApplicationDocumentsDirectory();
    final fileName = 'product_$productId.glb';
    final file = File('${docsDir.path}/$_subdir/$fileName');
    final metaFile = File('${docsDir.path}/$_subdir/$fileName.url');
    if (await file.exists()) {
      await file.delete();
    }
    if (await metaFile.exists()) {
      await metaFile.delete();
    }
  }

  static Future<ArLocalModelFile?> prepareForAr({
    required String remoteUrl,
    required String productId,
  }) async {
    if (kIsWeb || remoteUrl.isEmpty || productId.isEmpty) {
      return null;
    }

    final cachedInMemory = _memoryCache[productId];
    if (cachedInMemory != null) {
      final metaFile = await _metaFileFor(productId);
      if (await metaFile.exists()) {
        final cachedUrl = (await metaFile.readAsString()).trim();
        if (cachedUrl == remoteUrl) {
          return cachedInMemory;
        }
      }
      _memoryCache.remove(productId);
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
        final local = ArLocalModelFile(
          absolutePath: file.path,
          relativePath: relativePath,
        );
        _memoryCache[productId] = local;
        return local;
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
        final local = ArLocalModelFile(
          absolutePath: file.path,
          relativePath: relativePath,
        );
        _memoryCache[productId] = local;
        return local;
      } finally {
        client.close(force: true);
      }
    } on Object {
      return null;
    }
  }

  static Future<File> _metaFileFor(String productId) async {
    final docsDir = await getApplicationDocumentsDirectory();
    return File('${docsDir.path}/$_subdir/product_$productId.glb.url');
  }
}
