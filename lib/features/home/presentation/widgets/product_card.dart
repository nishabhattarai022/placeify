import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/animated_scale_tap.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../cart/presentation/cart_actions.dart';
import '../../domain/models/product.dart';
import '../../data/product_reviews_repository.dart';
import 'product_rating_row.dart';
import 'wishlist_star_button.dart';

/// Home grid product tile — fills grid cell without overflow.
class ProductCard extends ConsumerStatefulWidget {
  const ProductCard({required this.product, super.key});

  final Product product;

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cartController;
  late final Animation<double> _cartScale;

  @override
  void initState() {
    super.initState();
    _cartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _cartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.88), weight: 120),
      TweenSequenceItem(tween: Tween(begin: 0.88, end: 1.08), weight: 180),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 150),
    ]).animate(_cartController);
  }

  @override
  void dispose() {
    _cartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedScaleTap(
          onTap: () => context.push('/product/${product.id}'),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.warmWhite,
              borderRadius: AppRadii.lg,
              border: Border.all(
                color: AppColors.creamDark.withValues(alpha: 0.9),
              ),
              boxShadow: AppShadows.card,
            ),
            child: ClipRRect(
              borderRadius: AppRadii.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _ProductImagePanel(product: product),
                  ),
                  _ProductCardFooter(
                    product: product,
                    cartScale: _cartScale,
                    onAddToCart: () {
                      HapticService.medium();
                      _cartController.forward(from: 0);
                      addToCart(ref, context, product.id, openCart: false);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProductImagePanel extends StatelessWidget {
  const _ProductImagePanel({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF3EFE8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
            child: _ProductCardImage(product: product),
          ),
          if (product.hasArView)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'AR',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warmWhite,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ),
          if (product.isOnSale)
            Positioned(
              top: 10,
              left: product.hasArView ? 44 : 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.rust.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '-${product.discountPercent.toInt()}%',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warmWhite,
                  ),
                ),
              ),
            ),
          Positioned(
            top: 8,
            right: 8,
            child: WishlistStarButton(product: product),
          ),
        ],
      ),
    );
  }
}

class _ProductCardFooter extends StatelessWidget {
  const _ProductCardFooter({
    required this.product,
    required this.cartScale,
    required this.onAddToCart,
  });

  final Product product;
  final Animation<double> cartScale;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final reviewSummary = ProductReviewsRepository.forProduct(product);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.brand.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.brandName.copyWith(fontSize: 9, letterSpacing: 0.8),
          ),
          const SizedBox(height: 2),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.productName.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            product.sku,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.skuCode.copyWith(fontSize: 10),
          ),
          const SizedBox(height: 6),
          ProductRatingRow(summary: reviewSummary, compact: true),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _CompactPriceRow(product: product)),
              const SizedBox(width: 8),
              Semantics(
                button: true,
                label: 'Add to cart',
                child: GestureDetector(
                  onTap: onAddToCart,
                  child: ScaleTransition(
                    scale: cartScale,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: AppColors.charcoal,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/ic_plus.svg',
                          width: 15,
                          colorFilter: const ColorFilter.mode(
                            AppColors.warmWhite,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactPriceRow extends StatelessWidget {
  const _CompactPriceRow({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    if (product.isOnSale) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Flexible(
            child: Text(
              Formatters.currencyFull(product.originalPrice!),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.priceStrikethrough.copyWith(fontSize: 11),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            Formatters.currencyFull(product.price),
            style: AppTypography.priceSale.copyWith(fontSize: 16),
          ),
        ],
      );
    }

    return Text(
      Formatters.currencyFull(product.price),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTypography.priceFullPrice.copyWith(fontSize: 16),
    );
  }
}

class _ProductCardImage extends StatelessWidget {
  const _ProductCardImage({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final fit = product.imageUrl.startsWith('assets/')
        ? BoxFit.contain
        : BoxFit.cover;

    if (product.imageUrl.startsWith('assets/')) {
      return Image.asset(
        product.imageUrl,
        fit: fit,
        alignment: Alignment.center,
        errorBuilder: (_, __, ___) => _ProductCardImageFallback(
          svgPath: product.svgIconPath,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: product.imageUrl,
      fit: fit,
      placeholder: (_, __) => const ShimmerLoader(),
      errorWidget: (_, __, ___) => _ProductCardImageFallback(
        svgPath: product.svgIconPath,
      ),
    );
  }
}

class _ProductCardImageFallback extends StatelessWidget {
  const _ProductCardImageFallback({required this.svgPath});

  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        svgPath,
        width: 44,
        colorFilter: const ColorFilter.mode(AppColors.bark, BlendMode.srcIn),
      ),
    );
  }
}
