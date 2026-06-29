import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/haptic_service.dart';
import '../../../cart/presentation/cart_actions.dart';
import '../data/home_categories_config.dart';
import '../theme/home_screen_tokens.dart';

const String _kCartSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
  <g>
    <path d="M2 2H3.74001C4.82001 2 5.67 2.93 5.58 4L4.75 13.96C4.61 15.59 5.89999 16.99 7.53999 16.99H18.19C19.63 16.99 20.89 15.81 21 14.38L21.54 6.88C21.66 5.22 20.4 3.87 18.73 3.87H5.82001" stroke="currentColor" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round" />
    <path d="M16.25 22C16.9404 22 17.5 21.4404 17.5 20.75C17.5 20.0596 16.9404 19.5 16.25 19.5C15.5596 19.5 15 20.0596 15 20.75C15 21.4404 15.5596 22 16.25 22Z" stroke="currentColor" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round" />
    <path d="M8.25 22C8.94036 22 9.5 21.4404 9.5 20.75C9.5 20.0596 8.94036 19.5 8.25 19.5C7.55964 19.5 7 20.0596 7 20.75C7 21.4404 7.55964 22 8.25 22Z" stroke="currentColor" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round" />
    <path d="M9 8H21" stroke="currentColor" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round" />
  </g>
</svg>
''';

class HomeRecommendProductCard extends ConsumerStatefulWidget {
  const HomeRecommendProductCard({required this.product, super.key});

  final RecommendProduct product;

  @override
  ConsumerState<HomeRecommendProductCard> createState() =>
      _HomeRecommendProductCardState();
}

class _HomeRecommendProductCardState
    extends ConsumerState<HomeRecommendProductCard> {
  bool _hovered = false;
  bool _pressed = false;
  bool _cartPressed = false;

  bool get _elevated => _hovered || _pressed;

  void _onCardTap() {
    HapticService.light();
    context.push('/product/${widget.product.productId}');
  }

  void _onAddToCart() {
    addToCart(ref, context, widget.product.productId, openCart: false);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final reservedBottomRight =
        HomeScreenTokens.cartCornerOuter - HomeScreenTokens.cardPadding + 2;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: _onCardTap,
        child: AnimatedScale(
          scale: _pressed ? 0.985 : (_hovered ? 1.015 : 1),
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: _elevated
                      ? HomeScreenTokens.cardBgHover
                      : HomeScreenTokens.cardBg,
                  borderRadius: BorderRadius.circular(
                    HomeScreenTokens.cardRadius,
                  ),
                  boxShadow: _elevated
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: _pressed ? 10 : 18,
                            offset: Offset(0, _pressed ? 3 : 8),
                          ),
                        ]
                      : null,
                ),
                padding: const EdgeInsets.all(HomeScreenTokens.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        HomeScreenTokens.cardImageRadius,
                      ),
                      child: SizedBox(
                        height: HomeScreenTokens.cardImageHeight,
                        width: double.infinity,
                        child: Image.asset(
                          product.imageAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => ColoredBox(
                            color: HomeScreenTokens.cardBg,
                            child: Icon(
                              Icons.chair_outlined,
                              size: 56,
                              color: Colors.black.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 4,
                        right: reservedBottomRight,
                      ),
                      child: Text(
                        product.displayPrice,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: HomeScreenTokens.productPrice(),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 4,
                        right: reservedBottomRight,
                      ),
                      child: SizedBox(
                        height: HomeScreenTokens.productTitleHeight,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            product.displayName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: HomeScreenTokens.productName(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: _CartCorner(
                  pressed: _cartPressed,
                  onTapDown: () => setState(() => _cartPressed = true),
                  onTapUp: () => setState(() => _cartPressed = false),
                  onTap: _onAddToCart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartCorner extends StatelessWidget {
  const _CartCorner({
    required this.pressed,
    required this.onTap,
    required this.onTapDown,
    required this.onTapUp,
  });

  final bool pressed;
  final VoidCallback onTap;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: HomeScreenTokens.cartCornerOuter,
      height: HomeScreenTokens.cartCornerOuter,
      decoration: BoxDecoration(
        color: HomeScreenTokens.homeBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(HomeScreenTokens.cartCornerInnerRadius),
          bottomRight: Radius.circular(HomeScreenTokens.cardRadius),
        ),
      ),
      padding: const EdgeInsets.only(
        left: HomeScreenTokens.cartButtonCornerInset,
        top: HomeScreenTokens.cartButtonCornerInset,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => onTapDown(),
        onTapUp: (_) => onTapUp(),
        onTapCancel: onTapUp,
        onTap: () {
          HapticService.light();
          onTap();
        },
        child: AnimatedScale(
          scale: pressed ? 0.9 : 1,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          child: Container(
            decoration: BoxDecoration(
              color: HomeScreenTokens.cardBg,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(HomeScreenTokens.cartButtonRadius),
                topRight: Radius.circular(HomeScreenTokens.cartButtonRadius),
                bottomLeft: Radius.circular(HomeScreenTokens.cartButtonRadius),
                bottomRight: Radius.circular(
                  HomeScreenTokens.cardRadius -
                      HomeScreenTokens.cartButtonCornerInset,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: SvgPicture.string(
              _kCartSvg,
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                Colors.black87,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
