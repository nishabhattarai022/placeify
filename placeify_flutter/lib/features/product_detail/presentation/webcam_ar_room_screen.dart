import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../data/ar_session_recorder.dart';

/// Laptop/desktop AR test: live webcam feed with the product GLB overlaid.
class WebcamArRoomScreen extends StatefulWidget {
  const WebcamArRoomScreen({
    required this.modelSrc,
    required this.productId,
    required this.productName,
    super.key,
  });

  final String modelSrc;
  final String productId;
  final String productName;

  @override
  State<WebcamArRoomScreen> createState() => _WebcamArRoomScreenState();
}

class _WebcamArRoomScreenState extends State<WebcamArRoomScreen> {
  CameraController? _cameraController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initCamera();
    unawaited(ArSessionRecorder.recordQuietly(widget.productId));
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          setState(() => _errorMessage = 'No camera found on this device.');
        }
        return;
      }

      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() => _cameraController = controller);
    } on CameraException catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Camera error: ${e.description}');
      }
    } on Object {
      if (mounted) {
        setState(() => _errorMessage = 'Could not start the camera.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _cameraController;
    final error = _errorMessage;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (controller != null && controller.value.isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.value.previewSize?.height ?? 1,
                height: controller.value.previewSize?.width ?? 1,
                child: CameraPreview(controller),
              ),
            )
          else if (error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          if (controller != null && controller.value.isInitialized)
            Positioned(
              left: 16,
              right: 16,
              bottom: 100,
              height: MediaQuery.sizeOf(context).height * 0.42,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ModelViewer(
                    key: ValueKey<String>(widget.modelSrc),
                    src: widget.modelSrc,
                    alt: '3D preview of ${widget.productName}',
                    backgroundColor: Colors.transparent,
                    autoRotate: false,
                    cameraControls: true,
                    disableZoom: false,
                    interactionPrompt: InteractionPrompt.none,
                  ),
                ),
              ),
            ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.45),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.62),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.view_in_ar_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Point your camera at the room. Drag the model to inspect it '
                              'over the live view.',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
