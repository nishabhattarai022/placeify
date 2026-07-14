/// Server-generated per-product GLB paths keyed by UI product id.
abstract final class ProductModel3dUrls {
  static final Map<String, String> _byProductId = {};

  static void replaceAll(Map<String, String> urls) {
    _byProductId
      ..clear()
      ..addAll(urls);
  }

  static void set(String productId, String url) {
    _byProductId[productId] = url;
  }

  static String? forProduct(String productId) => _byProductId[productId];
}
