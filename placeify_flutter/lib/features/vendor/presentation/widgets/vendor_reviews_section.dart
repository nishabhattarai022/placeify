import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify_flutter/core/config/resolve_media_url.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_routes.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_review.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_reviews_provider.dart';
import 'package:placeify_flutter/features/vendor/presentation/widgets/vendor_list_thumbnail.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/toast_overlay.dart';

class VendorReviewsSection extends ConsumerWidget {
  const VendorReviewsSection({super.key});

  static const _dashboardLimit = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(vendorReviewsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Reviews', style: AppTypography.sectionTitle),
            GestureDetector(
              onTap: () {
                HapticService.light();
                context.push(VendorRoutes.reviews);
              },
              child: const Text('See all', style: AppTypography.seeAll),
            ),
          ],
        ),
        const SizedBox(height: 12),
        reviewsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => const Text(
            'Could not load reviews.',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          data: (reviews) {
            if (reviews.isEmpty) {
              return const Text(
                'No reviews yet',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              );
            }
            return Column(
              children: [
                for (final review in reviews.take(_dashboardLimit))
                  _ReviewPreviewCard(
                    review: review,
                    onTap: () => _openReview(context, review),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _openReview(BuildContext context, VendorReview review) {
    HapticService.light();
    if (review.productId.isEmpty) {
      PlaceifyToast.show(context, 'Product is no longer available.');
      return;
    }
    context.push(
      '/product/${review.productId}?highlightReviewId=${review.id}',
    );
  }
}

class _ReviewPreviewCard extends StatelessWidget {
  const _ReviewPreviewCard({
    required this.review,
    required this.onTap,
  });

  final VendorReview review;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.md,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.md,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: AppRadii.md,
              border: Border.all(color: AppColors.creamDark, width: 1.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<String>(
                  future: resolveMediaUrl(review.thumbnailUrl),
                  builder: (context, snapshot) {
                    return VendorListThumbnail(
                      label: review.productName,
                      imageUrl: snapshot.data,
                      size: 52,
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              review.customerName,
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          _StarRating(rating: review.rating),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${review.productName} · ${Formatters.shortDate(review.createdAt)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      if (review.comment.trim().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          review.comment,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  const _StarRating({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 14,
          color: index < rating ? AppColors.accent : AppColors.creamDark,
        ),
      ),
    );
  }
}
