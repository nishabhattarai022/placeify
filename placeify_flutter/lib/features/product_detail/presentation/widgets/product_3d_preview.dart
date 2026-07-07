import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../../home/domain/models/product.dart';
import '../../data/product_3d_model_resolver.dart';
import '../ar_room_screen.dart';
import '../product_detail_tokens.dart';

/// Interactive glTF / GLB viewer with in-app AR room preview.
class Product3dPreview extends StatefulWidget {
  const Product3dPreview({
    required this.productId,
    required this.modelSrc,
    required this.productName,
    required this.dimensions,
    super.key,
  });

  final String productId;
  final String modelSrc;
  final String productName;
  final ProductDimensions dimensions;

  @override
  State<Product3dPreview> createState() => _Product3dPreviewState();
}

class _Product3dPreviewState extends State<Product3dPreview> {
  bool _openingAr = false;

  Future<void> _tryInRoom() async {
    if (_openingAr) return;
    setState(() => _openingAr = true);
    HapticService.medium();

    try {
      final remoteUrl = Product3dModelResolver.modelUrlFor(widget.productId) ??
          (widget.modelSrc.startsWith('http') ? widget.modelSrc : null);
      if (remoteUrl == null || remoteUrl.isEmpty) {
        if (!mounted) return;
        PlaceifyToast.show(
          context,
          '3D model is not available for AR yet.',
        );
        return;
      }

      final result = await ArRoomLauncher.open(
        context: context,
        remoteModelUrl: remoteUrl,
        productId: widget.productId,
        productName: widget.productName,
        dimensions: widget.dimensions,
      );

      if (!mounted) return;

      switch (result) {
        case ArRoomOpenResult.opened:
          break;
        case ArRoomOpenResult.permissionDenied:
          PlaceifyToast.show(
            context,
            'Camera access is required to preview furniture in your room.',
          );
        case ArRoomOpenResult.modelDownloadFailed:
          PlaceifyToast.show(
            context,
            'Could not open the AR experience. Please try again.',
          );
      }
    } finally {
      if (mounted) setState(() => _openingAr = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ProductDetailTokens.thumbPillBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ModelViewer(
              key: ValueKey<String>(widget.modelSrc),
              src: widget.modelSrc,
              alt: '3D preview of ${widget.productName}',
              backgroundColor: ProductDetailTokens.thumbPillBg,
              autoRotate: true,
              autoRotateDelay: 0,
              cameraControls: true,
              disableZoom: false,
              interactionPrompt: InteractionPrompt.auto,
              exposure: 0.75,
              shadowIntensity: 0.6,
              environmentImage: 'neutral',
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: FilledButton.icon(
                onPressed: _openingAr ? null : _tryInRoom,
                style: FilledButton.styleFrom(
                  backgroundColor: ProductDetailTokens.cartBarBg,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      ProductDetailTokens.cartBarBg.withValues(alpha: 0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                icon: _openingAr
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.view_in_ar_outlined, size: 20),
                label: Text(
                  _openingAr ? 'Opening camera…' : 'Try in my room',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
