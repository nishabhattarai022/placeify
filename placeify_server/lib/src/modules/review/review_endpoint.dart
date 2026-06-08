import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'review_service.dart';

/// Product reviews from verified purchasers.
class ReviewEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

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
