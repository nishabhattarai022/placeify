import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:placeify/features/shops/data/shop_listing_images.dart';

/// Loads a shop logo or banner from assets or the network.
class ShopListingImage extends StatelessWidget {
  const ShopListingImage({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackUrl = ShopListingImages.defaultLogo,
    this.memCacheWidth,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String fallbackUrl;
  final int? memCacheWidth;

  @override
  Widget build(BuildContext context) {
    final child = _buildImage(imageUrl);

    if (borderRadius == null) {
      return SizedBox(width: width, height: height, child: child);
    }

    return ClipRRect(
      borderRadius: borderRadius!,
      child: SizedBox(width: width, height: height, child: child),
    );
  }

  Widget _buildImage(String url) {
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildImage(fallbackUrl),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: memCacheWidth,
      errorWidget: (_, __, ___) => _buildImage(fallbackUrl),
    );
  }
}
