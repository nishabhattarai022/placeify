import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

/// Keeps denormalized [Product.averageRating] and [Product.reviewCount] in sync.
abstract final class ProductRatingStats {
  static Future<void> refreshForProduct(
    Session session,
    int productId,
  ) async {
    final reviews = await Review.db.find(
      session,
      where: (row) => row.productId.equals(productId),
    );

    final reviewCount = reviews.length;
    final averageRating = reviewCount == 0
        ? 0.0
        : reviews.map((review) => review.rating).reduce((a, b) => a + b) /
            reviewCount;

    final product = await Product.db.findById(session, productId);
    if (product == null) return;

    if (product.reviewCount == reviewCount &&
        product.averageRating == averageRating) {
      return;
    }

    await Product.db.updateRow(
      session,
      product.copyWith(
        reviewCount: reviewCount,
        averageRating: averageRating,
        updatedAt: DateTime.now(),
      ),
    );
  }
}
