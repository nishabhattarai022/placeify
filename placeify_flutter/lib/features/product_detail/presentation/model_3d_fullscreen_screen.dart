import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'product_detail_tokens.dart';

/// Full-screen 3D viewer used on desktop when AR camera is unavailable.
class Model3dFullscreenScreen extends StatelessWidget {
  const Model3dFullscreenScreen({
    required this.modelSrc,
    required this.productName,
    super.key,
  });

  final String modelSrc;
  final String productName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.45),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Text(
                    'AR camera needs a phone. On laptop you can rotate and zoom the model here.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
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
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Text(
                'Drag to rotate • Pinch or scroll to zoom',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
