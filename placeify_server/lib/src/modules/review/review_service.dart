import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'review_repository.dart';

class ReviewService {
  ReviewService({ReviewStore? repository})
      : _repository = repository ?? ReviewStore();

  final ReviewStore _repository;

  Future<Review> submitReview(
    Session session,
    int productId,
    int orderId,
    int rating, {
    String? comment,
  }) {
    return _repository.submitReview(
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
    return _repository.getMyReviewForOrderItem(session, productId, orderId);
  }

  Future<Review> updateReview(
    Session session,
    int reviewId,
    int rating, {
    String? comment,
  }) {
    return _repository.updateReview(
      session,
      reviewId,
      rating,
      comment: comment,
    );
  }

  Future<void> deleteReview(Session session, int reviewId) {
    return _repository.deleteReview(session, reviewId);
  }

  Future<List<Review>> listProductReviews(
    Session session,
    int productId, {
    int limit = 20,
    int offset = 0,
  }) {
    return _repository.listProductReviews(
      session,
      productId,
      limit: limit,
      offset: offset,
    );
  }
}
