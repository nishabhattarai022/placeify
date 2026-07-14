import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify_flutter/features/profile/presentation/widgets/profile_sub_hero.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_review.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_reviews_provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/shimmer_loader.dart';

class VendorReviewsScreen extends ConsumerWidget {
  const VendorReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(vendorReviewsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: reviewsAsync.when(
        loading: () => const CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: ProfileSubHero(title: 'Reviews')),
            SliverFillRemaining(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: ShimmerLoader(borderRadius: AppRadii.lg),
              ),
            ),
          ],
        ),
        error: (_, __) => CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: ProfileSubHero(title: 'Reviews')),
            SliverFillRemaining(
              child: Center(
                child: TextButton(
                  onPressed: () => ref.invalidate(vendorReviewsProvider),
                  child: const Text('Try again'),
                ),
              ),
            ),
          ],
        ),
        data: (reviews) => CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: ProfileSubHero(title: 'Reviews')),
            if (reviews.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No reviews yet',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              )
            else
              SliverPadding(
                padding:
                    const EdgeInsets.fromLTRB(24, 24, 24, AppSpacing.xxl),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _ReviewCard(review: reviews[index]),
                    childCount: reviews.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final VendorReview review;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.lg,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < review.rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 16,
                    color: index < review.rating
                        ? AppColors.accent
                        : AppColors.creamDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${review.productName} · ${Formatters.shortDate(review.createdAt)}',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
