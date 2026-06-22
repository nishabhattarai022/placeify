import 'dart:io' show Platform;
import 'dart:math' as math;

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
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import '../../home/domain/models/product.dart';
import '../../../../core/widgets/ar_corner_bracket.dart';
import '../data/ar_furniture_scale.dart';
import '../data/product_3d_model_loader.dart';
import 'webcam_ar_room_screen.dart';
import 'widgets/ar_pinch_scale_overlay.dart';

/// Full-screen AR furniture placement (IKEA Place–style workflow).
class ArRoomScreen extends StatefulWidget {
  const ArRoomScreen({
    required this.remoteModelUrl,
    required this.productId,
    required this.productName,
    required this.dimensions,
    super.key,
  });

  final String remoteModelUrl;
  final String productId;
  final String productName;
  final ProductDimensions dimensions;

  static bool get hasNativeAr {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  @override
  State<ArRoomScreen> createState() => _ArRoomScreenState();
}

class _ArRoomScreenState extends State<ArRoomScreen>
    with TickerProviderStateMixin {
  static const _previewDistanceM = 1.0;
  static const _furnitureNodeName = 'placeify_furniture';
  static const _rotationStepRadians = math.pi / 12; // 15°

  ARSessionManager? _sessionManager;
  ARObjectManager? _objectManager;
  ARAnchorManager? _anchorManager;

  ARNode? _furnitureNode;
  ARPlaneAnchor? _currentAnchor;

  String? _modelUri;
  late final String _nodeName;

  bool _isPreviewMode = true;
  bool _isPlaneDetected = false;
  bool _isPlaced = false;
  bool _isDragging = false;
  bool _isPlacing = false;
  bool _modelLoading = true;

  double _userScaleMultiplier = ArFurnitureScale.defaultUserMultiplier;
  double _currentRotationY = 0;

  String? _statusMessage;

  late final AnimationController _scanPulseController;
  Ticker? _previewTicker;
  bool _previewTickInFlight = false;

  @override
  void initState() {
    super.initState();
    _nodeName = '${_furnitureNodeName}_${widget.productId}';
    _scanPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _previewTicker = createTicker(_onPreviewTick);
  }

  @override
  void dispose() {
    _previewTicker?.dispose();
    _scanPulseController.dispose();
    _sessionManager?.dispose();
    super.dispose();
  }

  Vector3 get _nodeScale => ArFurnitureScale.nodeScale(
        dimensions: widget.dimensions,
        userMultiplier: _userScaleMultiplier,
      );

  bool get _canAdjustModel =>
      !_modelLoading && !_isPlacing && _furnitureNode != null;

  @override
  Widget build(BuildContext context) {
    final showScanOverlay =
        _isPreviewMode && !_isPlaneDetected && !_modelLoading && !_isPlacing;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          ARView(
            onARViewCreated: _onArViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontal,
          ),
          if (_canAdjustModel)
            ArPinchScaleOverlay(
              enabled: true,
              initialMultiplier: _userScaleMultiplier,
              minMultiplier: ArFurnitureScale.minUserMultiplier,
              maxMultiplier: ArFurnitureScale.maxUserMultiplier,
              onMultiplierChanged: _onPinchMultiplierChanged,
            ),
          if (showScanOverlay)
            IgnorePointer(
              child: _PlaneScanOverlay(pulse: _scanPulseController),
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
                if (_isPlaneDetected && !_isPlaced)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: _SurfaceDetectedChip(),
                  ),
                if (_canAdjustModel)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ArScaleControls(
                          multiplier: _userScaleMultiplier,
                          minMultiplier: ArFurnitureScale.minUserMultiplier,
                          maxMultiplier: ArFurnitureScale.maxUserMultiplier,
                          onChanged: _onPinchMultiplierChanged,
                        ),
                        const SizedBox(width: 10),
                        ArRotationControls(
                          onRotateLeft: () => _rotateModel(-_rotationStepRadians),
                          onRotateRight: () => _rotateModel(_rotationStepRadians),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                _InstructionBanner(
                  productName: widget.productName,
                  modelLoading: _modelLoading,
                  isPreviewMode: _isPreviewMode,
                  isPlaneDetected: _isPlaneDetected,
                  isPlaced: _isPlaced,
                  isDragging: _isDragging,
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

    objectManager.onPanStart = _onPanStart;
    objectManager.onPanChange = _onPanChange;
    objectManager.onPanEnd = _onPanEnd;
    objectManager.onRotationStart = _onRotationStart;
    objectManager.onRotationChange = _onRotationChange;
    objectManager.onRotationEnd = _onRotationEnd;

    _initSession();
    objectManager.onInitialize(
      iosScaleFactor: ArFurnitureScale.nativeIosFactor,
      androidScaleFactor: ArFurnitureScale.nativeAndroidFactor,
    );

    _loadModel();
  }

  Future<void> _initSession() async {
    await _sessionManager?.onInitialize(
      showAnimatedGuide: true,
      autoHideCoachingOverlay: true,
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: false,
      handleTaps: true,
      handlePans: true,
      handleRotation: true,
      lightIntensityMultiplier: 1.25,
    );
  }

  void _onTrackingStateChanged(String state, String reason) {
    if (!mounted || _modelLoading) return;
    if (state == 'TRACKING' && !_isPlaneDetected) {
      setState(() => _isPlaneDetected = true);
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
        _modelLoading = false;
        _statusMessage =
            'Could not load the 3D model. Check your connection and try again.';
      });
      return;
    }

    setState(() {
      _modelUri = localModel.arNodeUri;
      _modelLoading = false;
      _statusMessage = null;
    });

    await _spawnPreviewNode();
    _previewTicker?.start();
  }

  Future<void> _spawnPreviewNode() async {
    final objectManager = _objectManager;
    final modelUri = _modelUri;
    if (objectManager == null || modelUri == null || _furnitureNode != null) {
      return;
    }

    final node = ARNode(
      type: NodeType.fileSystemAppFolderGLB,
      name: _nodeName,
      uri: modelUri,
      scale: _nodeScale,
      position: Vector3(0, 0, -_previewDistanceM),
      rotation: Vector4(1, 0, 0, 0),
    );

    final didAdd = await objectManager.addNode(node);
    if (!mounted) return;

    if (didAdd != true) {
      setState(() {
        _statusMessage =
            'Could not show the 3D model. Check your connection and try again.';
      });
      return;
    }

    setState(() {
      _furnitureNode = node;
      _isPreviewMode = true;
      _isPlaced = false;
    });
  }

  void _onPreviewTick(Duration elapsed) {
    if (!_isPreviewMode || _furnitureNode == null || _previewTickInFlight) {
      return;
    }
    _previewTickInFlight = true;
    _updatePreviewFollowCamera().whenComplete(() {
      _previewTickInFlight = false;
    });
  }

  Future<void> _updatePreviewFollowCamera() async {
    final session = _sessionManager;
    final node = _furnitureNode;
    if (session == null || node == null || !_isPreviewMode) return;

    final pose = await session.getCameraPose();
    if (pose == null || !_isPreviewMode) return;

    final cameraPos = pose.getTranslation();
    final forward = _cameraForward(pose);
    final target = cameraPos + forward * _previewDistanceM;
    final previewPos = Vector3(target.x, target.y - 0.15, target.z);

    node.position = previewPos;

    final yaw = math.atan2(forward.x, forward.z) + _currentRotationY;
    final rotation = Matrix4.identity()..rotateY(yaw);
    node.rotation = rotation.getRotation();
    node.scale = _nodeScale;
  }

  Vector3 _cameraForward(Matrix4 cameraPose) {
    final z = cameraPose.getColumn(2);
    return Vector3(-z.x, -z.y, -z.z).normalized();
  }

  Future<void> _onPlaneTapped(List<ARHitTestResult> hitTestResults) async {
    if (_isPlaced || _isPlacing || _modelLoading || _modelUri == null) {
      return;
    }

    final objectManager = _objectManager;
    final anchorManager = _anchorManager;
    if (objectManager == null || anchorManager == null) return;

    final planeHits = hitTestResults
        .where((r) => r.type == ARHitTestResultType.plane)
        .toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));

    if (planeHits.isEmpty) {
      _showStatus(
        'No surface here yet. Move your phone slowly until white grids appear.',
      );
      return;
    }

    setState(() {
      _isPlaneDetected = true;
      _statusMessage = null;
    });

    await _placeOnSurface(
      objectManager: objectManager,
      anchorManager: anchorManager,
      hit: planeHits.first,
    );
  }

  Future<void> _placeOnSurface({
    required ARObjectManager objectManager,
    required ARAnchorManager anchorManager,
    required ARHitTestResult hit,
  }) async {
    final modelUri = _modelUri;
    if (modelUri == null) return;

    setState(() => _isPlacing = true);
    _previewTicker?.stop();

    try {
      await _removeFurniture(objectManager: objectManager, anchorManager: anchorManager);

      final anchor = ARPlaneAnchor(transformation: hit.worldTransform);
      final didAddAnchor = await anchorManager.addAnchor(anchor);
      if (didAddAnchor != true) {
        _showStatus('Could not anchor to this surface. Try another spot.');
        await _restorePreviewAfterFailedPlace();
        return;
      }

      final node = _buildFurnitureNode(modelUri);
      final didAddNode = await objectManager.addNode(node, planeAnchor: anchor);
      if (didAddNode != true) {
        await anchorManager.removeAnchor(anchor);
        _showStatus('Could not place the model. Try another spot.');
        await _restorePreviewAfterFailedPlace();
        return;
      }

      if (!mounted) return;
      setState(() {
        _furnitureNode = node;
        _currentAnchor = anchor;
        _isPreviewMode = false;
        _isPlaced = true;
        _statusMessage = null;
      });
    } finally {
      if (mounted) setState(() => _isPlacing = false);
    }
  }

  Future<void> _restorePreviewAfterFailedPlace() async {
    _previewTicker?.start();
    setState(() {
      _isPreviewMode = true;
      _isPlaced = false;
    });
    await _spawnPreviewNode();
  }

  ARNode _buildFurnitureNode(String modelUri) {
    return ARNode(
      type: NodeType.fileSystemAppFolderGLB,
      name: _nodeName,
      uri: modelUri,
      scale: _nodeScale,
      position: Vector3.zero(),
      eulerAngles: Vector3(0, _currentRotationY, 0),
    );
  }

  void _onPanStart(String nodeName) {
    if (!_isPlaced || nodeName != _nodeName) return;
    setState(() {
      _isDragging = true;
      _statusMessage = null;
    });
  }

  void _onPanChange(String nodeName) {
    if (!_isPlaced || nodeName != _nodeName) return;
  }

  Future<void> _onPanEnd(String nodeName, Matrix4 transform) async {
    if (!_isPlaced || nodeName != _nodeName) return;

    setState(() => _isDragging = false);

    final objectManager = _objectManager;
    final anchorManager = _anchorManager;
    final modelUri = _modelUri;
    if (objectManager == null || anchorManager == null || modelUri == null) {
      return;
    }

    await _reanchorAtTransform(
      objectManager: objectManager,
      anchorManager: anchorManager,
      modelUri: modelUri,
      worldTransform: transform,
    );
  }

  void _onRotationStart(String nodeName) {
    if (!_isPlaced || nodeName != _nodeName) return;
    setState(() => _statusMessage = null);
  }

  void _onRotationChange(String nodeName) {
    if (!_isPlaced || nodeName != _nodeName) return;
  }

  void _onRotationEnd(String nodeName, Matrix4 transform) {
    if (!_isPlaced || nodeName != _nodeName) return;
    _currentRotationY = transform.matrixEulerAngles.y;
    _furnitureNode?.transform = transform;
  }

  void _rotateModel(double deltaRadians) {
    if (_furnitureNode == null) return;
    setState(() {
      _currentRotationY += deltaRadians;
      _statusMessage = null;
    });
    _applyNodeTransform();
  }

  void _applyNodeTransform() {
    final node = _furnitureNode;
    if (node == null) return;

    final scale = _nodeScale;
    if (_isPlaced) {
      node.eulerAngles = Vector3(0, _currentRotationY, 0);
      node.scale = scale;
      return;
    }

    final yaw = _currentRotationY;
    node.eulerAngles = Vector3(0, yaw, 0);
    node.scale = scale;
  }

  void _onPinchMultiplierChanged(double multiplier) {
    if (_furnitureNode == null) return;
    setState(() {
      _userScaleMultiplier = multiplier.clamp(
        ArFurnitureScale.minUserMultiplier,
        ArFurnitureScale.maxUserMultiplier,
      );
      _statusMessage = null;
    });
    _applyNodeTransform();
  }

  Future<void> _reanchorAtTransform({
    required ARObjectManager objectManager,
    required ARAnchorManager anchorManager,
    required String modelUri,
    required Matrix4 worldTransform,
  }) async {
    final node = _furnitureNode;
    if (node == null) return;

    final savedScale = node.scale;
    final savedEuler = node.eulerAngles;

    await _removeFurniture(
      objectManager: objectManager,
      anchorManager: anchorManager,
    );

    final anchor = ARPlaneAnchor(transformation: worldTransform);
    final didAddAnchor = await anchorManager.addAnchor(anchor);
    if (didAddAnchor != true) {
      _showStatus('Could not move the model. Try dragging again.');
      return;
    }

    final newNode = ARNode(
      type: NodeType.fileSystemAppFolderGLB,
      name: _nodeName,
      uri: modelUri,
      scale: savedScale,
      position: Vector3.zero(),
      eulerAngles: savedEuler,
    );

    final didAddNode = await objectManager.addNode(newNode, planeAnchor: anchor);
    if (didAddNode != true) {
      await anchorManager.removeAnchor(anchor);
      _showStatus('Could not move the model. Try dragging again.');
      return;
    }

    if (!mounted) return;
    setState(() {
      _furnitureNode = newNode;
      _currentAnchor = anchor;
    });
  }

  Future<void> _removeFurniture({
    required ARObjectManager objectManager,
    required ARAnchorManager anchorManager,
  }) async {
    final node = _furnitureNode;
    if (node != null) {
      await objectManager.removeNode(node);
      _furnitureNode = null;
    }

    final anchor = _currentAnchor;
    if (anchor != null) {
      await anchorManager.removeAnchor(anchor);
      _currentAnchor = null;
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
        child: const SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            children: [
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
    required this.modelLoading,
    required this.isPreviewMode,
    required this.isPlaneDetected,
    required this.isPlaced,
    required this.isDragging,
    this.statusMessage,
  });

  final String productName;
  final bool modelLoading;
  final bool isPreviewMode;
  final bool isPlaneDetected;
  final bool isPlaced;
  final bool isDragging;
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
              Icon(_icon(), color: Colors.white, size: 22),
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
    if (modelLoading) return 'Loading $productName…';
    if (isPlaced) {
      if (isDragging) return 'Release to set the new position.';
      return 'Drag to move. Pinch with two fingers or use +/- to resize. '
          'Twist with two fingers or tap Rotate to turn the model.';
    }
    if (!isPlaneDetected) {
      return 'Move your phone to detect a surface.';
    }
    if (isPreviewMode) {
      return 'Use +/- or pinch to resize. Tap Rotate to turn the model, '
          'then tap a surface to place $productName.';
    }
    return 'Move your phone to detect a surface.';
  }

  IconData _icon() {
    if (statusMessage != null) return Icons.info_outline;
    if (isPlaced) return Icons.check_circle_outline;
    if (isPlaneDetected) return Icons.touch_app_outlined;
    return Icons.view_in_ar_outlined;
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
    required ProductDimensions dimensions,
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
            dimensions: dimensions,
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
