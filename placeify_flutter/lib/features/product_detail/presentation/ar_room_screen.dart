import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' show pi;

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
import '../data/ar_furniture_gesture_config.dart';
import '../data/ar_furniture_placement.dart';
import '../data/ar_furniture_scale.dart';
import '../data/product_3d_model_loader.dart';
import 'webcam_ar_room_screen.dart';
import 'widgets/ar_furniture_gesture_overlay.dart';
import 'widgets/ar_placement_controls.dart';

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
  static const _furnitureNodeName = 'placeify_furniture';
  static const _hintAutoHideDuration = Duration(seconds: 3);
  static const _controlsAutoHideDuration = Duration(seconds: 4);

  ARSessionManager? _sessionManager;
  ARObjectManager? _objectManager;
  ARAnchorManager? _anchorManager;

  ARNode? _furnitureNode;
  ARPlaneAnchor? _currentAnchor;

  String? _modelUri;
  late final String _nodeName;

  bool _isWorldAnchored = false;
  bool _isPlaneDetected = false;
  bool _isPlaced = false;
  bool _isDragging = false;
  bool _isRotating = false;
  bool _isPlacing = false;
  bool _modelLoading = true;

  String _cameraTrackingState = 'INITIALIZING';
  DateTime? _trackingSince;

  int _autoPlaceAttempts = 0;
  bool _autoPlaceScheduled = false;

  double _userScaleMultiplier = ArFurnitureScale.defaultUserMultiplier;
  double _placedScaleMultiplier = ArFurnitureScale.defaultUserMultiplier;
  double _placedRotationY = 0;
  double _targetRotationY = 0;
  double _smoothedRotationY = 0;

  String? _hintMessage;
  bool _hintVisible = false;
  Timer? _hintHideTimer;

  bool _editingControlsVisible = false;
  Timer? _controlsHideTimer;

  late final AnimationController _scanPulseController;
  late final AnimationController _reticlePulseController;
  Ticker? _rotationSmoothTicker;

  @override
  void initState() {
    super.initState();
    _nodeName = '${_furnitureNodeName}_${widget.productId}';
    _scanPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _reticlePulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _rotationSmoothTicker = createTicker(_onRotationSmoothTick);
  }

  @override
  void dispose() {
    _hintHideTimer?.cancel();
    _controlsHideTimer?.cancel();
    _rotationSmoothTicker?.dispose();
    _scanPulseController.dispose();
    _reticlePulseController.dispose();

    final objectManager = _objectManager;
    final anchorManager = _anchorManager;
    if (objectManager != null && anchorManager != null) {
      unawaited(_removeFurniture(
        objectManager: objectManager,
        anchorManager: anchorManager,
      ));
    }

    _sessionManager?.dispose();
    super.dispose();
  }

  Vector3 get _nodeScale => ArFurnitureScale.nodeScale(
        dimensions: widget.dimensions,
        userMultiplier: _userScaleMultiplier,
      );

  double get _arLightIntensity => Platform.isAndroid
      ? ArFurnitureScale.androidArLightIntensityMultiplier
      : ArFurnitureScale.arLightIntensityMultiplier;

  bool get _showScanOverlay =>
      !_isPlaneDetected && !_modelLoading && !_isPlaced && !_isPlacing;

  bool get _showReticle =>
      _isPlaneDetected && !_isPlaced && !_modelLoading && !_isPlacing;

  bool get _isTrackingReady =>
      _cameraTrackingState == 'TRACKING' &&
      _trackingSince != null &&
      DateTime.now().difference(_trackingSince!) >=
          ArFurnitureGestureConfig.trackingSettleDelay;

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
          if (_showScanOverlay)
            IgnorePointer(
              child: _PlaneScanOverlay(pulse: _scanPulseController),
            ),
          if (_showReticle)
            IgnorePointer(
              child: _PlacementReticle(pulse: _reticlePulseController),
            ),
          if (_isPlaced)
            ArFurnitureGestureOverlay(
              enabled: _isPlaced && !_modelLoading,
              initialMultiplier: _userScaleMultiplier,
              currentRotationY: _targetRotationY,
              minMultiplier: ArFurnitureScale.minUserMultiplier,
              maxMultiplier: ArFurnitureScale.maxUserMultiplier,
              onMultiplierChanged: _onPinchScaleChanged,
              onRotationChanged: _onPinchRotationChanged,
              onGestureEnd: _scheduleHideEditingControls,
            ),
          SafeArea(
            child: Stack(
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
                if (_isPlaced)
                  Align(
                    alignment: Alignment.topRight,
                    child: ArDoneButton(
                      onDone: () => Navigator.of(context).pop(),
                    ),
                  ),
                if (_hintVisible && _hintMessage != null && !_isDragging && !_isRotating)
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: _ArFloatingHint(message: _hintMessage!),
                    ),
                  ),
                if (_isPlaced)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ArEditingToolbar(
                      visible: _editingControlsVisible,
                      scaleMultiplier: _userScaleMultiplier,
                      minMultiplier: ArFurnitureScale.minUserMultiplier,
                      maxMultiplier: ArFurnitureScale.maxUserMultiplier,
                      onRotate: () {
                        _rotateByStep();
                        _showEditingControls();
                      },
                      onScaleChanged: (value) {
                        _onScaleSliderChanged(value);
                        _showEditingControls();
                      },
                      onReset: () {
                        _resetPlacement();
                        _showEditingControls();
                      },
                    ),
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

    sessionManager.onPlaneDetected = _onPlaneDetected;
    sessionManager.onPlaneOrPointTap = _onPlaneTapped;
    sessionManager.onTrackingStateChanged = _onTrackingStateChanged;

    objectManager.onNodeTap = _onNodeTapped;
    objectManager.onPanStart = _onPanStart;
    objectManager.onPanChange = _onPanChange;
    objectManager.onPanEnd = _onPanEnd;
    objectManager.onRotationStart = _onRotationStart;
    objectManager.onRotationEnd = _onRotationEnd;

    _initSession();
    objectManager.onInitialize(
      iosScaleFactor: ArFurnitureScale.nativeIosFactor,
      androidScaleFactor: ArFurnitureScale.nativeAndroidFactor,
    );

    _loadModel();
    _showTransientHint('Move your phone slowly to find the floor');
  }

  Future<void> _initSession() async {
    await _sessionManager?.onInitialize(
      showAnimatedGuide: false,
      autoHideCoachingOverlay: true,
      showFeaturePoints: false,
      showPlanes: false,
      showWorldOrigin: false,
      handleTaps: true,
      handlePans: true,
      handleRotation: false,
      lightIntensityMultiplier: _arLightIntensity,
    );
    await _sessionManager?.setLightIntensityMultiplier(_arLightIntensity);
  }

  void _showEditingControls() {
    if (!_isPlaced || !mounted) return;
    _controlsHideTimer?.cancel();
    if (!_editingControlsVisible) {
      setState(() => _editingControlsVisible = true);
    }
    _scheduleHideEditingControls();
  }

  void _scheduleHideEditingControls() {
    _controlsHideTimer?.cancel();
    _controlsHideTimer = Timer(_controlsAutoHideDuration, () {
      if (!mounted || _isDragging || _isRotating) return;
      setState(() => _editingControlsVisible = false);
    });
  }

  void _showTransientHint(String message) {
    if (!mounted) return;
    _hintHideTimer?.cancel();
    setState(() {
      _hintMessage = message;
      _hintVisible = true;
    });
    _hintHideTimer = Timer(_hintAutoHideDuration, () {
      if (mounted) setState(() => _hintVisible = false);
    });
  }

  void _onTrackingStateChanged(String state, String reason) {
    if (!mounted) return;
    _cameraTrackingState = state;
    if (state == 'TRACKING') {
      _trackingSince ??= DateTime.now();
    } else {
      _trackingSince = null;
    }
  }

  void _onPlaneDetected() {
    if (!mounted || _modelLoading || _isPlaneDetected) return;
    setState(() => _isPlaneDetected = true);
    unawaited(_sessionManager?.setShowPlanes(false));
    _showTransientHint('Floor found — placing ${widget.productName}…');
    if (!_modelLoading) {
      unawaited(_placeAfterPlaneStabilizes());
    }
  }

  Future<void> _placeAfterPlaneStabilizes() async {
    await Future<void>.delayed(ArFurnitureGestureConfig.planeStabilizeDelay);
    if (mounted) unawaited(_tryAutoPlace());
  }

  Future<void> _loadModel() async {
    final localModel = await Product3dModelLoader.prepareForAr(
      remoteUrl: widget.remoteModelUrl,
      productId: widget.productId,
    );

    if (!mounted) return;

    if (localModel == null) {
      setState(() => _modelLoading = false);
      _showTransientHint(
        'Could not load the 3D model. Check your connection and try again.',
      );
      return;
    }

    setState(() {
      _modelUri = localModel.arNodeUri;
      _modelLoading = false;
    });

    await _sessionManager?.setLightIntensityMultiplier(_arLightIntensity);
    if (_isPlaneDetected) {
      unawaited(_placeAfterPlaneStabilizes());
    }
  }

  Future<void> _tryAutoPlace() async {
    if (_isPlaced || _isPlacing || _modelUri == null || _autoPlaceScheduled) {
      return;
    }
    if (!_isTrackingReady) {
      await Future<void>.delayed(ArFurnitureGestureConfig.autoPlaceRetryDelay);
      if (mounted) unawaited(_tryAutoPlace());
      return;
    }
    if (_autoPlaceAttempts >= ArFurnitureGestureConfig.maxAutoPlaceAttempts) {
      _showTransientHint('Tap the floor to place ${widget.productName}');
      return;
    }

    _autoPlaceScheduled = true;
    _autoPlaceAttempts++;

    final session = _sessionManager;
    final objectManager = _objectManager;
    final anchorManager = _anchorManager;
    if (session == null || objectManager == null || anchorManager == null) {
      _autoPlaceScheduled = false;
      return;
    }

    final hits = await session.hitTestScreenCenter();
    final hit = ArFurniturePlacement.bestSurfaceHit(hits);

    if (!mounted) {
      _autoPlaceScheduled = false;
      return;
    }

    if (hit == null || hit.type != ARHitTestResultType.plane) {
      _autoPlaceScheduled = false;
      await Future<void>.delayed(ArFurnitureGestureConfig.autoPlaceRetryDelay);
      if (mounted) unawaited(_tryAutoPlace());
      return;
    }

    _autoPlaceScheduled = false;
    await _placeOnSurface(
      objectManager: objectManager,
      anchorManager: anchorManager,
      hit: hit,
    );
  }

  Future<void> _onPlaneTapped(List<ARHitTestResult> hitTestResults) async {
    if (_isPlaced || _isPlacing || _modelLoading || _modelUri == null) return;

    final objectManager = _objectManager;
    final anchorManager = _anchorManager;
    if (objectManager == null || anchorManager == null) return;

    final planeHits = hitTestResults
        .where((r) => r.type == ARHitTestResultType.plane)
        .toList();
    final hit = ArFurniturePlacement.bestSurfaceHit(
      planeHits.isNotEmpty ? planeHits : hitTestResults,
    );
    if (hit == null) {
      _showTransientHint('No surface here yet. Keep scanning the floor.');
      return;
    }

    setState(() => _isPlaneDetected = true);
    await _placeOnSurface(
      objectManager: objectManager,
      anchorManager: anchorManager,
      hit: hit,
    );
  }

  Future<void> _placeOnSurface({
    required ARObjectManager objectManager,
    required ARAnchorManager anchorManager,
    required ARHitTestResult hit,
  }) async {
    final modelUri = _modelUri;
    if (modelUri == null || _isPlacing || _isPlaced) return;
    if (!_isTrackingReady) {
      _showTransientHint('Hold the phone steady while we lock onto the floor…');
      return;
    }
    if (hit.type != ARHitTestResultType.plane) {
      _showTransientHint('No floor surface here yet. Keep scanning.');
      return;
    }

    setState(() => _isPlacing = true);

    try {
      await _removeFurniture(
        objectManager: objectManager,
        anchorManager: anchorManager,
      );

      final anchorTransform = ArFurniturePlacement.anchorTransformForHit(hit);
      final anchor = ARPlaneAnchor(transformation: anchorTransform);
      final didAddAnchor = await anchorManager.addAnchor(anchor);
      if (didAddAnchor != true) {
        _showTransientHint('Could not anchor to this surface. Try again.');
        return;
      }

      final node = _buildFurnitureNode(modelUri);
      final didAddNode = await objectManager.addNode(node, planeAnchor: anchor);
      if (didAddNode != true) {
        await anchorManager.removeAnchor(anchor);
        _showTransientHint('Could not place the model. Try again.');
        return;
      }

      if (!mounted) return;
      setState(() {
        _furnitureNode = node;
        _currentAnchor = anchor;
        _isWorldAnchored = true;
        _isPlaced = true;
        _placedScaleMultiplier = _userScaleMultiplier;
        _placedRotationY = _smoothedRotationY;
      });
      await _sessionManager?.setShowPlanes(false);
      await _sessionManager?.setLightIntensityMultiplier(_arLightIntensity);
      _showTransientHint('Drag to move · twist to rotate');
      _showEditingControls();
    } finally {
      if (mounted) setState(() => _isPlacing = false);
    }
  }

  ARNode _buildFurnitureNode(String modelUri) {
    return ARNode(
      type: NodeType.fileSystemAppFolderGLB,
      name: _nodeName,
      uri: modelUri,
      transformation: Matrix4.compose(
        ArFurniturePlacement.nodeLocalOffset(
          dimensions: widget.dimensions,
          nodeScale: _nodeScale,
        ),
        Quaternion.axisAngle(Vector3(0, 1, 0), _smoothedRotationY),
        _nodeScale,
      ),
    );
  }

  void _onNodeTapped(List<String> nodeNames) {
    if (!_isPlaced || !nodeNames.contains(_nodeName)) return;
    _showEditingControls();
  }

  void _onPanStart(String nodeName) {
    if (!_isPlaced || nodeName != _nodeName) return;
    setState(() => _isDragging = true);
    _hintHideTimer?.cancel();
    if (mounted) setState(() => _hintVisible = false);
    _showEditingControls();
  }

  void _onPanChange(String nodeName) {
    if (!_isPlaced || nodeName != _nodeName) return;
    _showEditingControls();
  }

  Future<void> _onPanEnd(String nodeName, Matrix4 transform) async {
    if (!_isPlaced || nodeName != _nodeName) return;
    setState(() => _isDragging = false);
    // Native side already holds the final drag position; only sync rotation here.
    _syncRotationFromNode(transform);
    _scheduleHideEditingControls();
  }

  void _onRotationStart(String nodeName) {
    if (!_isPlaced || nodeName != _nodeName) return;
    setState(() => _isRotating = true);
    _hintHideTimer?.cancel();
    if (mounted) setState(() => _hintVisible = false);
    _showEditingControls();
  }

  Future<void> _onRotationEnd(String nodeName, Matrix4 transform) async {
    if (!_isPlaced || nodeName != _nodeName) return;
    setState(() => _isRotating = false);
    _furnitureNode?.transform = transform;
    _syncRotationFromNode(transform);
    _scheduleHideEditingControls();
  }

  void _onRotationSmoothTick(Duration elapsed) {
    if (_isRotating || _furnitureNode == null || !_isWorldAnchored) return;

    final delta = _targetRotationY - _smoothedRotationY;
    if (delta.abs() < 0.0005) {
      _rotationSmoothTicker?.stop();
      return;
    }

    _smoothedRotationY += delta * ArFurnitureGestureConfig.rotationSmoothFactor;
    _applyAnchoredNodeTransform();
  }

  void _syncRotationFromNode(Matrix4 transform) {
    final yaw = transform.matrixEulerAngles.y;
    _targetRotationY = yaw;
    _smoothedRotationY = yaw;
    _placedRotationY = yaw;
  }

  void _applyAnchoredNodeTransform() {
    final node = _furnitureNode;
    if (node == null || !_isWorldAnchored || _isDragging || _isRotating) return;

    // Keep translation in anchor-local space (XZ from drag, Y = floor clearance).
    // Never rebuild from world/camera position — that makes the model follow the phone.
    final localTranslation = node.transform.getTranslation();
    final nextTransform = Matrix4.compose(
      Vector3(
        localTranslation.x,
        ArFurniturePlacement.floorClearanceM,
        localTranslation.z,
      ),
      Quaternion.axisAngle(Vector3(0, 1, 0), _smoothedRotationY),
      _nodeScale,
    );

    if (_matricesApproximatelyEqual(node.transform, nextTransform)) return;
    node.transform = nextTransform;
  }

  bool _matricesApproximatelyEqual(Matrix4 a, Matrix4 b, [double epsilon = 2e-3]) {
    for (var i = 0; i < 16; i++) {
      if ((a.storage[i] - b.storage[i]).abs() > epsilon) return false;
    }
    return true;
  }

  void _rotateByStep() {
    if (!_isPlaced) return;
    _targetRotationY += pi / 4;
    _smoothedRotationY = _targetRotationY;
    _placedRotationY = _targetRotationY;
    _applyAnchoredNodeTransform();
  }

  void _onScaleSliderChanged(double multiplier) {
    if (_furnitureNode == null) return;
    final clamped = multiplier.clamp(
      ArFurnitureScale.minUserMultiplier,
      ArFurnitureScale.maxUserMultiplier,
    );
    if (clamped == _userScaleMultiplier) return;
    setState(() => _userScaleMultiplier = clamped);
    _applyAnchoredNodeTransform();
  }

  void _onPinchScaleChanged(double multiplier) {
    if (_furnitureNode == null) return;
    final clamped = multiplier.clamp(
      ArFurnitureScale.minUserMultiplier,
      ArFurnitureScale.maxUserMultiplier,
    );
    if (clamped == _userScaleMultiplier) return;
    setState(() => _userScaleMultiplier = clamped);
    _applyAnchoredNodeTransform();
    _showEditingControls();
  }

  void _onPinchRotationChanged(double rotationY) {
    if (_furnitureNode == null) return;
    _targetRotationY = rotationY;
    _smoothedRotationY = rotationY;
    _placedRotationY = rotationY;
    _applyAnchoredNodeTransform();
    _showEditingControls();
  }

  void _resetPlacement() {
    if (!_isPlaced) return;
    setState(() {
      _userScaleMultiplier = _placedScaleMultiplier;
      _targetRotationY = _placedRotationY;
      _smoothedRotationY = _placedRotationY;
    });
    _applyAnchoredNodeTransform();
    _showTransientHint('Placement reset');
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

class _PlacementReticle extends StatelessWidget {
  const _PlacementReticle({required this.pulse});

  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: pulse,
        builder: (context, child) {
          final scale = 0.94 + pulse.value * 0.06;
          return Transform.scale(scale: scale, child: child);
        },
        child: SizedBox(
          width: 72,
          height: 72,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.85),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.25),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
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

class _ArFloatingHint extends StatelessWidget {
  const _ArFloatingHint({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
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
