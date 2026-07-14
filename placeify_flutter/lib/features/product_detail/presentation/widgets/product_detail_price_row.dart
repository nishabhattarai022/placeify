import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../home/domain/models/product.dart';
import '../product_detail_tokens.dart';

/// Customer-facing price row for product detail (list, sale, and offer badge).
class ProductDetailPriceRow extends StatelessWidget {
  const ProductDetailPriceRow({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ProductDetailTokens.infoCardHorizontalPadding,
        0,
        ProductDetailTokens.infoCardHorizontalPadding,
        ProductDetailTokens.infoCardTopGap,
      ),
      child: product.isOnSale ? _SalePriceRow(product: product) : _ListPrice(product: product),
    );
  }
}

class _ListPrice extends StatelessWidget {
  const _ListPrice({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Text(
      Formatters.currencyFull(product.price),
      style: AppTypography.priceSale.copyWith(
        fontSize: 22,
        color: ProductDetailTokens.textPrimary,
      ),
    );
  }
}

class _SalePriceRow extends StatelessWidget {
  const _SalePriceRow({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final percent = product.discountPercent.round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.rust.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$percent% OFF',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.warmWhite,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Special Offer',
              style: AppTypography.brandName.copyWith(
                fontSize: 11,
                color: AppColors.rust,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              Formatters.currencyFull(product.originalPrice!),
              style: AppTypography.priceStrikethrough.copyWith(fontSize: 14),
            ),
            const SizedBox(width: 8),
            Text(
              Formatters.currencyFull(product.price),
              style: AppTypography.priceSale.copyWith(
                fontSize: 22,
                color: ProductDetailTokens.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
