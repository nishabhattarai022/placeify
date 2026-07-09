/// Aggregated review stats shown on product list tiles.
class ProductReviewSummary {
  const ProductReviewSummary({
    required this.averageRating,
    required this.reviewCount,
  });

  final double averageRating;
  final int reviewCount;

  String get formattedRating => averageRating.toStringAsFixed(1);

  String get reviewCountLabel =>
      reviewCount == 1 ? '1 review' : '$reviewCount reviews';
}
