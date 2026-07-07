import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:placeify_client/placeify_client.dart' as api;

import '../../../core/config/placeify_server_client.dart';
import '../../../core/config/resolve_media_url.dart';
import '../../cart/data/product_id_codec.dart';
import '../../home/domain/models/product.dart';
import 'product_3d_model_loader.dart';

/// Resolved source for the in-app 3D preview widget.
class Product3dPreviewSource {
  const Product3dPreviewSource({
    required this.src,
    this.unavailableMessage,
  });

  final String src;
  final String? unavailableMessage;
}

/// Resolves Tripo-generated per-product GLB URLs for 3D preview.
abstract final class Product3dModelResolver {
  static final Map<String, String> _modelUrlByProductId = {};

  static String _canonicalId(String productId) {
    final dbId = ProductIdCodec.toDatabaseId(productId);
    if (dbId == null) return productId.trim();
    return ProductIdCodec.fromDatabaseId(dbId);
  }

  static void setModelUrl(String productId, String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return;
    _modelUrlByProductId[_canonicalId(productId)] = trimmed;
  }

  static void clearModelUrl(String productId) {
    _modelUrlByProductId.remove(_canonicalId(productId));
  }

  static String? modelUrlFor(String productId) =>
      _modelUrlByProductId[_canonicalId(productId)];

  static bool hasPreview(Product product) {
    if (product.hasArView) return true;
    final url = modelUrlFor(product.id);
    return url != null && url.isNotEmpty;
  }

  /// Resolves the glb source for [product] (remote URL from [model3dUrl]).
  static Future<String?> srcForProduct(
    Product product, {
    api.Product? apiProduct,
  }) async {
    final fromApi = apiProduct?.model3dUrl?.trim();
    if (fromApi != null && fromApi.isNotEmpty) {
      final resolved = await _resolveRemoteUrl(fromApi);
      if (resolved != null) {
        setModelUrl(product.id, resolved);
        return resolved;
      }
    }

    final cached = modelUrlFor(product.id);
    if (cached != null && cached.isNotEmpty) {
      return cached.startsWith('http://') || cached.startsWith('https://')
          ? cached
          : _resolveRemoteUrl(cached);
    }

    return null;
  }

  /// Loads the model URL from cache, or fetches the product from the server
  /// when [product.hasArView] is true but the in-memory cache is empty.
  static Future<String?> ensureSrcForProduct(Product product) async {
    final cached = await srcForProduct(product);
    if (cached != null && cached.isNotEmpty) return cached;
    if (!product.hasArView) return null;

    final dbId = ProductIdCodec.toDatabaseId(product.id);
    if (dbId == null) return null;

    try {
      final apiProduct = await client.product.getProduct(dbId);
      if (apiProduct == null) return null;
      return srcForProduct(product, apiProduct: apiProduct);
    } catch (_) {
      return null;
    }
  }

  /// Loads a preview source suitable for [ModelViewer].
  ///
  /// On mobile, prefers downloading the GLB through the API (port 8080) so
  /// physical devices do not need the web static server (8082) open.
  static Future<Product3dPreviewSource?> ensurePreviewSourceForProduct(
    Product product,
  ) async {
    final dbId = ProductIdCodec.toDatabaseId(product.id);
    if (dbId != null && !kIsWeb && _isMobilePlatform) {
      final fromApi = await _previewFromApi(product, dbId);
      if (fromApi != null) return fromApi;
    }

    final remote = await ensureSrcForProduct(product);
    if (remote == null || remote.isEmpty) {
      return Product3dPreviewSource(
        src: '',
        unavailableMessage: product.hasArView
            ? '3D model file is missing on the server. '
                'The vendor may need to run Build 3D again.'
            : '3D preview is not available for this item yet.',
      );
    }

    if (!kIsWeb && _isMobilePlatform) {
      final local = await Product3dModelLoader.prepareForAr(
        remoteUrl: remote,
        productId: product.id,
      );
      if (local != null) {
        return Product3dPreviewSource(src: _fileUri(local.absolutePath));
      }
      return const Product3dPreviewSource(
        src: '',
        unavailableMessage:
            'Could not download the 3D model. '
            'Check that placeify_server is running and your phone can reach '
            'this PC on the same Wi‑Fi (ports 8080 and 8082).',
      );
    }

    return Product3dPreviewSource(src: remote);
  }

  static bool get _isMobilePlatform =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static Future<Product3dPreviewSource?> _previewFromApi(
    Product product,
    int dbId,
  ) async {
    try {
      final apiProduct = await client.product.getProduct(dbId);
      if (apiProduct?.model3dUrl?.trim().isNotEmpty ?? false) {
        await srcForProduct(product, apiProduct: apiProduct);
      }

      final bytes = await client.product.getModel3dAsset(dbId);
      if (bytes == null || bytes.lengthInBytes == 0) return null;

      final path = await _writePreviewBytes(product.id, bytes);
      if (path == null) return null;
      return Product3dPreviewSource(src: _fileUri(path));
    } catch (_) {
      return null;
    }
  }

  static Future<String?> _writePreviewBytes(
    String productId,
    ByteData bytes,
  ) async {
    final dir = await getTemporaryDirectory();
    final previewsDir = Directory('${dir.path}/product_3d_previews');
    if (!await previewsDir.exists()) {
      await previewsDir.create(recursive: true);
    }

    final file = File('${previewsDir.path}/product_$productId.glb');
    await file.writeAsBytes(
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
      flush: true,
    );
    if (!await file.exists() || await file.length() == 0) return null;
    return file.path;
  }

  static String _fileUri(String path) {
    if (path.startsWith('file://')) return path;
    return Uri.file(path).toString();
  }

  static Future<String?> _resolveRemoteUrl(String remote) async {
    if (remote.startsWith('http://') || remote.startsWith('https://')) {
      return remote;
    }
    final resolved = await resolveMediaUrl(remote);
    return resolved.isEmpty ? null : resolved;
  }
}
