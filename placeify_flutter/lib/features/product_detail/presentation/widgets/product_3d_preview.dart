import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../ar_room_screen.dart';
import '../product_detail_tokens.dart';

/// Interactive glTF / GLB viewer with in-app AR room preview.
class Product3dPreview extends StatefulWidget {
  const Product3dPreview({
    required this.modelSrc,
    required this.productName,
    super.key,
  });

  final String modelSrc;
  final String productName;

  @override
  State<Product3dPreview> createState() => _Product3dPreviewState();
}

class _Product3dPreviewState extends State<Product3dPreview> {
  bool _openingAr = false;

  Future<void> _tryInRoom() async {
    if (_openingAr) return;
    setState(() => _openingAr = true);
    HapticService.medium();

    if (!ArRoomScreen.isSupported) {
      if (mounted) {
        setState(() => _openingAr = false);
        PlaceifyToast.show(
          context,
          'Try in my room works on Android and iPhone with AR support.',
        );
      }
      return;
    }

    final opened = await ArRoomLauncher.open(
      context: context,
      modelSrc: widget.modelSrc,
      productName: widget.productName,
    );

    if (mounted) {
      setState(() => _openingAr = false);
      if (!opened) {
        PlaceifyToast.show(
          context,
          'Camera access is required to preview furniture in your room.',
        );
      }
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
