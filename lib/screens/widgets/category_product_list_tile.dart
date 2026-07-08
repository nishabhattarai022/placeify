import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/haptic_service.dart';
import '../../core/utils/formatters.dart';
import '../../features/home/data/product_reviews_repository.dart';
import '../../features/home/domain/models/product.dart';
import '../../features/home/presentation/widgets/ar_save_button.dart';
import '../../features/home/presentation/widgets/product_rating_row.dart';

/// Editorial full-width product row for category listing screens.
class CategoryProductListTile extends StatelessWidget {
  const CategoryProductListTile({
    required this.product,
    this.onRemoveFromWishlist,
    super.key,
  });

  final Product product;
  final VoidCallback? onRemoveFromWishlist;

  bool get _isAsset => product.imageUrl.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    final reviewSummary = ProductReviewsRepository.forProduct(product);

    return GestureDetector(
      onTap: () {
        HapticService.light();
        context.push('/product/${product.id}');
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: _HeroImage(product: product, isAsset: _isAsset),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onRemoveFromWishlist != null) ...[
                      GestureDetector(
                        onTap: () {
                          HapticService.light();
                          onRemoveFromWishlist!();
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.star_rounded,
                            size: 18,
                            color: AppColors.rust,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                    ArSaveButton(product: product),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${product.sku} ${product.name}',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.brand,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: Colors.black38,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ProductRatingRow(summary: reviewSummary),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                Formatters.currencyFull(product.price),
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.product, required this.isAsset});

  final Product product;
  final bool isAsset;

  @override
  Widget build(BuildContext context) {
    if (isAsset) {
      return Image.asset(
        product.imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _ImagePlaceholder(
          svgPath: product.svgIconPath,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: product.imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorWidget: (_, __, ___) => _ImagePlaceholder(
        svgPath: product.svgIconPath,
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.svgPath});

  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE8E4DE),
      child: Center(
        child: SvgPicture.asset(
          svgPath,
          width: 48,
          colorFilter: const ColorFilter.mode(
            AppColors.bark,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
