import 'dart:io' show Platform;

import 'package:ar_flutter_plugin_plus/ar_flutter_plugin_plus.dart';
import 'package:ar_flutter_plugin_plus/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_plus/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_plus/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_plus/models/ar_anchor.dart';
import 'package:ar_flutter_plugin_plus/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_plus/models/ar_node.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import '../../../../core/widgets/ar_corner_bracket.dart';
import '../data/product_3d_model_loader.dart';
import 'webcam_ar_room_screen.dart';

/// Default scale for Tripo GLB furniture in AR (meters-ish after native factors).
const _kFurnitureScale = 0.35;

/// Full-screen in-app AR: plane scan → tap to place → anchored furniture.
class ArRoomScreen extends StatefulWidget {
  const ArRoomScreen({
    required this.remoteModelUrl,
    required this.productId,
    required this.productName,
    super.key,
  });

  final String remoteModelUrl;
  final String productId;
  final String productName;

  static bool get hasNativeAr {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  @override
  State<ArRoomScreen> createState() => _ArRoomScreenState();
}

enum _ArPhase {
  loadingModel,
  scanning,
  readyToPlace,
  placed,
}

class _ArRoomScreenState extends State<ArRoomScreen>
    with SingleTickerProviderStateMixin {
  ARSessionManager? _sessionManager;
  ARObjectManager? _objectManager;
  ARAnchorManager? _anchorManager;

  ARNode? _placedNode;
  ARPlaneAnchor? _placedAnchor;

  String? _modelUri;
  _ArPhase _phase = _ArPhase.loadingModel;
  bool _surfaceDetected = false;
  bool _isPlacing = false;
  String? _statusMessage;

  late final AnimationController _scanPulseController;

  @override
  void initState() {
    super.initState();
    _scanPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanPulseController.dispose();
    _sessionManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showScanOverlay =
        !_surfaceDetected && _phase != _ArPhase.loadingModel && !_isPlacing;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          ARView(
            onARViewCreated: _onArViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontal,
          ),
          if (showScanOverlay)
            IgnorePointer(
              child: _PlaneScanOverlay(
                pulse: _scanPulseController,
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
                if (_surfaceDetected && _phase != _ArPhase.placed)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: _SurfaceDetectedChip(),
                  ),
                const Spacer(),
                _InstructionBanner(
                  productName: widget.productName,
                  phase: _phase,
                  statusMessage: _statusMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onArViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    _sessionManager = sessionManager;
    _objectManager = objectManager;
    _anchorManager = anchorManager;

    sessionManager.onTrackingStateChanged = _onTrackingStateChanged;
    sessionManager.onPlaneOrPointTap = _onPlaneTapped;

    sessionManager.onInitialize(
      showAnimatedGuide: true,
      autoHideCoachingOverlay: true,
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: false,
      handleTaps: true,
    );
    objectManager.onInitialize();

    _loadModel();
  }

  void _onTrackingStateChanged(String state, String reason) {
    if (!mounted || _phase == _ArPhase.loadingModel) return;

    // ARCore reports TRACKING when the session is stable enough to detect planes.
    if (state == 'TRACKING' && !_surfaceDetected) {
      setState(() {
        _surfaceDetected = true;
        if (_phase == _ArPhase.scanning) {
          _phase = _ArPhase.readyToPlace;
        }
      });
    }
  }

  void _showStatus(String message) {
    if (!mounted) return;
    setState(() => _statusMessage = message);
  }

  Future<void> _loadModel() async {
    final localModel = await Product3dModelLoader.prepareForAr(
      remoteUrl: widget.remoteModelUrl,
      productId: widget.productId,
    );

    if (!mounted) return;

    if (localModel == null) {
      setState(() {
        _phase = _ArPhase.scanning;
        _statusMessage =
            'Could not load the 3D model. Check your connection and try again.';
      });
      return;
    }

    setState(() {
      _modelUri = localModel.arNodeUri;
      _phase = _ArPhase.scanning;
      _statusMessage = null;
    });
  }

  Future<void> _onPlaneTapped(List<ARHitTestResult> hitTestResults) async {
    final objectManager = _objectManager;
    final anchorManager = _anchorManager;
    final modelUri = _modelUri;

    if (objectManager == null ||
        anchorManager == null ||
        modelUri == null ||
        _phase == _ArPhase.loadingModel ||
        _isPlacing) {
      return;
    }

    final planeHits = hitTestResults
        .where((result) => result.type == ARHitTestResultType.plane)
        .toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));

    if (planeHits.isEmpty) {
      _showStatus(
        'No surface detected here. Move your phone slowly until white grids appear, then tap again.',
      );
      return;
    }

    setState(() {
      _surfaceDetected = true;
      _statusMessage = null;
      if (_phase == _ArPhase.scanning) {
        _phase = _ArPhase.readyToPlace;
      }
    });

    await _placeFurnitureAtHit(
      objectManager: objectManager,
      anchorManager: anchorManager,
      modelUri: modelUri,
      hit: planeHits.first,
    );
  }

  Future<void> _placeFurnitureAtHit({
    required ARObjectManager objectManager,
    required ARAnchorManager anchorManager,
    required String modelUri,
    required ARHitTestResult hit,
  }) async {
    setState(() => _isPlacing = true);

    try {
      await _removePlacedFurniture(
        objectManager: objectManager,
        anchorManager: anchorManager,
      );

      final anchor = ARPlaneAnchor(transformation: hit.worldTransform);
      final didAddAnchor = await anchorManager.addAnchor(anchor);
      if (didAddAnchor != true) {
        _showStatus('Could not anchor to this surface. Try another spot.');
        return;
      }

      final node = ARNode(
        type: NodeType.fileSystemAppFolderGLB,
        uri: modelUri,
        scale: Vector3.all(_kFurnitureScale),
        position: Vector3.zero(),
        rotation: Vector4(1, 0, 0, 0),
      );

      final didAddNode = await objectManager.addNode(node, planeAnchor: anchor);
      if (didAddNode != true) {
        await anchorManager.removeAnchor(anchor);
        _showStatus('Could not place the model. Try another spot.');
        return;
      }

      if (!mounted) return;
      setState(() {
        _placedAnchor = anchor;
        _placedNode = node;
        _phase = _ArPhase.placed;
        _statusMessage = null;
      });
    } finally {
      if (mounted) {
        setState(() => _isPlacing = false);
      }
    }
  }

  Future<void> _removePlacedFurniture({
    required ARObjectManager objectManager,
    required ARAnchorManager anchorManager,
  }) async {
    final node = _placedNode;
    if (node != null) {
      await objectManager.removeNode(node);
      _placedNode = null;
    }

    final anchor = _placedAnchor;
    if (anchor != null) {
      await anchorManager.removeAnchor(anchor);
      _placedAnchor = null;
    }
  }
}

class _PlaneScanOverlay extends StatelessWidget {
  const _PlaneScanOverlay({required this.pulse});

  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: pulse,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.92 + (pulse.value * 0.08),
            child: child,
          );
        },
        child: SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            children: const [
              Positioned(
                top: 0,
                left: 0,
                child: ArCornerBracket(
                  corner: BracketCorner.topLeft,
                  color: Colors.white,
                  size: 28,
                  strokeWidth: 3,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: ArCornerBracket(
                  corner: BracketCorner.topRight,
                  color: Colors.white,
                  size: 28,
                  strokeWidth: 3,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: ArCornerBracket(
                  corner: BracketCorner.bottomLeft,
                  color: Colors.white,
                  size: 28,
                  strokeWidth: 3,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: ArCornerBracket(
                  corner: BracketCorner.bottomRight,
                  color: Colors.white,
                  size: 28,
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SurfaceDetectedChip extends StatelessWidget {
  const _SurfaceDetectedChip();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text(
              'Surface detected',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructionBanner extends StatelessWidget {
  const _InstructionBanner({
    required this.productName,
    required this.phase,
    this.statusMessage,
  });

  final String productName;
  final _ArPhase phase;
  final String? statusMessage;

  @override
  Widget build(BuildContext context) {
    final message = statusMessage ?? _defaultMessage();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.62),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                _iconForPhase(),
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
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
    );
  }

  String _defaultMessage() {
    return switch (phase) {
      _ArPhase.loadingModel => 'Loading $productName…',
      _ArPhase.scanning =>
        'Slowly scan the floor or a flat table. White grids mark detected surfaces.',
      _ArPhase.readyToPlace =>
        'Tap a highlighted surface to place $productName.',
      _ArPhase.placed =>
        'Walk around to preview $productName. Tap another surface to move it.',
    };
  }

  IconData _iconForPhase() {
    if (statusMessage != null) {
      return Icons.info_outline;
    }
    return switch (phase) {
      _ArPhase.placed => Icons.check_circle_outline,
      _ArPhase.readyToPlace => Icons.touch_app_outlined,
      _ => Icons.view_in_ar_outlined,
    };
  }
}

enum ArRoomOpenResult {
  opened,
  permissionDenied,
  modelDownloadFailed,
}

abstract final class ArRoomLauncher {
  static Future<ArRoomOpenResult> open({
    required BuildContext context,
    required String remoteModelUrl,
    required String productId,
    required String productName,
  }) async {
    final granted = await _ensureCameraPermission();
    if (!granted) {
      return ArRoomOpenResult.permissionDenied;
    }

    if (!context.mounted) return ArRoomOpenResult.modelDownloadFailed;

    if (ArRoomScreen.hasNativeAr) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (context) => ArRoomScreen(
            remoteModelUrl: remoteModelUrl,
            productId: productId,
            productName: productName,
          ),
        ),
      );
    } else {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (context) => WebcamArRoomScreen(
            modelSrc: remoteModelUrl,
            productName: productName,
          ),
        ),
      );
    }

    return ArRoomOpenResult.opened;
  }

  static Future<bool> _ensureCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) return true;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    return status.isGranted;
  }
}
