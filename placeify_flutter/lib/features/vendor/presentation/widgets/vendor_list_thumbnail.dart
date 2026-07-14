import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/shimmer_loader.dart';

/// Compact list thumbnail for vendor orders and products.
///
/// Shows a clipped product image when available; otherwise falls back to an
/// initial (admin users row style) and then an optional category icon.
class VendorListThumbnail extends StatelessWidget {
  const VendorListThumbnail({
    required this.label,
    this.imageUrl,
    this.fallbackIconPath,
    this.size = 50,
    super.key,
  });

  final String label;
  final String? imageUrl;
  final String? fallbackIconPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.creamDark.withValues(alpha: 0.85),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: url != null && url.isNotEmpty
          ? _ImageContent(
              imageUrl: url,
              label: label,
              fallbackIconPath: fallbackIconPath,
              size: size,
            )
          : _InitialFallback(
              label: label,
              fallbackIconPath: fallbackIconPath,
              size: size,
            ),
    );
  }
}

class _ImageContent extends StatelessWidget {
  const _ImageContent({
    required this.imageUrl,
    required this.label,
    required this.fallbackIconPath,
    required this.size,
  });

  final String imageUrl;
  final String label;
  final String? fallbackIconPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fit =
        imageUrl.startsWith('assets/') ? BoxFit.contain : BoxFit.cover;

    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: fit,
        errorBuilder: (_, __, ___) => _InitialFallback(
          label: label,
          fallbackIconPath: fallbackIconPath,
          size: size,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder: (_, __) => const ShimmerLoader(),
      errorWidget: (_, __, ___) => _InitialFallback(
        label: label,
        fallbackIconPath: fallbackIconPath,
        size: size,
      ),
    );
  }
}

class _InitialFallback extends StatelessWidget {
  const _InitialFallback({
    required this.label,
    required this.fallbackIconPath,
    required this.size,
  });

  final String label;
  final String? fallbackIconPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (fallbackIconPath != null) {
      return Center(
        child: SvgPicture.asset(
          fallbackIconPath!,
          width: size * 0.48,
          colorFilter: const ColorFilter.mode(
            AppColors.bark,
            BlendMode.srcIn,
          ),
        ),
      );
    }

    final trimmed = label.trim();
    final initial = trimmed.isNotEmpty ? trimmed[0].toUpperCase() : '?';

    return Center(
      child: Text(
        initial,
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.w600,
          color: AppColors.bark,
        ),
      ),
    );
  }
}
