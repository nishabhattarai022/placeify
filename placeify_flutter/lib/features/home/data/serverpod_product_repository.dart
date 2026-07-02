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
    PaginationInput? pagination,
  }) {
    return client.product.searchProducts(
      ProductSearchInput(
        query: query,
        categoryName: categoryName,
        minPrice: minPrice,
        maxPrice: maxPrice,
        pagination: pagination,
      ),
    );
  }

  Future<Product?> getByUiId(String productId) {
    final id = ProductIdCodec.toDatabaseId(productId);
    if (id == null) return Future.value(null);
    return client.product.getProduct(id);
  }

  Future<List<SpecialOfferSummary>> listSpecialOffers({int limit = 12}) {
    return client.product.listSpecialOffers(limit: limit);
  }
}
