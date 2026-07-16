import 'package:placeify_client/placeify_client.dart' show Review;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../orders/data/serverpod_review_repository.dart';

part 'product_reviews_provider.g.dart';

@riverpod
ServerpodReviewRepository reviewRepository(Ref ref) {
  return const ServerpodReviewRepository();
}

@riverpod
class ProductReviews extends _$ProductReviews {
  @override
  Future<List<Review>> build(String productId) async {
    return ref.read(reviewRepositoryProvider).listProductReviews(productId);
  }

  Future<String?> submit({
    required String orderId,
    required int rating,
    String? comment,
  }) async {
    try {
      await ref
          .read(reviewRepositoryProvider)
          .submitReview(
            uiProductId: productId,
            orderId: orderId,
            rating: rating,
            comment: comment,
          );
      ref.invalidateSelf();
      return null;
    } on ReviewRepositoryException catch (error) {
      return error.message;
    } catch (_) {
      return 'Could not submit review.';
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
