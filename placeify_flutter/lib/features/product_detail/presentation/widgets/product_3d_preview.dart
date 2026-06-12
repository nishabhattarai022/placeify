import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../data/ar_room_launcher.dart';
import '../product_detail_tokens.dart';

/// Interactive glTF / GLB viewer with optional in-room AR.
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
  WebViewController? _webViewController;
  bool _launchingAr = false;

  Future<void> _tryInRoom() async {
    if (_launchingAr) return;
    setState(() => _launchingAr = true);
    HapticService.medium();

    final launched = await ArRoomLauncher.launch(
      modelSrc: widget.modelSrc,
      webViewController: _webViewController,
    );

    if (mounted) {
      setState(() => _launchingAr = false);
      if (!launched) {
        PlaceifyToast.show(
          context,
          'AR is not available. Use a phone with ARCore (Android) or AR Quick Look (iOS).',
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
              ar: true,
              arModes: const ['scene-viewer', 'quick-look', 'webxr'],
              arPlacement: ArPlacement.floor,
              onWebViewCreated: (controller) => _webViewController = controller,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: FilledButton.icon(
                onPressed: _launchingAr ? null : _tryInRoom,
                style: FilledButton.styleFrom(
                  backgroundColor: ProductDetailTokens.cartBarBg,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      ProductDetailTokens.cartBarBg.withValues(alpha: 0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                icon: _launchingAr
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
                  _launchingAr ? 'Opening AR…' : 'Try in my room',
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
