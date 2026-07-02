import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/services/haptic_service.dart';
import '../../data/discounted_products.dart';
import '../providers/special_offers_provider.dart';

/// Auto-cycling premium promo card. Each slide links to its product detail page.
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
  bool _ctaPressed = false;

  @override
  void initState() {
    super.initState();
    _startAutoplay(1);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoplay(int itemCount) {
    _timer?.cancel();
    if (itemCount <= 1) return;
    _timer = Timer.periodic(_autoplayInterval, (_) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % itemCount;
      });
    });
  }

  void _openProduct(DiscountedProduct product) {
    HapticService.light();
    context.push('/product/${product.id}');
  }

  void _onDotTap(int i, int itemCount) {
    if (i == _currentIndex) return;
    HapticService.selection();
    setState(() => _currentIndex = i);
    _startAutoplay(itemCount);
  }

  @override
  Widget build(BuildContext context) {
    final offersAsync = ref.watch(specialOffersProvider);

    return offersAsync.when(
      loading: () => const _OffersLoading(),
      error: (_, __) => const SizedBox.shrink(),
      data: (offers) {
        if (offers.isEmpty) return const SizedBox.shrink();

        final safeIndex = _currentIndex.clamp(0, offers.length - 1).toInt();
        if (safeIndex != _currentIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _currentIndex = safeIndex);
          });
        }

        if (_timer == null && offers.length > 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _startAutoplay(offers.length);
          });
        }

        final product = offers[safeIndex];
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
                  '${safeIndex + 1} / ${offers.length}',
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
            const SizedBox(height: _headerSpacing),
            GestureDetector(
              onTap: () => _openProduct(product),
              child: SizedBox(
                width: double.infinity,
                height: _cardHeight,
                child: Stack(
                  children: [
                    _CardBackground(
                      cardColor: product.cardColor,
                      darkAccent: darkAccent,
                      height: _cardHeight,
                      radius: _cardRadius,
                      swapDuration: _swapDuration,
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
                              onCtaTap: () => _openProduct(product),
                            ),
                          ),
                          const SizedBox(width: 12),
                          AspectRatio(
                            aspectRatio: 0.92,
                            child: GestureDetector(
                              onTap: () => _openProduct(product),
                              child: _ProductFrame(
                                product: product,
                                swapDuration: _swapDuration,
                              ),
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
                        duration: _swapDuration,
                      ),
                    ),
                  ],
                ),
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
                      onTap: () => _onDotTap(i, offers.length),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 320),
                          curve: Curves.easeOutCubic,
                          width: i == safeIndex ? 22 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: i == safeIndex
                                ? Colors.black87
                                : Colors.black26,
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
      },
    );
  }
}

class _OffersLoading extends StatelessWidget {
  const _OffersLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special Offers',
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: 224,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(26),
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
            child: _OfferImage(path: product.imagePath),
          ),
        ),
      ),
    );
  }
}

class _OfferImage extends StatelessWidget {
  const _OfferImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => const ColoredBox(
          color: Color(0xFFEFE9DC),
        ),
      );
    }

    return Image.asset(
      path,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => const ColoredBox(
        color: Color(0xFFEFE9DC),
      ),
    );
  }
}
