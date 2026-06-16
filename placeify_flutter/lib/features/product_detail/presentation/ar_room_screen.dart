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
import 'webcam_ar_room_screen.dart';

/// Full-screen in-app AR: live camera feed with the product GLB placed in the scene.
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

class _ArRoomScreenState extends State<ArRoomScreen> {
  ARSessionManager? _sessionManager;
  ARObjectManager? _objectManager;
  ARAnchorManager? _anchorManager;

  ARNode? _placedNode;
  ARPlaneAnchor? _placedAnchor;

  String? _modelUri;
  bool _modelLoading = true;
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
                  modelLoading: _modelLoading,
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

    _loadModelAndPlace();
  }

  void _showStatus(String message) {
    if (!mounted) return;
    setState(() => _statusMessage = message);
  }

  Future<void> _loadModelAndPlace() async {
    final localModel = await Product3dModelLoader.prepareForAr(
      remoteUrl: widget.remoteModelUrl,
      productId: widget.productId,
    );

    if (!mounted) return;

    if (localModel == null) {
      setState(() {
        _modelLoading = false;
        _statusMessage =
            'Could not load the 3D model. Check your connection and try again.';
      });
      return;
    }

    setState(() {
      _modelUri = localModel.arNodeUri;
      _modelLoading = false;
    });

    await _placeModelInFront();
  }

  Future<void> _placeModelInFront() async {
    final objectManager = _objectManager;
    final modelUri = _modelUri;
    if (objectManager == null || modelUri == null || _placedNode != null) {
      return;
    }

    final node = ARNode(
      type: NodeType.fileSystemAppFolderGLB,
      uri: modelUri,
      scale: Vector3(0.35, 0.35, 0.35),
      position: Vector3(0, -0.25, -0.85),
      rotation: Vector4(1, 0, 0, 0),
    );

    final didAddNode = await objectManager.addNode(node);
    if (!mounted) return;

    if (didAddNode != true) {
      _showStatus(
        'Model loaded but could not be placed. Tap the floor to try again.',
      );
      return;
    }

    setState(() {
      _placed = true;
      _placedNode = node;
      _statusMessage =
          'Move around to view ${widget.productName}. Tap the floor to reposition.';
    });
  }

  Future<void> _onPlaneTapped(List<ARHitTestResult> hitTestResults) async {
    final objectManager = _objectManager;
    final anchorManager = _anchorManager;
    final modelUri = _modelUri;
    if (objectManager == null ||
        anchorManager == null ||
        modelUri == null ||
        _modelLoading) {
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
      uri: modelUri,
      scale: Vector3(0.35, 0.35, 0.35),
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
    required this.modelLoading,
    this.statusMessage,
  });

  final String productName;
  final bool placed;
  final bool modelLoading;
  final String? statusMessage;

  @override
  Widget build(BuildContext context) {
    final message = statusMessage ??
        (modelLoading
            ? 'Camera is on. Loading $productName…'
            : placed
                ? 'Move around to view $productName. Tap the floor to reposition.'
                : 'Scan the floor — placing $productName in your room.');

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
