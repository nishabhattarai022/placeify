import 'package:flutter/material.dart';

import 'placeify_asset_fallback.dart';

/// Center-crops [child] to fill the viewport without distorting aspect ratio.
///
/// Prefer this over `FittedBox` + `VideoPlayer` or `width`/`height: infinity`
/// on images, which can stretch media on some layout constraints.
class CoverFitBox extends StatelessWidget {
  const CoverFitBox({
    required this.aspectRatio,
    required this.child,
    this.alignment = Alignment.center,
    super.key,
  });

  /// Width divided by height (must be > 0).
  final double aspectRatio;
  final Widget child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    assert(aspectRatio > 0, 'aspectRatio must be positive');

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;

        if (!maxW.isFinite || !maxH.isFinite || maxW <= 0 || maxH <= 0) {
          return child;
        }

        final viewportAspect = maxW / maxH;
        final double w;
        final double h;

        if (aspectRatio > viewportAspect) {
          h = maxH;
          w = h * aspectRatio;
        } else {
          w = maxW;
          h = w / aspectRatio;
        }

        return ClipRect(
          child: OverflowBox(
            alignment: alignment,
            maxWidth: w,
            maxHeight: h,
            minWidth: w,
            minHeight: h,
            child: SizedBox(
              width: w,
              height: h,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Full-bleed asset image using [BoxFit.cover] under tight expand constraints.
class CoverAssetImage extends StatelessWidget {
  const CoverAssetImage({
    required this.asset,
    this.alignment = Alignment.center,
    this.filterQuality = FilterQuality.medium,
    this.errorBuilder,
    super.key,
  });

  final String asset;
  final Alignment alignment;
  final FilterQuality filterQuality;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset(
        asset,
        fit: BoxFit.cover,
        alignment: alignment,
        filterQuality: filterQuality,
        errorBuilder:
            errorBuilder ?? (_, __, ___) => const PlaceifyAssetFallback(),
      ),
    );
  }
}
