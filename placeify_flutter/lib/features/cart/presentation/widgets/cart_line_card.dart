import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/haptic_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../../home/domain/models/product.dart';
import '../../data/cart_display_config.dart';
import '../../domain/cart_line_item.dart';
import '../cart_tokens.dart';
import 'cart_quantity_controls.dart';

const String _kTrashSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
  <g>
    <path d="M21 5.98047C17.67 5.65047 14.32 5.48047 10.98 5.48047C9 5.48047 7.02 5.58047 5.04 5.78047L3 5.98047" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
    <path d="M8.5 4.97L8.72 3.66C8.88 2.71 9 2 10.69 2H13.31C15 2 15.13 2.75 15.28 3.67L15.5 4.97" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
    <path d="M18.85 9.14062L18.2 19.2106C18.09 20.7806 18 22.0006 15.21 22.0006H8.79002C6.00002 22.0006 5.91002 20.7806 5.80002 19.2106L5.15002 9.14062" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
    <path d="M10.33 16.5H13.66" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
    <path d="M9.5 12.5H14.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
  </g>
</svg>
''';

class CartLineCard extends ConsumerWidget {
  const CartLineCard({
    required this.item,
    required this.product,
    required this.editMode,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    super.key,
  });

  final CartLineItem item;
  final Product product;
  final bool editMode;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  bool get _isAsset => product.imageUrl.startsWith('assets/');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = CartDisplayConfig.nameFor(product.id, product.name);
    final unitPrice = CartDisplayConfig.priceFor(product.id, product.price);

    return Container(
      margin: const EdgeInsets.only(bottom: CartTokens.cardSpacing),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CartTokens.cardRadius),
        boxShadow: CartTokens.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(CartTokens.cardRadius),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  color: CartTokens.cardBackground,
                  padding: const EdgeInsets.fromLTRB(
                    CartTokens.cardHorizontalPadding,
                    CartTokens.cardVerticalPadding,
                    CartTokens.cardContentRightPadding,
                    CartTokens.cardVerticalPadding,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => context.push('/product/${product.id}'),
                        child: _ProductImage(
                          imageUrl: product.imageUrl,
                          isAsset: _isAsset,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.push('/product/${product.id}'),
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: CartTokens.productName,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Formatters.currencyDecimal(unitPrice),
                                style: CartTokens.productPrice,
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOutCubic,
                        child: editMode
                            ? const SizedBox.shrink()
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 12),
                                  CartQuantityControls(
                                    quantity: item.quantity,
                                    onIncrement: onIncrement,
                                    onDecrement: onDecrement,
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                width: editMode ? CartTokens.deleteStripWidth : 0,
                child: editMode
                    ? _DeleteStrip(onRemove: onRemove)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteStrip extends StatefulWidget {
  const _DeleteStrip({required this.onRemove});

  final VoidCallback onRemove;

  @override
  State<_DeleteStrip> createState() => _DeleteStripState();
}

class _DeleteStripState extends State<_DeleteStrip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        HapticService.medium();
        widget.onRemove();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        color: _pressed ? const Color(0xFFE5BAB3) : CartTokens.deleteBg,
        alignment: Alignment.center,
        child: AnimatedScale(
          scale: _pressed ? 0.9 : 1,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          child: SvgPicture.string(
            _kTrashSvg,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              CartTokens.deleteIcon,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl, required this.isAsset});

  final String imageUrl;
  final bool isAsset;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(CartTokens.cardImageRadius),
      child: SizedBox(
        width: CartTokens.cardImageSize,
        height: CartTokens.cardImageSize,
        child: ColoredBox(
          color: CartTokens.imageWell,
          child: isAsset
              ? Image.asset(
                  imageUrl,
                  width: CartTokens.cardImageSize,
                  height: CartTokens.cardImageSize,
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: CartTokens.cardImageSize,
                  height: CartTokens.cardImageSize,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
