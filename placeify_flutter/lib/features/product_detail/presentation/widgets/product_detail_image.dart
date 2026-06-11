import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductDetailImage extends StatelessWidget {
  const ProductDetailImage({
    required this.imageUrl,
    this.fit = BoxFit.contain,
    super.key,
  });

  final String imageUrl;
  final BoxFit fit;

  bool get _isAsset => imageUrl.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    if (_isAsset) {
      return Image.asset(imageUrl, fit: fit);
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder: (_, __) => const ColoredBox(color: Color(0xFFF3F3F3)),
      errorWidget: (_, __, ___) => const ColoredBox(color: Color(0xFFF3F3F3)),
    );
  }
}
