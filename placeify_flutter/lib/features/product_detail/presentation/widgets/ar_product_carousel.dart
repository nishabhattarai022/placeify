import 'dart:ui';

import 'package:flutter/material.dart';

import 'ar_product_tray.dart' show ArAddableProduct;

/// Persistent horizontal carousel for picking which product to place next —
/// shown to the right of the "Save room shot" button in [ArRoomScreen] once
/// at least one item has been placed.
class ArProductCarousel extends StatefulWidget {
  const ArProductCarousel({
    required this.products,
    required this.onSelected,
    this.selectedProductId,
    this.enabled = true,
    super.key,
  });

  final List<ArAddableProduct> products;
  final String? selectedProductId;
  final bool enabled;
  final ValueChanged<ArAddableProduct> onSelected;

  @override
  State<ArProductCarousel> createState() => _ArProductCarouselState();
}

class _ArProductCarouselState extends State<ArProductCarousel> {
  final ScrollController _scrollController = ScrollController();
  static const double _scrollStep = 120;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollBy(double delta) {
    if (!_scrollController.hasClients) return;
    final target = (_scrollController.offset + delta).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 56,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _CarouselArrowButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: () => _scrollBy(-_scrollStep),
                ),
                Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    itemCount: widget.products.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final product = widget.products[index];
                      final selected = product.id == widget.selectedProductId;
                      return _CarouselThumbnail(
                        product: product,
                        selected: selected,
                        onTap: widget.enabled
                            ? () => widget.onSelected(product)
                            : null,
                      );
                    },
                  ),
                ),
                _CarouselArrowButton(
                  icon: Icons.chevron_right_rounded,
                  onTap: () => _scrollBy(_scrollStep),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CarouselArrowButton extends StatelessWidget {
  const _CarouselArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white70),
      iconSize: 18,
      splashRadius: 16,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }
}

class _CarouselThumbnail extends StatelessWidget {
  const _CarouselThumbnail({
    required this.product,
    required this.selected,
    required this.onTap,
  });

  final ArAddableProduct product;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final size = selected ? 44.0 : 34.0;
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? Colors.white : Colors.white10,
            border: selected ? null : Border.all(color: Colors.white24),
          ),
          clipBehavior: Clip.antiAlias,
          child: product.thumbnailUrl != null
              ? Image.network(
                  product.thumbnailUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.chair_alt_rounded,
                    size: 16,
                    color: selected ? Colors.black45 : Colors.white38,
                  ),
                )
              : Icon(
                  Icons.chair_alt_rounded,
                  size: 16,
                  color: selected ? Colors.black45 : Colors.white38,
                ),
        ),
      ),
    );
  }
}
