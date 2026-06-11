import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../product_detail_tokens.dart';

/// Interactive glTF / GLB viewer for the product detail screen.
class Product3dPreview extends StatelessWidget {
  const Product3dPreview({
    required this.modelSrc,
    required this.productName,
    super.key,
  });

  final String modelSrc;
  final String productName;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ProductDetailTokens.thumbPillBg,
      child: ModelViewer(
        key: ValueKey<String>(modelSrc),
        src: modelSrc,
        alt: '3D preview of $productName',
        backgroundColor: ProductDetailTokens.thumbPillBg,
        autoRotate: true,
        autoRotateDelay: 0,
        cameraControls: true,
        disableZoom: false,
        interactionPrompt: InteractionPrompt.auto,
        ar: false,
      ),
    );
  }
}
