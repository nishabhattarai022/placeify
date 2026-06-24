import 'package:placeify_client/placeify_client.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../cart/data/product_id_codec.dart';

/// Serverpod product catalog API (data layer only).
class ServerpodProductRepository {
  Future<ProductPage> search({
    String? query,
    String? categoryName,
    double? minPrice,
    double? maxPrice,
    bool offersOnly = false,
    bool featuredOnly = false,
    PaginationInput? pagination,
  }) {
    return client.product.searchProducts(
      ProductSearchInput(
        query: query,
        categoryName: categoryName,
        minPrice: minPrice,
        maxPrice: maxPrice,
        offersOnly: offersOnly,
        featuredOnly: featuredOnly,
        pagination: pagination,
      ),
    );
  }

  Future<MarketplaceHighlights> getMarketplaceHighlights() {
    return client.product.getMarketplaceHighlights();
  }

  Future<Product?> getByUiId(String productId) {
    final id = ProductIdCodec.toDatabaseId(productId);
    if (id == null) return Future.value(null);
    return client.product.getProduct(id);
  }
}
