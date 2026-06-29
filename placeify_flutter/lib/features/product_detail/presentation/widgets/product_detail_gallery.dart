import 'package:flutter/material.dart';

import '../../../../core/services/haptic_service.dart';
import '../product_detail_tokens.dart';
import 'product_detail_image.dart';

/// Hero product image with a thumbnail strip below (arrows + pill of thumbs).
class ProductDetailGallery extends StatelessWidget {
  const ProductDetailGallery({
    required this.images,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<String> images;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final safeIndex = selectedIndex.clamp(0, images.length - 1);
    final heroHeight =
        MediaQuery.sizeOf(context).height *
        ProductDetailTokens.heroHeightFactor;
    final thumbs = images.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: heroHeight,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: ProductDetailImage(
                  key: ValueKey<String>(images[safeIndex]),
                  imageUrl: images[safeIndex],
                  fit: BoxFit.cover,
                ),
              ),
              // Soft elliptical floor shadow grounds the product.
              Positioned(
                left: 60,
                right: 60,
                bottom: ProductDetailTokens.heroPaddingBottom + 4,
                height: 22,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: RadialGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.12),
                          Colors.black.withValues(alpha: 0.04),
                          Colors.transparent,
                        ],
                        stops: const [0, 0.55, 1],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _ThumbnailStrip(
          thumbs: thumbs,
          selectedIndex: safeIndex.clamp(0, thumbs.length - 1),
          onSelected: onSelected,
        ),
      ],
    );
  }
}

class _ThumbnailStrip extends StatelessWidget {
  const _ThumbnailStrip({
    required this.thumbs,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> thumbs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  void _step(int delta) {
    final next = (selectedIndex + delta).clamp(0, thumbs.length - 1);
    if (next != selectedIndex) {
      HapticService.light();
      onSelected(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ProductDetailTokens.thumbPillHorizontalPadding,
      ),
      child: Row(
        children: [
          _ArrowButton(
            icon: Icons.arrow_back,
            enabled: selectedIndex > 0,
            onTap: () => _step(-1),
          ),
          const SizedBox(width: ProductDetailTokens.thumbArrowGap),
          Expanded(
            child: _ThumbPill(
              thumbs: thumbs,
              selectedIndex: selectedIndex,
              onSelected: onSelected,
            ),
          ),
          const SizedBox(width: ProductDetailTokens.thumbArrowGap),
          _ArrowButton(
            icon: Icons.arrow_forward,
            enabled: selectedIndex < thumbs.length - 1,
            onTap: () => _step(1),
          ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatefulWidget {
  const _ArrowButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<_ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<_ArrowButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enabled ? widget.onTap : null,
      onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: widget.enabled ? 1 : 0.35,
        child: AnimatedScale(
          scale: _pressed ? 0.92 : 1,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          child: Container(
            width: ProductDetailTokens.thumbArrowSize,
            height: ProductDetailTokens.thumbArrowSize,
            decoration: const BoxDecoration(
              color: ProductDetailTokens.thumbArrowBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              widget.icon,
              size: 16,
              color: ProductDetailTokens.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ThumbPill extends StatelessWidget {
  const _ThumbPill({
    required this.thumbs,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> thumbs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          ProductDetailTokens.thumbSelectedHeight +
          ProductDetailTokens.thumbPillPaddingV * 2,
      padding: const EdgeInsets.symmetric(
        horizontal: ProductDetailTokens.thumbPillPaddingH,
        vertical: ProductDetailTokens.thumbPillPaddingV,
      ),
      decoration: BoxDecoration(
        color: ProductDetailTokens.thumbPillBg,
        borderRadius: BorderRadius.circular(
          ProductDetailTokens.thumbPillRadius,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < thumbs.length; i++)
            _ThumbTile(
              imageUrl: thumbs[i],
              selected: i == selectedIndex,
              onTap: () {
                HapticService.light();
                onSelected(i);
              },
            ),
        ],
      ),
    );
  }
}

class _ThumbTile extends StatefulWidget {
  const _ThumbTile({
    required this.imageUrl,
    required this.selected,
    required this.onTap,
  });

  final String imageUrl;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_ThumbTile> createState() => _ThumbTileState();
}

class _ThumbTileState extends State<_ThumbTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          width: selected
              ? ProductDetailTokens.thumbSelectedWidth
              : ProductDetailTokens.thumbSize,
          height: selected
              ? ProductDetailTokens.thumbSelectedHeight
              : ProductDetailTokens.thumbSize,
          decoration: BoxDecoration(
            color: selected
                ? ProductDetailTokens.thumbSelectedBg
                : Colors.transparent,
            borderRadius: BorderRadius.circular(selected ? 999 : 12),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(4),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 220),
            opacity: selected ? 1 : 0.72,
            child: ProductDetailImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
