import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'review_service.dart';

/// Product reviews from verified purchasers.
///
/// Listing is public so product pages can show real reviews without login.
/// Submission still requires an authenticated session (enforced in the store).
class ReviewEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  final _service = ReviewService();

  Future<Review> submitReview(
    Session session,
    int productId,
    int orderId,
    int rating, {
    String? comment,
  }) {
    return _service.submitReview(
      session,
      productId,
      orderId,
      rating,
      comment: comment,
    );
  }

  Future<Review?> getMyReviewForOrderItem(
    Session session,
    int productId,
    int orderId,
  ) {
    return _service.getMyReviewForOrderItem(session, productId, orderId);
  }

  Future<Review> updateReview(
    Session session,
    int reviewId,
    int rating, {
    String? comment,
  }) {
    return _service.updateReview(
      session,
      reviewId,
      rating,
      comment: comment,
    );
  }

  Future<void> deleteReview(Session session, int reviewId) {
    return _service.deleteReview(session, reviewId);
  }

  Future<List<Review>> listProductReviews(
    Session session,
    int productId, {
    int limit = 20,
    int offset = 0,
  }) {
    return _service.listProductReviews(
      session,
      productId,
      limit: limit,
      offset: offset,
    );
  }
}
