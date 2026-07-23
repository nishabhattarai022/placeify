import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify_client/placeify_client.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/relative_time.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../providers/product_reviews_provider.dart';

class ProductDetailReviewsSection extends ConsumerStatefulWidget {
  const ProductDetailReviewsSection({
    required this.productId,
    this.highlightReviewId,
    super.key,
  });

  final String productId;
  final String? highlightReviewId;

  @override
  ConsumerState<ProductDetailReviewsSection> createState() =>
      _ProductDetailReviewsSectionState();
}

class _ProductDetailReviewsSectionState
    extends ConsumerState<ProductDetailReviewsSection> {
  final Map<String, GlobalKey> _reviewKeys = {};
  bool _didScrollToHighlight = false;
  bool _highlightActive = false;

  GlobalKey _keyFor(String reviewId) =>
      _reviewKeys.putIfAbsent(reviewId, GlobalKey.new);

  void _maybeScrollToHighlight(List<Review> reviews) {
    final targetId = widget.highlightReviewId;
    if (targetId == null ||
        targetId.isEmpty ||
        _didScrollToHighlight ||
        reviews.isEmpty) {
      return;
    }

    final exists = reviews.any((r) => r.id?.toString() == targetId);
    if (!exists) {
      _didScrollToHighlight = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        PlaceifyToast.show(context, 'That review is no longer available.');
      });
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ctx = _keyFor(targetId).currentContext;
      if (ctx == null) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        alignment: 0.2,
      );
      setState(() {
        _didScrollToHighlight = true;
        _highlightActive = true;
      });
      Future<void>.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _highlightActive = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviewsAsync = ref.watch(productReviewsProvider(widget.productId));

    return reviewsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (reviews) {
        _maybeScrollToHighlight(reviews);
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customer Reviews',
                style: TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.espresso,
                ),
              ),
              const SizedBox(height: 12),
              if (reviews.isEmpty)
                Text(
                  'No reviews yet',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted.withValues(alpha: 0.95),
                    height: 1.4,
                  ),
                )
              else ...[
                _ReviewAverageHeader(reviews: reviews),
                const SizedBox(height: 12),
                for (final review in reviews)
                  if (review.id != null)
                    KeyedSubtree(
                      key: _keyFor(review.id!.toString()),
                      child: _ReviewTile(
                        review: review,
                        highlighted: _highlightActive &&
                            widget.highlightReviewId == review.id!.toString(),
                      ),
                    ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ReviewAverageHeader extends StatelessWidget {
  const _ReviewAverageHeader({required this.reviews});

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    final average =
        reviews.fold<double>(0, (sum, r) => sum + r.rating) / reviews.length;
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 18, color: AppColors.accent),
        const SizedBox(width: 4),
        Text(
          average.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.espresso,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          reviews.length == 1 ? '1 review' : '${reviews.length} reviews',
          style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({
    required this.review,
    this.highlighted = false,
  });

  final Review review;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final author = review.user?.name ?? 'Customer';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.accent.withValues(alpha: 0.12)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlighted ? AppColors.accent : AppColors.creamDark,
          width: highlighted ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  author,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.espresso,
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < review.rating; i++)
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: AppColors.accent,
                    ),
                ],
              ),
            ],
          ),
          if (review.comment != null && review.comment!.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              review.comment!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            _reviewTimestampLabel(review),
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textMuted.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }

  String _reviewTimestampLabel(Review review) {
    final created = review.createdAt.toUtc();
    final updated = review.updatedAt.toUtc();
    final wasEdited = updated.difference(created).inSeconds.abs() >= 1;
    if (wasEdited) {
      return 'Edited ${RelativeTime.format(updated)}';
    }
    return RelativeTime.format(created);
  }
}
