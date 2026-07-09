import 'package:placeify_flutter/features/home/domain/models/product.dart';
import 'package:placeify_flutter/features/home/domain/models/product_review_summary.dart';
import 'package:placeify_flutter/features/shops/data/vendor_product_mapper.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_review.dart';

/// Resolves review stats for consumer-facing product list tiles.
abstract final class ProductReviewsRepository {
  static ProductReviewSummary forProduct(Product product) {
    return forProductId(
      product.id,
      productName: product.name,
    );
  }

  static ProductReviewSummary forProductId(
    String productId, {
    String? productName,
  }) {
    if (productName != null) {
      final byName = _summaryFromReviews(productName);
      if (byName != null) return byName;
    }

    final explicit = _byProductId[productId];
    if (explicit != null) return explicit;

    if (VendorProductMapper.isShopProductId(productId)) {
      final vendorProduct = VendorProductMapper.resolveVendorProduct(productId);
      if (vendorProduct != null) {
        final byVendorName = _summaryFromReviews(vendorProduct.name);
        if (byVendorName != null) return byVendorName;
      }
    }

    return _syntheticFor(productId);
  }

  static ProductReviewSummary? _summaryFromReviews(String productName) {
    final needle = _normalize(productName);
    if (needle.isEmpty) return null;

    final matched = vendorMockReviews.where((review) {
      final hay = _normalize(review.productName);
      if (hay == needle) return true;
      if (hay.contains(needle) || needle.contains(hay)) return true;

      final needleToken = needle.split(' ').first;
      final hayToken = hay.split(' ').first;
      return needleToken.length >= 4 &&
          hayToken.length >= 4 &&
          (hayToken.startsWith(needleToken) || needleToken.startsWith(hayToken));
    }).toList();

    if (matched.isEmpty) return null;

    final total = matched.fold<int>(0, (sum, review) => sum + review.rating);
    return ProductReviewSummary(
      averageRating: total / matched.length,
      reviewCount: matched.length,
    );
  }

  static String _normalize(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  static ProductReviewSummary _syntheticFor(String productId) {
    final hash = productId.hashCode.abs();
    return ProductReviewSummary(
      averageRating: 4.0 + (hash % 9) / 10,
      reviewCount: 8 + (hash % 42),
    );
  }

  static const Map<String, ProductReviewSummary> _byProductId = {
    'p1': ProductReviewSummary(averageRating: 4.8, reviewCount: 24),
    'p4': ProductReviewSummary(averageRating: 4.9, reviewCount: 31),
    'p5': ProductReviewSummary(averageRating: 4.0, reviewCount: 18),
    'shop-demo-vendor-p1': ProductReviewSummary(averageRating: 5.0, reviewCount: 1),
    'shop-demo-vendor-p2': ProductReviewSummary(averageRating: 4.0, reviewCount: 1),
    'shop-demo-vendor-p3': ProductReviewSummary(averageRating: 5.0, reviewCount: 1),
  };
}
