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

/// Left-column wide product card (name, SKU, white image well, NPR pricing).
class ChairsCatalogWideCard extends ConsumerWidget {
  const ChairsCatalogWideCard({required this.product, super.key});

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
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        decoration: BoxDecoration(
          color: ChairsCatalogTokens.imageWell,
          borderRadius: BorderRadius.circular(ChairsCatalogTokens.wideCardRadius),
          boxShadow: ChairsCatalogTokens.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name, style: ChairsCatalogTokens.wideNameStyle),
            const SizedBox(height: 4),
            Text(product.sku, style: ChairsCatalogTokens.wideSkuStyle),
            const SizedBox(height: 6),
            ProductRatingRow(summary: reviewSummary, compact: true),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  minHeight: ChairsCatalogTokens.wideImageMinHeight,
                ),
                decoration: BoxDecoration(
                  color: ChairsCatalogTokens.imageWell,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: _isAsset
                      ? Image.asset(
                          product.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              _FallbackIcon(svgPath: product.svgIconPath),
                        )
                      : CachedNetworkImage(
                          imageUrl: product.imageUrl,
                          fit: BoxFit.contain,
                          errorWidget: (_, __, ___) =>
                              _FallbackIcon(svgPath: product.svgIconPath),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: onSale && original != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Formatters.currencyDecimal(
                                CartDisplayConfig.priceFor(
                                  product.id,
                                  original,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: ChairsCatalogTokens.skuMuted,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: ChairsCatalogTokens.skuMuted,
                              ),
                            ),
                            Text(
                              Formatters.currencyDecimal(unitPrice),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: ChairsCatalogTokens.salePriceColor,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          Formatters.currencyDecimal(unitPrice),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
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
          ],
        ),
      ),
    );
  }
}

class _FallbackIcon extends StatelessWidget {
  const _FallbackIcon({required this.svgPath});

  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgPath,
      width: 56,
      colorFilter: const ColorFilter.mode(AppColors.bark, BlendMode.srcIn),
    );
  }
}
