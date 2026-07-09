import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/session_service.dart';
import 'product_rating_stats.dart';

class ReviewStore {
  Future<Review> submitReview(
    Session session,
    int productId,
    int orderId,
    int rating, {
    String? comment,
  }) async {
    if (rating < 1 || rating > 5) {
      throw PlaceifyException(message: 'Rating must be between 1 and 5.',
        code: 'INVALID_RATING',
      );
    }

    final user = await SessionService.requireUser(session);
    final order = await Order.db.findById(session, orderId);
    if (order == null || order.userId != user.id) {
      throw PlaceifyException(message: 'Order not found.', code: 'ORDER_NOT_FOUND');
    }

    final product = await Product.db.findById(session, productId);
    if (product == null || product.status != ProductStatus.active) {
      throw PlaceifyException(message: 'Product not found.', code: 'PRODUCT_NOT_FOUND');
    }

    final existing = await Review.db.findFirstRow(
      session,
      where: (row) =>
          row.userId.equals(user.id!) &
          row.productId.equals(productId) &
          row.orderId.equals(orderId),
    );
    if (existing != null) {
      throw PlaceifyException(message: 'You already reviewed this order item.',
        code: 'REVIEW_EXISTS',
      );
    }

    final review = await Review.db.insertRow(
      session,
      Review(
        userId: user.id!,
        productId: productId,
        orderId: orderId,
        rating: rating,
        comment: comment?.trim(),
      ),
    );
    await ProductRatingStats.refreshForProduct(session, productId);
    return review;
  }

  Future<List<Review>> listProductReviews(
    Session session,
    int productId, {
    int limit = 20,
    int offset = 0,
  }) {
    return Review.db.find(
      session,
      where: (row) => row.productId.equals(productId),
      include: Review.include(user: User.include()),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: limit,
      offset: offset,
    );
  }
}
