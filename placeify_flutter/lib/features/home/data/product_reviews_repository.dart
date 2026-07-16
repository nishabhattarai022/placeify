import 'package:placeify_flutter/features/home/domain/models/product.dart';
import 'package:placeify_flutter/features/home/domain/models/product_review_summary.dart';

/// Resolves review stats for consumer-facing product list tiles.
///
/// Live averages for list tiles are not embedded on [Product]; until a
/// summary API is used here, return an empty summary instead of inventing
/// ratings. Product detail still loads real rows via [productReviewsProvider].
abstract final class ProductReviewsRepository {
  static const empty = ProductReviewSummary(
    averageRating: 0,
    reviewCount: 0,
  );

  static ProductReviewSummary forProduct(Product product) {
    return forProductId(product.id);
  }

  static ProductReviewSummary forProductId(
    String productId, {
    String? productName,
  }) {
    return empty;
  }
}
