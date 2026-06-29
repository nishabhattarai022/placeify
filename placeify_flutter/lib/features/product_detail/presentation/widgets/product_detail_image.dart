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
    final Widget image;
    if (_isAsset) {
      image = Image.asset(
        imageUrl,
        fit: fit,
        alignment: Alignment.center,
      );
    } else {
      image = CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        alignment: Alignment.center,
        placeholder: (_, __) => const ColoredBox(color: Color(0xFFF3F3F3)),
        errorWidget: (_, __, ___) => const ColoredBox(color: Color(0xFFF3F3F3)),
      );
    }

    if (fit == BoxFit.cover) {
      return SizedBox.expand(child: image);
    }
    return image;
  }
}
