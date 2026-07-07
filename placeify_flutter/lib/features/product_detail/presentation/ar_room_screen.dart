import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import '../../../../core/services/haptic_service.dart';
import '../../ar/data/ar_snapshot_service.dart';
import '../../ar/data/room_snapshot_store.dart';
import '../../cart/data/product_id_codec.dart';
import '../../home/domain/models/product.dart';
import '../data/ar_furniture_gesture_config.dart';
import '../data/ar_furniture_placement.dart';
import '../data/ar_furniture_scale.dart';
import '../data/product_3d_model_loader.dart';
import 'ar_room_ui_tokens.dart';
import 'webcam_ar_room_screen.dart';
import 'widgets/ar_frosted_surface.dart';
import 'widgets/ar_placement_controls.dart';
import 'widgets/ar_room_overlays.dart';

/// Full-screen AR furniture placement (IKEA Place–style workflow).
class ArRoomScreen extends StatefulWidget {
  const ArRoomScreen({
    required this.remoteModelUrl,
    required this.productId,
    required this.productName,
    required this.dimensions,
    this.preloadedModel,
    super.key,
  });

  final String remoteModelUrl;
  final String productId;
  final String productName;
  final ProductDimensions dimensions;
  final ArLocalModelFile? preloadedModel;

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
  ArSnapshotService? _snapshotService;

  final RoomSnapshotStore _snapshotStore = RoomSnapshotStore();

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
  bool _isPlacementRevealActive = false;
  bool _isCapturing = false;
  bool _captureFlashVisible = false;

  String _cameraTrackingState = 'INITIALIZING';
  DateTime? _trackingSince;
  DateTime? _planeDetectedAt;

  int _autoPlaceAttempts = 0;
  bool _autoPlaceScheduled = false;

  double _userScaleMultiplier = ArFurnitureScale.defaultUserMultiplier;
  double _placedScaleMultiplier = ArFurnitureScale.defaultUserMultiplier;
  double _placedRotationY = 0;
  double _smoothedRotationY = 0;

  String? _hintMessage;
  bool _hintVisible = false;
  Timer? _hintHideTimer;

  bool _editingActionsVisible = false;
  Timer? _controlsHideTimer;

  late final AnimationController _scanPulseController;
  late final AnimationController _scanLineController;
  late final AnimationController _reticlePulseController;
  late final AnimationController _placementRevealController;

  double? _lastAppliedRevealT;

  // #region agent log
  void _agentLog(
    String location,
    String message,
    Map<String, dynamic> data, {
    required String hypothesisId,
  }) {
    final payload = jsonEncode({
      'sessionId': 'c092fc',
      'hypothesisId': hypothesisId,
      'location': location,
      'message': message,
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'runId': 'pre-fix',
    });
    debugPrint('AGENT_NDJSON:$payload');
    unawaited(() async {
      for (final host in const ['127.0.0.1', '192.168.1.112']) {
        try {
          final client = HttpClient();
          final request = await client.postUrl(
            Uri.parse(
              'http://$host:7719/ingest/de5a92ac-2b16-4b3f-8f80-d2c85552e64b',
            ),
          );
          request.headers.set('Content-Type', 'application/json');
          request.headers.set('X-Debug-Session-Id', 'c092fc');
          request.write(payload);
          await request.close();
          client.close(force: true);
          break;
        } catch (_) {}
      }
    }());
  }
  // #endregion

  @override
  void initState() {
    super.initState();
    _nodeName = '${_furnitureNodeName}_${widget.productId}';
    _scanPulseController = AnimationController(
      vsync: this,
      duration: ArRoomUiTokens.scanPulse,
    );
    _scanLineController = AnimationController(
      vsync: this,
      duration: ArRoomUiTokens.scanLine,
    );
    _reticlePulseController = AnimationController(
      vsync: this,
      duration: ArRoomUiTokens.reticlePulse,
    );
    _placementRevealController = AnimationController(
      vsync: this,
      duration: ArRoomUiTokens.placementReveal,
    )
      ..addListener(_onPlacementRevealTick)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _finalizePlacementReveal();
        }
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          if (mounted) setState(() {});
        }
      });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncOverlayAnimations();
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncOverlayAnimations();
    });
  }

  /// Start/stop scan and reticle animations only while their overlays are visible.
  void _syncOverlayAnimations() {
    if (_showScanOverlay) {
      if (!_scanLineController.isAnimating) _scanLineController.repeat();
      if (!_scanPulseController.isAnimating) {
        _scanPulseController.repeat(reverse: true);
      }
    } else {
      _scanLineController
        ..stop()
        ..reset();
      _scanPulseController
        ..stop()
        ..reset();
    }

    if (_showReticle) {
      if (!_reticlePulseController.isAnimating) {
        _reticlePulseController.repeat(reverse: true);
      }
    } else {
      _reticlePulseController
        ..stop()
        ..reset();
    }
  }

  @override
  void dispose() {
    _hintHideTimer?.cancel();
    _controlsHideTimer?.cancel();
    _scanPulseController.dispose();
    _scanLineController.dispose();
    _reticlePulseController.dispose();
    _placementRevealController.dispose();

    final objectManager = _objectManager;
    final anchorManager = _anchorManager;
    if (objectManager != null && anchorManager != null) {
      unawaited(_removeFurniture(
        objectManager: objectManager,
        anchorManager: anchorManager,
      ));
    }

    ArFurniturePlacement.resetFloorReference();
    _sessionManager?.dispose();
    super.dispose();
  }

  Vector3 get _nodeScale => Platform.isIOS
      ? ArFurnitureScale.nodeScaleForNativeNormalizedHeight(
          userMultiplier: _userScaleMultiplier,
        )
      : ArFurnitureScale.nodeScale(
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
          if (_showScanOverlay) ...[
            IgnorePointer(
              child: ArFloorScanOverlay(wave: _scanLineController),
            ),
            Positioned(
              left: 28,
              right: 28,
              bottom: MediaQuery.sizeOf(context).height * 0.26,
              child: IgnorePointer(
                child: ArScanInstruction(breath: _scanPulseController),
              ),
            ),
          ],
          if (_showReticle)
            IgnorePointer(
              child: ArPlacementReticle(pulse: _reticlePulseController),
            ),
          if (_isPlacing || _isPlacementRevealActive || _placementRevealController.isAnimating)
            IgnorePointer(
              child: ArPlacementMomentOverlay(
                progress: _placementRevealController,
                productName: widget.productName,
              ),
            ),
          IgnorePointer(
            child: AnimatedOpacity(
              opacity: _captureFlashVisible ? 1 : 0,
              duration: ArRoomUiTokens.captureFlash,
              curve: ArRoomUiTokens.motionCurve,
              child: const ColoredBox(color: Colors.white),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        ArGlassIconButton(
                          icon: Icons.close_rounded,
                          tooltip: 'Close',
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const Spacer(),
                        if (_isPlaced)
                          ArDoneButton(
                            onDone: () => Navigator.of(context).pop(),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: ArFloatingHint(
                      visible: _hintVisible &&
                          _hintMessage != null &&
                          (!_isDragging && !_isRotating || _isCapturing),
                      message: _hintMessage ?? '',
                    ),
                  ),
                  const Spacer(),
                  if (_isPlaced) ...[
                    ArSaveRoomShotBar(
                      enabled: !_isCapturing,
                      onCapture: _onCaptureTap,
                    ),
                    ArEditingActionsBar(
                      visible: _editingActionsVisible,
                      onReset: () {
                        _resetPlacement();
                        _showEditingControls();
                      },
                    ),
                    ArScaleControlBar(
                      scaleMultiplier: _userScaleMultiplier,
                      minMultiplier: ArFurnitureScale.minUserMultiplier,
                      maxMultiplier: ArFurnitureScale.maxUserMultiplier,
                      onScaleChanged: (value) {
                        _onScaleSliderChanged(value);
                        _showEditingControls();
                      },
                    ),
                  ],
                ],
              ),
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
    _snapshotService = ArSnapshotService(sessionManager);

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
      targetHeightMeters: Platform.isIOS
          ? ArFurnitureScale.targetHeightMeters(widget.dimensions)
          : null,
    );

    _loadModel();
  }

  Future<void> _initSession() async {
    ArFurniturePlacement.resetFloorReference();
    await _sessionManager?.onInitialize(
      showAnimatedGuide: false,
      autoHideCoachingOverlay: true,
      showFeaturePoints: false,
      showPlanes: false,
      showWorldOrigin: false,
      handleTaps: true,
      handlePans: true,
      handleRotation: true,
      lightIntensityMultiplier: _arLightIntensity,
    );
    await _sessionManager?.setLightIntensityMultiplier(_arLightIntensity);
    await _sessionManager?.setDepthOcclusionEnabled(Platform.isIOS);
  }

  void _showEditingControls() {
    if (!_isPlaced || !mounted) return;
    _controlsHideTimer?.cancel();
    if (!_editingActionsVisible) {
      setState(() => _editingActionsVisible = true);
    }
    _scheduleHideEditingActions();
  }

  void _scheduleHideEditingActions() {
    _controlsHideTimer?.cancel();
    _controlsHideTimer = Timer(_controlsAutoHideDuration, () {
      if (!mounted || _isDragging || _isRotating) return;
      setState(() => _editingActionsVisible = false);
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

  Future<void> _onCaptureTap() async {
    debugPrint(
      'AR capture tap: placed=$_isPlaced capturing=$_isCapturing '
      'snapshotService=$_snapshotService',
    );
    if (_isCapturing || !_isPlaced) return;

    setState(() => _isCapturing = true);
    try {
      HapticService.light();
      _showTransientHint('Saving room shot…');

      final bytes = await _snapshotService?.capture();
      if (!mounted) return;
      if (bytes == null || bytes.isEmpty) {
        _showTransientHint('Could not save room shot. Try again.');
        return;
      }

      setState(() => _captureFlashVisible = true);
      await Future<void>.delayed(ArRoomUiTokens.captureFlash);
      if (mounted) setState(() => _captureFlashVisible = false);

      await _snapshotStore.save(
        bytes: bytes,
        productId: widget.productId,
        productName: widget.productName,
      );
      if (!mounted) return;
      HapticService.medium();
      _showTransientHint('Room shot saved');
    } catch (e, st) {
      debugPrint('Capture failed: $e\n$st');
      if (mounted) {
        _showTransientHint('Could not save room shot. Try again.');
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  void _onTrackingStateChanged(String state, String reason) {
    if (!mounted) return;
    // #region agent log
    _agentLog(
      'ar_room_screen.dart:_onTrackingStateChanged',
      'tracking state update',
      {'state': state, 'reason': reason},
      hypothesisId: 'H1',
    );
    // #endregion
    _cameraTrackingState = state;
    if (state == 'TRACKING') {
      _trackingSince ??= DateTime.now();
      if (_isPlaneDetected &&
          !_modelLoading &&
          !_isPlaced &&
          !_isPlacing &&
          _modelUri != null) {
        unawaited(_tryAutoPlace());
      }
    } else {
      _trackingSince = null;
    }
  }

  void _onPlaneDetected() {
    if (!mounted || _modelLoading || _isPlaneDetected) return;
    // #region agent log
    _agentLog(
      'ar_room_screen.dart:_onPlaneDetected',
      'plane detected',
      {
        'modelLoading': _modelLoading,
        'modelUri': _modelUri != null,
        'trackingState': _cameraTrackingState,
      },
      hypothesisId: 'H4',
    );
    // #endregion
    _planeDetectedAt = DateTime.now();
    setState(() => _isPlaneDetected = true);
    unawaited(_sessionManager?.setShowPlanes(false));
    if (_modelUri != null) {
      unawaited(_placeAfterPlaneStabilizes());
    }
  }

  Future<void> _placeAfterPlaneStabilizes() async {
    final detectedAt = _planeDetectedAt;
    final elapsed = detectedAt == null
        ? Duration.zero
        : DateTime.now().difference(detectedAt);
    final remaining = ArFurnitureGestureConfig.planeStabilizeDelay - elapsed;
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }
    if (mounted) unawaited(_tryAutoPlace());
  }

  Future<List<ARHitTestResult>> _placementHitCandidates(
    ARSessionManager session,
  ) async {
    const probes = <(double, double)>[
      (0.5, 0.68),
      (0.5, 0.5),
      (0.5, 0.78),
    ];

    for (final (x, y) in probes) {
      final hits = await session.hitTestNormalized(x, y);
      if (ArFurniturePlacement.bestSurfaceHit(hits) != null) {
        return hits;
      }
    }
    return session.hitTestNormalized(0.5, 0.68);
  }

  Future<void> _loadModel() async {
    final preloaded = widget.preloadedModel;
    if (preloaded != null) {
      if (!mounted) return;
      setState(() {
        _modelUri = preloaded.arNodeUri;
        _modelLoading = false;
      });
      await _sessionManager?.setLightIntensityMultiplier(_arLightIntensity);
      if (_isPlaneDetected) {
        unawaited(_placeAfterPlaneStabilizes());
      }
      return;
    }

    final localModel = await Product3dModelLoader.prepareForAr(
      remoteUrl: widget.remoteModelUrl,
      productId: widget.productId,
      databaseProductId: ProductIdCodec.toDatabaseId(widget.productId),
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
    // #region agent log
    _agentLog(
      'ar_room_screen.dart:_loadModel',
      'model loaded',
      {
        'modelUri': localModel.arNodeUri,
        'planeDetected': _isPlaneDetected,
      },
      hypothesisId: 'H4',
    );
    // #endregion

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
      // #region agent log
      _agentLog(
        'ar_room_screen.dart:_tryAutoPlace',
        'blocked: tracking not ready',
        {
          'trackingState': _cameraTrackingState,
          'trackingSince': _trackingSince?.toIso8601String(),
          'attempts': _autoPlaceAttempts,
        },
        hypothesisId: 'H1',
      );
      // #endregion
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

    final hits = await _placementHitCandidates(session);
    final hit = ArFurniturePlacement.bestSurfaceHit(hits);

    // #region agent log
    _agentLog(
      'ar_room_screen.dart:_tryAutoPlace',
      'hit test result',
      {
        'attempt': _autoPlaceAttempts,
        'hitCount': hits.length,
        'hitTypes': hits.map((h) => h.type.name).toList(),
        'bestHitType': hit?.type.name,
        'bestHitDistance': hit?.distance,
      },
      hypothesisId: 'H2-H3',
    );
    // #endregion

    if (!mounted) {
      _autoPlaceScheduled = false;
      return;
    }

    if (hit == null || hit.type != ARHitTestResultType.plane) {
      // #region agent log
      _agentLog(
        'ar_room_screen.dart:_tryAutoPlace',
        'rejected hit for auto-place',
        {
          'hitNull': hit == null,
          'hitType': hit?.type.name,
        },
        hypothesisId: 'H3',
      );
      // #endregion
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
      _isPlacementRevealActive = false;
      _placementRevealController.reset();

      await _removeFurniture(
        objectManager: objectManager,
        anchorManager: anchorManager,
      );

      final anchorTransform = ArFurniturePlacement.anchorTransformForHit(hit);
      final anchor = ARPlaneAnchor(transformation: anchorTransform);
      final didAddAnchor = await anchorManager.addAnchor(anchor);
      // #region agent log
      _agentLog(
        'ar_room_screen.dart:_placeOnSurface',
        'anchor add result',
        {'didAddAnchor': didAddAnchor == true},
        hypothesisId: 'H5',
      );
      // #endregion
      if (didAddAnchor != true) {
        _showTransientHint('Could not anchor to this surface. Try again.');
        return;
      }

      final node = _buildFurnitureNode(modelUri);
      final didAddNode = await objectManager.addNode(node, planeAnchor: anchor);
      // #region agent log
      _agentLog(
        'ar_room_screen.dart:_placeOnSurface',
        'node add result',
        {
          'didAddNode': didAddNode == true,
          'modelUri': modelUri,
        },
        hypothesisId: 'H5',
      );
      // #endregion
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
      // #region agent log
      _agentLog(
        'ar_room_screen.dart:_placeOnSurface',
        'placement succeeded',
        {
          'anchorY': anchorTransform.getTranslation().y,
          'nodeLocalY': hit.worldTransform.getTranslation().y,
        },
        hypothesisId: 'H-float',
      );
      // #endregion
      _isPlacementRevealActive = true;
      _lastAppliedRevealT = null;
      _placementRevealController.forward(from: 0);
      _onPlacementRevealTick();
      await _sessionManager?.setShowPlanes(false);
      await _sessionManager?.setLightIntensityMultiplier(_arLightIntensity);
      _showTransientHint('Drag to move · twist to rotate');
      _showEditingControls();
    } finally {
      if (mounted) setState(() => _isPlacing = false);
    }
  }

  /// Resting local transform at full scale on the floor anchor.
  Matrix4 _restingNodeTransform() {
    return Matrix4.compose(
      ArFurniturePlacement.nodeLocalOffset(
        dimensions: widget.dimensions,
        nodeScale: _nodeScale,
      ),
      Quaternion.axisAngle(Vector3(0, 1, 0), _smoothedRotationY),
      _nodeScale,
    );
  }

  /// Computes the node's local transform at a given point (0→1) through the
  /// placement reveal. At t=0 the model is small and slightly lifted; by t=1
  /// it's at full scale, resting exactly on the floor.
  Matrix4 _placementFrameTransform(double rawT) {
    final t = rawT.clamp(0.0, 1.0);
    final eased = ArRoomUiTokens.placementSettleCurve.transform(t);
    const minScaleT = 0.08;
    final scaleT = (minScaleT + eased * (1.0 - minScaleT)).clamp(minScaleT, 1.15);
    final liftT = (1 - t).clamp(0.0, 1.0);

    final scale = _nodeScale * scaleT;
    final lift = ArFurniturePlacement.placementLiftM * liftT;
    final offset = ArFurniturePlacement.nodeLocalOffset(
          dimensions: widget.dimensions,
          nodeScale: _nodeScale,
        ) +
        Vector3(0, lift, 0);

    return Matrix4.compose(
      offset,
      Quaternion.axisAngle(Vector3(0, 1, 0), _smoothedRotationY),
      scale,
    );
  }

  void _finalizePlacementReveal() {
    _isPlacementRevealActive = false;
    _lastAppliedRevealT = null;
    final node = _furnitureNode;
    if (node == null || !_isWorldAnchored) return;
    node.transform = _restingNodeTransform();
  }

  void _cancelPlacementReveal() {
    if (!_isPlacementRevealActive) return;
    _isPlacementRevealActive = false;
    _lastAppliedRevealT = null;
    _placementRevealController.stop();
    _finalizePlacementReveal();
  }

  void _onPlacementRevealTick() {
    if (!_isPlacementRevealActive || _isDragging || _isRotating) return;
    final node = _furnitureNode;
    if (node == null || !_isWorldAnchored) return;

    final t = _placementRevealController.value;
    if (_lastAppliedRevealT != null &&
        t < 1.0 &&
        (t - _lastAppliedRevealT!).abs() < 0.03) {
      return;
    }
    _lastAppliedRevealT = t;
    node.transform = _placementFrameTransform(t);
  }

  ARNode _buildFurnitureNode(String modelUri) {
    return ARNode(
      type: NodeType.fileSystemAppFolderGLB,
      name: _nodeName,
      uri: modelUri,
      transformation: _placementFrameTransform(0),
    );
  }

  void _onNodeTapped(List<String> nodeNames) {
    if (!_isPlaced || !nodeNames.contains(_nodeName)) return;
    _showEditingControls();
  }

  void _onPanStart(String nodeName) {
    if (!_isPlaced || nodeName != _nodeName) return;
    _cancelPlacementReveal();
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
    _writeConstrainedNodeTransform(transform);
    _scheduleHideEditingActions();
  }

  void _onRotationStart(String nodeName) {
    if (!_isPlaced || nodeName != _nodeName) return;
    _cancelPlacementReveal();
    setState(() => _isRotating = true);
    _hintHideTimer?.cancel();
    if (mounted) setState(() => _hintVisible = false);
    _showEditingControls();
  }

  Future<void> _onRotationEnd(String nodeName, Matrix4 transform) async {
    if (!_isPlaced || nodeName != _nodeName) return;
    setState(() => _isRotating = false);
    _writeConstrainedNodeTransform(transform);
    _scheduleHideEditingActions();
  }

  void _syncRotationFromNode(Matrix4 transform) {
    final yaw = ArFurniturePlacement.yawFromTransform(transform);
    _smoothedRotationY = yaw;
    _placedRotationY = yaw;
  }

  /// Single entry point for writing node transforms after gestures or UI edits.
  void _writeConstrainedNodeTransform(Matrix4 raw) {
    final node = _furnitureNode;
    if (node == null || !_isWorldAnchored) return;

    final nextTransform = ArFurniturePlacement.constrainedLocalTransform(
      rawGestureTransform: raw,
      scale: _nodeScale,
    );
    if (_matricesApproximatelyEqual(node.transform, nextTransform)) return;
    node.transform = nextTransform;
    _syncRotationFromNode(nextTransform);
  }

  void _applyAnchoredNodeTransform() {
    final node = _furnitureNode;
    if (node == null ||
        !_isWorldAnchored ||
        _isDragging ||
        _isRotating ||
        _isPlacementRevealActive) {
      return;
    }

    _writeConstrainedNodeTransform(node.transform);
  }

  bool _matricesApproximatelyEqual(Matrix4 a, Matrix4 b, [double epsilon = 2e-3]) {
    for (var i = 0; i < 16; i++) {
      if ((a.storage[i] - b.storage[i]).abs() > epsilon) return false;
    }
    return true;
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

  void _resetPlacement() {
    if (!_isPlaced) return;
    ArFurniturePlacement.resetFloorReference();
    setState(() {
      _userScaleMultiplier = _placedScaleMultiplier;
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

    final preloaded = await Product3dModelLoader.prepareForAr(
      remoteUrl: remoteModelUrl,
      productId: productId,
      databaseProductId: ProductIdCodec.toDatabaseId(productId),
    );
    if (preloaded == null) {
      return ArRoomOpenResult.modelDownloadFailed;
    }

    if (!context.mounted) return ArRoomOpenResult.modelDownloadFailed;

    if (ArRoomScreen.hasNativeAr) {
      await Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (context) => ArRoomScreen(
            remoteModelUrl: remoteModelUrl,
            productId: productId,
            productName: productName,
            dimensions: dimensions,
            preloadedModel: preloaded,
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
