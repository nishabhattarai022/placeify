import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/services/haptic_service.dart';
import '../../data/discounted_products.dart';
import '../../domain/models/product.dart';
import '../providers/catalog_provider.dart';

/// Auto-cycling premium promo card. One card on screen at all times — content
/// (background gradient, watermark, copy, image, price tag) swaps inside it.
class DiscountedProductsSection extends ConsumerStatefulWidget {
  const DiscountedProductsSection({super.key});

  @override
  ConsumerState<DiscountedProductsSection> createState() =>
      _DiscountedProductsSectionState();
}

class _DiscountedProductsSectionState
    extends ConsumerState<DiscountedProductsSection> {
  static const _cardHeight = 224.0;
  static const _cardRadius = 26.0;
  static const _headerSpacing = 14.0;
  static const _autoplayInterval = Duration(seconds: 4);
  static const _swapDuration = Duration(milliseconds: 520);

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _restartAutoplay(int length) {
    _timer?.cancel();
    if (length <= 1) return;
    _timer = Timer.periodic(_autoplayInterval, (_) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % length;
      });
    });
  }

  void _onShopNow() {
    HapticService.light();
    context.go('/browse');
  }

  void _onDotTap(int i, int length) {
    if (i == _currentIndex) return;
    HapticService.selection();
    setState(() => _currentIndex = i);
    _restartAutoplay(length);
  }

  @override
  Widget build(BuildContext context) {
    final offersAsync = ref.watch(catalogDiscountedProductsProvider);

    return offersAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (products) {
        final offers = _mapUiProducts(products);
        if (offers.isEmpty) return const SizedBox.shrink();
        if (_timer == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _restartAutoplay(offers.length);
          });
        }
        return _OffersCarousel(
          offers: offers,
          currentIndex: _currentIndex,
          swapDuration: _swapDuration,
          cardHeight: _cardHeight,
          cardRadius: _cardRadius,
          headerSpacing: _headerSpacing,
          onShopNow: _onShopNow,
          onDotTap: (i) => _onDotTap(i, offers.length),
          onOffersLoaded: _restartAutoplay,
        );
      },
    );
  }

  List<DiscountedProduct> _mapUiProducts(List<Product> products) {
    const cardColors = [
      Color(0xFFB5A99A),
      Color(0xFFA8B5A0),
      Color(0xFFB0AABF),
      Color(0xFFBFAE98),
    ];
    final offers = <DiscountedProduct>[];
    for (var i = 0; i < products.length; i++) {
      final product = products[i];
      if (!product.isOnSale) continue;
      offers.add(
        DiscountedProduct(
          id: product.id,
          name: product.name,
          imagePath: product.imageUrl,
          originalPrice: product.originalPrice ?? product.price,
          discountedPrice: product.price,
          discountPercent: product.discountPercent.round(),
          tagline: product.brand,
          cardColor: cardColors[i % cardColors.length],
        ),
      );
    }
    return offers;
  }
}

class _OffersCarousel extends StatefulWidget {
  const _OffersCarousel({
    required this.offers,
    required this.currentIndex,
    required this.swapDuration,
    required this.cardHeight,
    required this.cardRadius,
    required this.headerSpacing,
    required this.onShopNow,
    required this.onDotTap,
    required this.onOffersLoaded,
  });

  final List<DiscountedProduct> offers;
  final int currentIndex;
  final Duration swapDuration;
  final double cardHeight;
  final double cardRadius;
  final double headerSpacing;
  final VoidCallback onShopNow;
  final void Function(int index) onDotTap;
  final void Function(int length) onOffersLoaded;

  @override
  State<_OffersCarousel> createState() => _OffersCarouselState();
}

class _OffersCarouselState extends State<_OffersCarousel> {
  bool _ctaPressed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onOffersLoaded(widget.offers.length);
    });
  }

  @override
  void didUpdateWidget(covariant _OffersCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.offers.length != widget.offers.length) {
      widget.onOffersLoaded(widget.offers.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final offers = widget.offers;
    final index = widget.currentIndex.clamp(0, offers.length - 1);
    final product = offers[index];
    final darkAccent = Color.lerp(product.cardColor, Colors.black, 0.22)!;
    final cleanTagline = product.tagline.replaceFirst('— ', '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Special Offers',
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                letterSpacing: -0.2,
              ),
            ),
            Text(
              '${index + 1} / ${offers.length}',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black45,
                letterSpacing: 0.4,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        SizedBox(height: widget.headerSpacing),
        SizedBox(
          width: double.infinity,
          height: widget.cardHeight,
          child: Stack(
            children: [
              _CardBackground(
                cardColor: product.cardColor,
                darkAccent: darkAccent,
                height: widget.cardHeight,
                radius: widget.cardRadius,
                swapDuration: widget.swapDuration,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 14, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _TextPanel(
                        product: product,
                        cleanTagline: cleanTagline,
                        ctaPressed: _ctaPressed,
                        onCtaTapDown: (_) =>
                            setState(() => _ctaPressed = true),
                        onCtaTapUp: (_) =>
                            setState(() => _ctaPressed = false),
                        onCtaTapCancel: () =>
                            setState(() => _ctaPressed = false),
                        onCtaTap: widget.onShopNow,
                      ),
                    ),
                    const SizedBox(width: 12),
                    AspectRatio(
                      aspectRatio: 0.92,
                      child: _ProductFrame(
                        product: product,
                        swapDuration: widget.swapDuration,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 6,
                right: 8,
                child: _PriceTag(
                  product: product,
                  duration: widget.swapDuration,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < offers.length; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => widget.onDotTap(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeOutCubic,
                      width: i == index ? 22 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == index ? Colors.black87 : Colors.black26,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CardBackground extends StatelessWidget {
  const _CardBackground({
    required this.cardColor,
    required this.darkAccent,
    required this.height,
    required this.radius,
    required this.swapDuration,
  });

  final Color cardColor;
  final Color darkAccent;
  final double height;
  final double radius;
  final Duration swapDuration;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: swapDuration,
      curve: Curves.easeInOut,
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: darkAccent.withValues(alpha: 0.34),
            blurRadius: 22,
            offset: const Offset(0, 12),
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          children: [
            Positioned(
              left: -60,
              top: -30,
              child: Container(
                width: 220,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(120),
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.12),
                      Colors.white.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: -40,
              bottom: -40,
              child: Container(
                width: 160,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  gradient: RadialGradient(
                    colors: [
                      darkAccent.withValues(alpha: 0.18),
                      darkAccent.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 1,
              child: Container(
                color: Colors.white.withValues(alpha: 0.18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextPanel extends StatelessWidget {
  const _TextPanel({
    required this.product,
    required this.cleanTagline,
    required this.ctaPressed,
    required this.onCtaTapDown,
    required this.onCtaTapUp,
    required this.onCtaTapCancel,
    required this.onCtaTap,
  });

  final DiscountedProduct product;
  final String cleanTagline;
  final bool ctaPressed;
  final void Function(TapDownDetails) onCtaTapDown;
  final void Function(TapUpDetails) onCtaTapUp;
  final VoidCallback onCtaTapCancel;
  final VoidCallback onCtaTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.20),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.32),
              width: 1,
            ),
          ),
          child: Text(
            'LIMITED OFFER',
            style: GoogleFonts.dmSans(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.6,
              height: 1,
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 420),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.16),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Column(
            key: ValueKey<String>('text_${product.id}'),
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '${product.discountPercent}% off',
                  maxLines: 1,
                  style: GoogleFonts.dmSans(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 0.95,
                    letterSpacing: -1.3,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        offset: const Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                cleanTagline,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.88),
                  height: 1.3,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: onCtaTapDown,
          onTapUp: onCtaTapUp,
          onTapCancel: onCtaTapCancel,
          onTap: onCtaTap,
          child: AnimatedScale(
            scale: ctaPressed ? 0.94 : 1,
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.14),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Shop Now',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      letterSpacing: -0.1,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({required this.product, required this.duration});

  final DiscountedProduct product;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      child: Transform.rotate(
        key: ValueKey<String>('price_${product.id}'),
        angle: -0.09,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.04),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 6),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'NPR ${product.originalPrice.toInt()}',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.black38,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.black38,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 7),
              Text(
                'NPR ${product.discountedPrice.toInt()}',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  letterSpacing: -0.2,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductFrame extends StatelessWidget {
  const _ProductFrame({
    required this.product,
    required this.swapDuration,
  });

  final DiscountedProduct product;
  final Duration swapDuration;

  @override
  Widget build(BuildContext context) {
    const radius = 22.0;
    final isNetwork = product.imagePath.startsWith('http');

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFEFE9DC),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.55),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 14,
            offset: const Offset(0, 6),
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 1),
        child: AnimatedSwitcher(
          duration: swapDuration,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          layoutBuilder: (currentChild, previousChildren) {
            return Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          child: SizedBox.expand(
            key: ValueKey<String>('frame_${product.imagePath}'),
            child: isNetwork
                ? CachedNetworkImage(
                    imageUrl: product.imagePath,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorWidget: (_, __, ___) => const ColoredBox(
                      color: Color(0xFFEFE9DC),
                    ),
                  )
                : Image.asset(
                    product.imagePath,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) => const ColoredBox(
                      color: Color(0xFFEFE9DC),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
