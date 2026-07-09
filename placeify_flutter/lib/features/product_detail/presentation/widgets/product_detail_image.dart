import 'package:flutter/material.dart';
import 'package:placeify_flutter/core/widgets/placeify_image.dart';

class ProductDetailImage extends StatelessWidget {
  const ProductDetailImage({
    required this.imageUrl,
    this.fit = BoxFit.contain,
    super.key,
  });

  final String imageUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final image = PlaceifyImage(
      source: imageUrl,
      fit: fit,
      alignment: Alignment.center,
    );

    if (fit == BoxFit.cover) {
      return SizedBox.expand(child: image);
    }
    return image;
  }
}
