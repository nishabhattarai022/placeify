import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/animated_scale_tap.dart';
import '../../../../core/widgets/placeify_image.dart';
import '../data/home_categories_config.dart';
import '../../data/product_reviews_repository.dart';
import 'product_rating_row.dart';

class HomeFeaturedProductCard extends StatelessWidget {
  const HomeFeaturedProductCard({required this.product, super.key});

  final RecommendProduct product;

  @override
  Widget build(BuildContext context) {
    final reviewSummary = ProductReviewsRepository.forProductId(
      product.productId,
      productName: product.displayName,
    );

    return AnimatedScaleTap(
      pressScale: 0.98,
      onTap: () => context.push('/product/${product.productId}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F0E8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: PlaceifyImage(
                    source: product.imageAsset,
                    fit: BoxFit.contain,
                    error: Icon(
                      Icons.chair_outlined,
                      size: 56,
                      color: AppColors.textMuted.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ProductRatingRow(summary: reviewSummary, compact: true),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.displayPrice,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await HapticService.light();
                          if (context.mounted) {
                            context.go('/browse');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.open_in_new,
                            size: 18,
                            color: AppColors.textSecondary.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
