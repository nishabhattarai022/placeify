import 'package:flutter/material.dart';

import '../../../../core/services/haptic_service.dart';
import '../../../home/domain/models/product.dart';
import '../../data/product_3d_model_resolver.dart';
import '../product_detail_tokens.dart';
import 'product_3d_preview.dart';
import 'product_detail_image.dart';

enum ProductDetailViewMode { photos, preview3d }

/// Hero product media with optional 3D preview and a thumbnail strip.
class ProductDetailGallery extends StatefulWidget {
  const ProductDetailGallery({
    required this.product,
    required this.images,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final Product product;
  final List<String> images;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<ProductDetailGallery> createState() => _ProductDetailGalleryState();
}

class _ProductDetailGalleryState extends State<ProductDetailGallery> {
  ProductDetailViewMode _viewMode = ProductDetailViewMode.photos;
  late Future<String?> _preview3dSrcFuture;

  @override
  void initState() {
    super.initState();
    _preview3dSrcFuture =
        Product3dModelResolver.srcForProduct(widget.product);
  }

  @override
  void didUpdateWidget(covariant ProductDetailGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.id != widget.product.id) {
      _preview3dSrcFuture =
          Product3dModelResolver.srcForProduct(widget.product);
    }
  }

  bool get _canShow3d => Product3dModelResolver.hasPreview(widget.product);

  @override
  Widget build(BuildContext context) {
    final safeIndex = widget.selectedIndex.clamp(0, widget.images.length - 1);
    final heroHeight = MediaQuery.sizeOf(context).height *
        ProductDetailTokens.heroHeightFactor;
    final thumbs = widget.images.take(5).toList();
    final show3d = _viewMode == ProductDetailViewMode.preview3d && _canShow3d;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_canShow3d) ...[
          _ViewModeToggle(
            mode: _viewMode,
            onChanged: (mode) {
              HapticService.light();
              setState(() => _viewMode = mode);
            },
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          height: heroHeight,
          child: Stack(
            children: [
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
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  ProductDetailTokens.heroPaddingH,
                  ProductDetailTokens.heroPaddingTop,
                  ProductDetailTokens.heroPaddingH,
                  ProductDetailTokens.heroPaddingBottom,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    final scale = Tween<double>(begin: 0.96, end: 1).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    );
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: scale, child: child),
                    );
                  },
                  child: show3d
                      ? ClipRRect(
                          key: const ValueKey<String>('preview-3d'),
                          borderRadius: BorderRadius.circular(20),
                          child: FutureBuilder<String?>(
                            future: _preview3dSrcFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final src = snapshot.data;
                              if (src == null || src.isEmpty) {
                                return Center(
                                  child: Text(
                                    '3D preview is not available for this item yet.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: ProductDetailTokens.textSecondary,
                                    ),
                                  ),
                                );
                              }
                              return Product3dPreview(
                                modelSrc: src,
                                productName: widget.product.name,
                              );
                            },
                          ),
                        )
                      : ProductDetailImage(
                          key: ValueKey<String>(widget.images[safeIndex]),
                          imageUrl: widget.images[safeIndex],
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ],
          ),
        ),
        if (!show3d) ...[
          const SizedBox(height: 8),
          _ThumbnailStrip(
            thumbs: thumbs,
            selectedIndex: safeIndex.clamp(0, thumbs.length - 1),
            onSelected: widget.onSelected,
          ),
        ] else
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: Text(
              'Scaled to your dimensions • Textured from your photo',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: ProductDetailTokens.textSecondary.withValues(alpha: 0.9),
              ),
            ),
          ),
      ],
    );
  }
}

class _ViewModeToggle extends StatelessWidget {
  const _ViewModeToggle({
    required this.mode,
    required this.onChanged,
  });

  final ProductDetailViewMode mode;
  final ValueChanged<ProductDetailViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ProductDetailTokens.heroPaddingH,
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: ProductDetailTokens.thumbPillBg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Expanded(
              child: _ToggleChip(
                label: 'Photos',
                icon: Icons.photo_outlined,
                selected: mode == ProductDetailViewMode.photos,
                onTap: () => onChanged(ProductDetailViewMode.photos),
              ),
            ),
            Expanded(
              child: _ToggleChip(
                label: '3D Preview',
                icon: Icons.view_in_ar_outlined,
                selected: mode == ProductDetailViewMode.preview3d,
                onTap: () => onChanged(ProductDetailViewMode.preview3d),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected
                  ? ProductDetailTokens.textPrimary
                  : ProductDetailTokens.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? ProductDetailTokens.textPrimary
                    : ProductDetailTokens.textSecondary,
              ),
            ),
          ],
        ),
      ),
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
      height: ProductDetailTokens.thumbSelectedHeight +
          ProductDetailTokens.thumbPillPaddingV * 2,
      padding: const EdgeInsets.symmetric(
        horizontal: ProductDetailTokens.thumbPillPaddingH,
        vertical: ProductDetailTokens.thumbPillPaddingV,
      ),
      decoration: BoxDecoration(
        color: ProductDetailTokens.thumbPillBg,
        borderRadius:
            BorderRadius.circular(ProductDetailTokens.thumbPillRadius),
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
