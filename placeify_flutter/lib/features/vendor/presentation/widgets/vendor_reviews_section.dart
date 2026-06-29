import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_routes.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_review.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_reviews_provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/utils/formatters.dart';

class VendorReviewsSection extends ConsumerWidget {
  const VendorReviewsSection({super.key});

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
          loading: () => Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Loading reviews…',
              style: AppTypography.metricLabel.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          error: (_, __) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Could not load reviews.',
              style: AppTypography.metricLabel.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          data: (reviews) {
            if (reviews.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No reviews yet',
                  style: AppTypography.metricLabel.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              );
            }

            return Column(
              children: [
                for (final review in reviews.take(2))
                  _ReviewPreviewCard(review: review),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ReviewPreviewCard extends StatelessWidget {
  const _ReviewPreviewCard({required this.review});

  final VendorReview review;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
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
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
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
