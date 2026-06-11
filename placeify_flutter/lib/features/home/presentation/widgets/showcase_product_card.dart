import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../../cart/presentation/cart_actions.dart';
import '../../domain/models/product.dart';

/// Product tile for the category showcase masonry grid (mock layout).
class ShowcaseProductCard extends ConsumerWidget {
  const ShowcaseProductCard({
    required this.product,
    super.key,
    this.minHeight = 220,
  });

  final Product product;
  final double minHeight;

  bool get _isAsset => product.imageUrl.startsWith('assets/');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.sku,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Color(0xFF9E9E9E),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _ProductImage(product: product, isAsset: _isAsset),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: _PriceColumn(product: product)),
                _CartButton(
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

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.product, required this.isAsset});

  final Product product;
  final bool isAsset;

  @override
  Widget build(BuildContext context) {
    if (isAsset) {
      return Image.asset(
        product.imageUrl,
        fit: BoxFit.contain,
        height: 120,
        errorBuilder: (_, __, ___) => _FallbackIcon(svgPath: product.svgIconPath),
      );
    }

    return CachedNetworkImage(
      imageUrl: product.imageUrl,
      fit: BoxFit.contain,
      height: 120,
      errorWidget: (_, __, ___) => _FallbackIcon(svgPath: product.svgIconPath),
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

class _PriceColumn extends StatelessWidget {
  const _PriceColumn({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    if (product.isOnSale) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Formatters.currencyFull(product.originalPrice!),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF9E9E9E),
              decoration: TextDecoration.lineThrough,
              decorationColor: Color(0xFF9E9E9E),
            ),
          ),
          Text(
            Formatters.currencyFull(product.price),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFFD32F2F),
            ),
          ),
        ],
      );
    }

    return Text(
      Formatters.currencyFull(product.price),
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.charcoal,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/ic_cart.svg',
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
