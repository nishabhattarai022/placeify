import 'dart:io';

import 'package:flutter/foundation.dart' show consolidateHttpClientResponseBytes, kIsWeb;
import 'package:path_provider/path_provider.dart';
import '../../../core/config/placeify_server_client.dart';
import '../../cart/data/product_id_codec.dart';

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
    int? databaseProductId,
  }) async {
    if (kIsWeb || productId.isEmpty) {
      return null;
    }

    final dbId = databaseProductId ?? ProductIdCodec.toDatabaseId(productId);
    final localDir = await _modelsDirectory();
    final fileName = 'product_$productId.glb';
    final file = File('${localDir.path}/$fileName');
    final relativePath = '$_subdir/$fileName';
    final metaFile = File('${localDir.path}/$fileName.url');

    final cachedInMemory = _memoryCache[productId];
    if (cachedInMemory != null && await _cacheStillValid(metaFile, remoteUrl)) {
      return cachedInMemory;
    }

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

    if (!kIsWeb && dbId != null) {
      final fromApi = await _downloadFromApi(
        databaseProductId: dbId,
        productId: productId,
        remoteUrl: remoteUrl,
        file: file,
        relativePath: relativePath,
        metaFile: metaFile,
      );
      if (fromApi != null) return fromApi;
    }

    if (remoteUrl.isEmpty) return null;

    return _downloadFromHttp(
      remoteUrl: remoteUrl,
      productId: productId,
      file: file,
      relativePath: relativePath,
      metaFile: metaFile,
    );
  }

  static Future<Directory> _modelsDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final modelsDir = Directory('${docsDir.path}/$_subdir');
    if (!await modelsDir.exists()) {
      await modelsDir.create(recursive: true);
    }
    return modelsDir;
  }

  static Future<bool> _cacheStillValid(File metaFile, String remoteUrl) async {
    if (!await metaFile.exists()) return false;
    final cachedUrl = (await metaFile.readAsString()).trim();
    return cachedUrl == remoteUrl;
  }

  static Future<ArLocalModelFile?> _downloadFromApi({
    required int databaseProductId,
    required String productId,
    required String remoteUrl,
    required File file,
    required String relativePath,
    required File metaFile,
  }) async {
    try {
      final bytes = await client.product.getModel3dAsset(databaseProductId);
      if (bytes == null || bytes.lengthInBytes == 0) return null;

      final data = bytes.buffer.asUint8List(
        bytes.offsetInBytes,
        bytes.lengthInBytes,
      );
      await file.writeAsBytes(data, flush: true);
      await metaFile.writeAsString(remoteUrl, flush: true);
      final local = ArLocalModelFile(
        absolutePath: file.path,
        relativePath: relativePath,
      );
      _memoryCache[productId] = local;
      return local;
    } on Object {
      return null;
    }
  }

  static Future<ArLocalModelFile?> _downloadFromHttp({
    required String remoteUrl,
    required String productId,
    required File file,
    required String relativePath,
    required File metaFile,
  }) async {
    try {
      final clientHttp = HttpClient();
      try {
        final request = await clientHttp.getUrl(Uri.parse(remoteUrl));
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
        clientHttp.close(force: true);
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
