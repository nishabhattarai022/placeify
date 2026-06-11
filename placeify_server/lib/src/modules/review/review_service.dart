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
