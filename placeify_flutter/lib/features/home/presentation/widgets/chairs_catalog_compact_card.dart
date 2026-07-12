import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../../cart/data/cart_display_config.dart';
import '../../../cart/presentation/cart_actions.dart';
import '../../data/product_reviews_repository.dart';
import '../../domain/models/product.dart';
import '../chairs_catalog_tokens.dart';
import '../widgets/product_rating_row.dart';
import 'chairs_catalog_cart_button.dart';

/// Right-column compact product card (full-width image, footer price + cart).
class ChairsCatalogCompactCard extends ConsumerWidget {
  const ChairsCatalogCompactCard({required this.product, super.key});

  final Product product;

  bool get _isAsset => product.imageUrl.startsWith('assets/');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitPrice = CartDisplayConfig.priceFor(product.id, product.price);
    final onSale = product.isOnSale;
    final original = product.originalPrice;
    final reviewSummary = ProductReviewsRepository.forProduct(product);

    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: ChairsCatalogTokens.imageWell,
          borderRadius:
              BorderRadius.circular(ChairsCatalogTokens.compactCardRadius),
          boxShadow: ChairsCatalogTokens.cardShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ColoredBox(
                color: AppColors.cream,
                child: _isAsset
                    ? Image.asset(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, _, _) => Center(
                          child: SvgPicture.asset(
                            product.svgIconPath,
                            width: 48,
                            colorFilter: const ColorFilter.mode(
                              AppColors.bark,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorWidget: (_, _, _) => Center(
                          child: SvgPicture.asset(
                            product.svgIconPath,
                            width: 48,
                            colorFilter: const ColorFilter.mode(
                              AppColors.bark,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ChairsCatalogTokens.compactNameStyle,
                        ),
                        const SizedBox(height: 4),
                        ProductRatingRow(
                          summary: reviewSummary,
                          compact: true,
                          starSize: 12,
                        ),
                        const SizedBox(height: 4),
                        if (onSale && original != null) ...[
                          Text(
                            Formatters.currencyDecimal(
                              CartDisplayConfig.priceFor(
                                product.id,
                                original,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 11,
                              color: ChairsCatalogTokens.skuMuted,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text(
                            Formatters.currencyDecimal(unitPrice),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: ChairsCatalogTokens.salePriceColor,
                            ),
                          ),
                        ] else
                          Text(
                            Formatters.currencyDecimal(unitPrice),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  ChairsCatalogCartButton(
                    onTap: () {
                      HapticService.light();
                      addToCart(ref, context, product.id, openCart: false);
                    },
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
