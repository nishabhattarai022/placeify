import 'package:placeify_client/placeify_client.dart' as api;

import '../../../core/config/resolve_media_url.dart';
import '../../home/domain/models/product.dart';

/// Resolves Tripo-generated per-product GLB URLs for 3D preview.
abstract final class Product3dModelResolver {
  static final Map<String, String> _modelUrlByProductId = {};

  static void setModelUrl(String productId, String url) {
    _modelUrlByProductId[productId] = url;
  }

  static String? modelUrlFor(String productId) =>
      _modelUrlByProductId[productId];

  static bool hasPreview(Product product) {
    final url = modelUrlFor(product.id);
    return url != null && url.isNotEmpty;
  }

  /// Resolves the glb source for [product] (remote URL from [model3dUrl]).
  static Future<String?> srcForProduct(
    Product product, {
    api.Product? apiProduct,
  }) async {
    final remote =
        apiProduct?.model3dUrl?.trim() ?? modelUrlFor(product.id);
    if (remote == null || remote.isEmpty) {
      return null;
    }
    if (remote.startsWith('http://') || remote.startsWith('https://')) {
      return remote;
    }
    final resolved = await resolveMediaUrl(remote);
    return resolved.isEmpty ? null : resolved;
  }
}
