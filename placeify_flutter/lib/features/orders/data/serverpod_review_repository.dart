import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../cart/data/product_id_codec.dart';

class ReviewRepositoryException implements Exception {
  ReviewRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Product reviews via [client.review].
class ServerpodReviewRepository {
  const ServerpodReviewRepository();

  Future<Review> submitReview({
    required String uiProductId,
    required String orderId,
    required int rating,
    String? comment,
  }) async {
    _requireAuthenticated();
    final productId = ProductIdCodec.toDatabaseId(uiProductId);
    final parsedOrderId = int.tryParse(orderId);
    if (productId == null || parsedOrderId == null) {
      throw ReviewRepositoryException('Invalid product or order.');
    }

    try {
      return await client.review.submitReview(
        productId,
        parsedOrderId,
        rating,
        comment: comment?.trim().isEmpty ?? true ? null : comment?.trim(),
      );
    } catch (error) {
      throw ReviewRepositoryException(_mapError(error));
    }
  }

  Future<List<Review>> listProductReviews(String uiProductId) async {
    _requireAuthenticated();
    final productId = ProductIdCodec.toDatabaseId(uiProductId);
    if (productId == null) return const [];

    try {
      return await client.review.listProductReviews(
        productId,
        limit: 20,
        offset: 0,
      );
    } catch (error) {
      throw ReviewRepositoryException(_mapError(error));
    }
  }

  void _requireAuthenticated() {
    if (!client.auth.isAuthenticated) {
      throw ReviewRepositoryException('Sign in to leave a review.');
    }
  }

  String _mapError(Object error) {
    if (error is ReviewRepositoryException) return error.message;
    if (error is PlaceifyException) return error.message;
    final text = error.toString().toLowerCase();
    if (text.contains('review_exists')) {
      return 'You already reviewed this order.';
    }
    if (text.contains('order_not_found')) {
      return 'Order not found.';
    }
    if (text.contains('invalid_rating')) {
      return 'Choose a rating between 1 and 5 stars.';
    }
    return 'Could not save review. Please try again.';
  }
}
