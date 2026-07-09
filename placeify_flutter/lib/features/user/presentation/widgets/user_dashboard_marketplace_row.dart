import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../../home/domain/models/product.dart';

class UserDashboardMarketplaceRow extends StatelessWidget {
  const UserDashboardMarketplaceRow({
    required this.title,
    required this.products,
    this.maxProducts = 4,
    super.key,
  });

  final String title;
  final List<Product> products;
  final int maxProducts;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    final visible = products.take(maxProducts).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.sectionTitle.copyWith(fontSize: 18)),
        const SizedBox(height: 12),
        Column(
          children: [
            for (var i = 0; i < visible.length; i += 2) ...[
              if (i > 0) const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _ProductCard(product: visible[i])),
                  if (i + 1 < visible.length) ...[
                    const SizedBox(width: 12),
                    Expanded(child: _ProductCard(product: visible[i + 1])),
                  ] else
                    const Expanded(child: SizedBox.shrink()),
                ],
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final isAsset = product.imageUrl.startsWith('assets/');

    return GestureDetector(
      onTap: () {
        HapticService.light();
        context.push('/product/${product.id}');
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.creamDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: isAsset
                        ? Image.asset(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholder(),
                          )
                        : CachedNetworkImage(
                            imageUrl: product.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => _placeholder(),
                            errorWidget: (_, __, ___) => _placeholder(),
                          ),
                  ),
                  if (product.isOnSale)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.rust.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${product.discountPercent.round()}% OFF',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.warmWhite,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (product.isOnSale)
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    Formatters.currencyFull(product.originalPrice!),
                    style: AppTypography.priceStrikethrough.copyWith(fontSize: 12),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    Formatters.currencyFull(product.price),
                    style: AppTypography.priceSale.copyWith(fontSize: 16),
                  ),
                ],
              )
            else
              Text(
                Formatters.currencyFull(product.price),
                style: AppTypography.priceSale.copyWith(fontSize: 16),
              ),
            const SizedBox(height: 4),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.metricLabel.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return ColoredBox(
      color: AppColors.creamDark,
      child: Icon(
        Icons.chair_outlined,
        size: 40,
        color: AppColors.textMuted,
      ),
    );
  }
}
