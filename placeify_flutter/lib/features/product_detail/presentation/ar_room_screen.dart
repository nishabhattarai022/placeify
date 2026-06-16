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

import '../data/product_3d_model_loader.dart';

/// Full-screen in-app AR: live camera feed with the product GLB placed on a surface.
class ArRoomScreen extends StatefulWidget {
  const ArRoomScreen({
    required this.modelUri,
    required this.productName,
    super.key,
  });

  /// Local GLB path for [NodeType.fileSystemAppFolderGLB] (see [ArLocalModelFile.arNodeUri]).
  final String modelUri;
  final String productName;

  static bool get isSupported {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  @override
  State<ArRoomScreen> createState() => _ArRoomScreenState();
}

class _ArRoomScreenState extends State<ArRoomScreen> {
  ARSessionManager? _sessionManager;
  ARObjectManager? _objectManager;
  ARAnchorManager? _anchorManager;

  ARNode? _placedNode;
  ARPlaneAnchor? _placedAnchor;

  bool _placed = false;
  String? _statusMessage;

  @override
  void dispose() {
    _sessionManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          ARView(
            onARViewCreated: _onArViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontal,
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
                _InstructionBanner(
                  productName: widget.productName,
                  placed: _placed,
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

    sessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: false,
    );
    objectManager.onInitialize();

    sessionManager.onPlaneOrPointTap = _onPlaneTapped;
  }

  void _showStatus(String message) {
    if (!mounted) return;
    setState(() => _statusMessage = message);
  }

  Future<void> _onPlaneTapped(List<ARHitTestResult> hitTestResults) async {
    final objectManager = _objectManager;
    final anchorManager = _anchorManager;
    if (objectManager == null || anchorManager == null) {
      return;
    }

    final planeHits = hitTestResults
        .where((result) => result.type == ARHitTestResultType.plane)
        .toList();
    if (planeHits.isEmpty) {
      _showStatus('Move your phone slowly to find the floor, then tap again.');
      return;
    }

    if (_placedNode != null) {
      await objectManager.removeNode(_placedNode!);
      _placedNode = null;
    }
    if (_placedAnchor != null) {
      await anchorManager.removeAnchor(_placedAnchor!);
      _placedAnchor = null;
    }

    final hit = planeHits.first;
    final anchor = ARPlaneAnchor(transformation: hit.worldTransform);
    final didAddAnchor = await anchorManager.addAnchor(anchor);
    if (didAddAnchor != true) {
      _showStatus('Could not anchor the model. Try tapping another spot.');
      return;
    }

    final node = ARNode(
      type: NodeType.fileSystemAppFolderGLB,
      uri: widget.modelUri,
      scale: Vector3(0.35, 0.35, 0.35),
      position: Vector3.zero(),
      rotation: Vector4(1, 0, 0, 0),
    );

    final didAddNode = await objectManager.addNode(node, planeAnchor: anchor);
    if (didAddNode != true) {
      await anchorManager.removeAnchor(anchor);
      _showStatus('Could not load the 3D model. Go back and try again.');
      return;
    }

    if (!mounted) return;
    setState(() {
      _placed = true;
      _placedAnchor = anchor;
      _placedNode = node;
      _statusMessage = null;
    });
  }
}

class _InstructionBanner extends StatelessWidget {
  const _InstructionBanner({
    required this.productName,
    required this.placed,
    this.statusMessage,
  });

  final String productName;
  final bool placed;
  final String? statusMessage;

  @override
  Widget build(BuildContext context) {
    final message = statusMessage ??
        (placed
            ? 'Drag to look around. Tap the floor again to reposition $productName.'
            : 'Point your camera at the floor, then tap to place $productName.');

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
                placed ? Icons.check_circle_outline : Icons.view_in_ar_outlined,
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
}

/// Requests camera permission and opens [ArRoomScreen] when supported.
enum ArRoomOpenResult {
  opened,
  unsupported,
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
    if (!ArRoomScreen.isSupported) {
      return ArRoomOpenResult.unsupported;
    }

    final granted = await _ensureCameraPermission();
    if (!granted) {
      return ArRoomOpenResult.permissionDenied;
    }

    if (!context.mounted) return ArRoomOpenResult.modelDownloadFailed;

    final localModel = await Product3dModelLoader.prepareForAr(
      remoteUrl: remoteModelUrl,
      productId: productId,
    );
    if (localModel == null) {
      return ArRoomOpenResult.modelDownloadFailed;
    }

    if (!context.mounted) return ArRoomOpenResult.modelDownloadFailed;

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => ArRoomScreen(
          modelUri: localModel.arNodeUri,
          productName: productName,
        ),
      ),
    );
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
