import 'package:placeify_client/placeify_client.dart' as api;

import '../../../core/config/placeify_server_client.dart';
import '../../../core/config/resolve_media_url.dart';
import '../../cart/data/product_id_codec.dart';
import '../../home/domain/models/product.dart';

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

  static Future<String?> _resolveRemoteUrl(String remote) async {
    if (remote.startsWith('http://') || remote.startsWith('https://')) {
      return remote;
    }
    final resolved = await resolveMediaUrl(remote);
    return resolved.isEmpty ? null : resolved;
  }
}
