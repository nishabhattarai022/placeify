import 'dart:async';
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
import 'widgets/ar_product_tray.dart';
import 'widgets/ar_room_overlays.dart';

/// One instance of a product placed in the room. Multiple instances may
/// share the same [productId] (two of the same chair) or not.
class _PlacedFurniture {
  _PlacedFurniture({
    required this.nodeName,
    required this.productId,
    required this.productName,
    required this.dimensions,
    required this.node,
    required this.anchor,
  });

  final String nodeName;
  final String productId;
  final String productName;
  final ProductDimensions dimensions;
  final ARNode node;
  final ARPlaneAnchor anchor;

  double userScaleMultiplier = ArFurnitureScale.defaultUserMultiplier;
  double placedScaleMultiplier = ArFurnitureScale.defaultUserMultiplier;
  double rotationY = 0;
  double placedRotationY = 0;

  bool isDragging = false;
  bool isRotating = false;
}

/// A product that has been chosen (either the initial one or one from the
/// tray) and is loading / waiting for a floor tap before it becomes a
/// [_PlacedFurniture].
class _PendingPlacement {
  _PendingPlacement({
    required this.productId,
    required this.productName,
    required this.dimensions,
    required this.autoPlace,
  });

  final String productId;
  final String productName;
  final ProductDimensions dimensions;
  String? modelUri;
  final bool autoPlace;
}

/// Full-screen AR furniture placement (IKEA Place–style workflow).
/// Supports placing any number of products — including repeats — in the
/// same session via the in-AR "add" tray.
class ArRoomScreen extends StatefulWidget {
  const ArRoomScreen({
    required this.remoteModelUrl,
    required this.productId,
    required this.productName,
    required this.dimensions,
    this.preloadedModel,
    this.availableProducts = const [],
    super.key,
  });

  final String remoteModelUrl;
  final String productId;
  final String productName;
  final ProductDimensions dimensions;
  final ArLocalModelFile? preloadedModel;

  /// Other catalog products the user can add to the room from the in-AR
  /// tray. Pass everything reasonable to offer here (e.g. same category,
  /// or the whole catalog) — the tray itself just lists what you give it.
  final List<ArAddableProduct> availableProducts;

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

  /// All furniture currently placed in the room, keyed by unique node name.
  final Map<String, _PlacedFurniture> _placed = {};
  int _placementCounter = 0;

  /// The item most recently tapped / placed — scale slider, reset, and
  /// remove act on this one.
  String? _selectedNodeName;

  /// The item awaiting a floor tap (or auto-place) right now, if any.
  _PendingPlacement? _pending;

  /// Node currently animating in from its placement reveal, if any.
  String? _revealingNodeName;

  bool _isPlaneDetected = false;
  bool _isDragging = false;
  bool _isRotating = false;
  bool _isPlacing = false;
  bool _modelLoading = true;
  bool _isCapturing = false;
  bool _captureFlashVisible = false;

  String _cameraTrackingState = 'INITIALIZING';
  DateTime? _trackingSince;
  DateTime? _planeDetectedAt;

  int _autoPlaceAttempts = 0;
  bool _autoPlaceScheduled = false;

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

  @override
  void initState() {
    super.initState();
    _pending = _PendingPlacement(
      productId: widget.productId,
      productName: widget.productName,
      dimensions: widget.dimensions,
      autoPlace: true,
    );
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
      unawaited(_removeAllFurniture(
        objectManager: objectManager,
        anchorManager: anchorManager,
      ));
    }

    ArFurniturePlacement.resetFloorReference();
    _sessionManager?.dispose();
    super.dispose();
  }

  double get _arLightIntensity => Platform.isAndroid
      ? ArFurnitureScale.androidArLightIntensityMultiplier
      : ArFurnitureScale.arLightIntensityMultiplier;

  bool get _hasPendingPlacement => _pending != null;

  _PlacedFurniture? get _selectedItem =>
      _selectedNodeName != null ? _placed[_selectedNodeName] : null;

  bool get _showScanOverlay =>
      !_isPlaneDetected && !_modelLoading && _hasPendingPlacement && !_isPlacing;

  bool get _showReticle =>
      _isPlaneDetected && _hasPendingPlacement && !_modelLoading && !_isPlacing;

  bool get _isTrackingReady =>
      _cameraTrackingState == 'TRACKING' &&
      _trackingSince != null &&
      DateTime.now().difference(_trackingSince!) >=
          ArFurnitureGestureConfig.trackingSettleDelay;

  @override
  Widget build(BuildContext context) {
    final selected = _selectedItem;
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
          if (_isPlacing ||
              _revealingNodeName != null ||
              _placementRevealController.isAnimating)
            IgnorePointer(
              child: ArPlacementMomentOverlay(
                progress: _placementRevealController,
                productName: _pending?.productName ?? '',
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
                        if (_placed.isNotEmpty &&
                            widget.availableProducts.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ArGlassIconButton(
                              icon: Icons.add_rounded,
                              tooltip: 'Add another item',
                              onPressed: _hasPendingPlacement
                                  ? null
                                  : _openProductTray,
                            ),
                          ),
                        if (_placed.isNotEmpty)
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
                  if (_placed.isNotEmpty) ...[
                    ArSaveRoomShotBar(
                      enabled: !_isCapturing,
                      onCapture: _onCaptureTap,
                    ),
                    if (selected != null) ...[
                      ArEditingActionsBar(
                        visible: _editingActionsVisible,
                        onReset: () {
                          _resetPlacement(selected);
                          _showEditingControls();
                        },
                      ),
                      ArScaleControlBar(
                        scaleMultiplier: selected.userScaleMultiplier,
                        minMultiplier: ArFurnitureScale.minUserMultiplier,
                        maxMultiplier: ArFurnitureScale.maxUserMultiplier,
                        onScaleChanged: (value) {
                          _onScaleSliderChanged(selected, value);
                          _showEditingControls();
                        },
                      ),
                    ],
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

    unawaited(_bootstrapArSession(objectManager));
  }

  Future<void> _bootstrapArSession(ARObjectManager objectManager) async {
    await _initSession();
    // NOTE: targetHeightMeters / androidScaleFactor are currently GLOBAL on
    // the native side (set once here). Every product placed this session is
    // normalized against widget.dimensions. If you place a second product
    // with very different real-world size, it will be scaled as if it had
    // the *first* product's proportions until FilamentArRenderer.kt and
    // AndroidARView.addNode support a per-node target height. Each
    // _PlacedFurniture still tracks its own userScaleMultiplier so users can
    // manually correct relative sizing in the meantime.
    objectManager.onInitialize(
      iosScaleFactor: ArFurnitureScale.nativeIosFactor,
      androidScaleFactor: ArFurnitureScale.nativeAndroidFactor,
      targetHeightMeters: ArFurnitureScale.targetHeightMeters(widget.dimensions),
    );
    if (!mounted) return;
    await _loadPendingModel();
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
    if (_selectedNodeName == null || !mounted) return;
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
    if (_isCapturing || _placed.isEmpty) return;

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
    _cameraTrackingState = state;
    if (state == 'TRACKING') {
      _trackingSince ??= DateTime.now();
      if (_isPlaneDetected &&
          !_modelLoading &&
          !_isPlacing &&
          _pending?.autoPlace == true &&
          _pending?.modelUri != null) {
        unawaited(_tryAutoPlace());
      }
    } else {
      _trackingSince = null;
    }
  }

  void _onPlaneDetected() {
    if (!mounted || _modelLoading || _isPlaneDetected) return;
    _planeDetectedAt = DateTime.now();
    setState(() => _isPlaneDetected = true);
    unawaited(_sessionManager?.setShowPlanes(false));
    if (_pending?.autoPlace == true && _pending?.modelUri != null) {
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

    final merged = <ARHitTestResult>[];
    for (final (x, y) in probes) {
      merged.addAll(await session.hitTestNormalized(x, y));
    }
    return merged;
  }

  /// Loads the model for whatever is currently in `_pending`.
  Future<void> _loadPendingModel() async {
    final pending = _pending;
    if (pending == null) return;

    setState(() => _modelLoading = true);

    // The very first (widget-provided) product may already be preloaded.
    final preloaded =
        pending.productId == widget.productId ? widget.preloadedModel : null;

    String? uri;
    if (preloaded != null) {
      uri = preloaded.arNodeUri;
    } else {
      final remoteUrl = pending.productId == widget.productId
          ? widget.remoteModelUrl
          : widget.availableProducts
              .firstWhere((p) => p.id == pending.productId)
              .remoteModelUrl;
      final localModel = await Product3dModelLoader.prepareForAr(
        remoteUrl: remoteUrl,
        productId: pending.productId,
        databaseProductId: ProductIdCodec.toDatabaseId(pending.productId),
      );
      uri = localModel?.arNodeUri;
    }

    if (!mounted) return;

    if (uri == null) {
      setState(() => _modelLoading = false);
      _showTransientHint(
        'Could not load the 3D model. Check your connection and try again.',
      );
      return;
    }

    setState(() {
      pending.modelUri = uri;
      _modelLoading = false;
    });

    await _sessionManager?.setLightIntensityMultiplier(_arLightIntensity);
    if (_isPlaneDetected && pending.autoPlace) {
      unawaited(_placeAfterPlaneStabilizes());
    } else if (_isPlaneDetected) {
      _showTransientHint('Tap the floor to place ${pending.productName}');
    }
  }

  Future<void> _tryAutoPlace() async {
    final pending = _pending;
    if (pending == null ||
        !pending.autoPlace ||
        pending.modelUri == null ||
        _isPlacing ||
        _autoPlaceScheduled) {
      return;
    }
    if (!_isTrackingReady) {
      await Future<void>.delayed(ArFurnitureGestureConfig.autoPlaceRetryDelay);
      if (mounted) unawaited(_tryAutoPlace());
      return;
    }
    if (_autoPlaceAttempts >= ArFurnitureGestureConfig.maxAutoPlaceAttempts) {
      _showTransientHint('Tap the floor to place ${pending.productName}');
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
    final cameraPose = await session.getCameraPose();
    final hit = ArFurniturePlacement.bestSurfaceHit(
      hits,
      cameraPose: cameraPose,
    );

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
    final pending = _pending;
    if (pending == null || _isPlacing || _modelLoading || pending.modelUri == null) {
      return;
    }

    final objectManager = _objectManager;
    final anchorManager = _anchorManager;
    final session = _sessionManager;
    if (objectManager == null || anchorManager == null) return;

    final planeHits = hitTestResults
        .where((r) => r.type == ARHitTestResultType.plane)
        .toList();
    final cameraPose = session != null ? await session.getCameraPose() : null;
    final hit = ArFurniturePlacement.bestSurfaceHit(
      planeHits.isNotEmpty ? planeHits : hitTestResults,
      cameraPose: cameraPose,
    );
    if (hit == null || hit.type != ARHitTestResultType.plane) {
      _showTransientHint('No floor surface here yet. Keep scanning the floor.');
      return;
    }

    setState(() => _isPlaneDetected = true);
    await _placeOnSurface(
      objectManager: objectManager,
      anchorManager: anchorManager,
      hit: hit,
    );
  }

  Matrix4 _placementFrameTransformFor({
    required double userScaleMultiplier,
    required double rotationY,
    required double rawT,
  }) {
    final t = rawT.clamp(0.0, 1.0);
    final eased = ArRoomUiTokens.placementSettleCurve.transform(t);
    const minScaleT = 0.08;
    final scaleT = (minScaleT + eased * (1.0 - minScaleT)).clamp(minScaleT, 1.15);
    final liftT = (1 - t).clamp(0.0, 1.0);

    final baseScale = ArFurnitureScale.nodeScaleForNativeNormalizedHeight(
      userMultiplier: userScaleMultiplier,
    );
    final scale = baseScale * scaleT;
    final lift = ArFurniturePlacement.placementLiftM * liftT;
    final offset = Vector3(0, lift, 0);

    return Matrix4.compose(
      offset,
      Quaternion.axisAngle(Vector3(0, 1, 0), rotationY),
      scale,
    );
  }

  Future<void> _placeOnSurface({
    required ARObjectManager objectManager,
    required ARAnchorManager anchorManager,
    required ARHitTestResult hit,
  }) async {
    final pending = _pending;
    final modelUri = pending?.modelUri;
    if (pending == null || modelUri == null || _isPlacing) return;
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
      _revealingNodeName = null;
      _placementRevealController.reset();

      _placementCounter++;
      final nodeName =
          '${_furnitureNodeName}_${pending.productId}_$_placementCounter';

      final anchorTransform = ArFurniturePlacement.anchorTransformForHit(hit);
      final anchor = ARPlaneAnchor(transformation: anchorTransform);
      final didAddAnchor = await anchorManager.addAnchor(anchor);
      if (didAddAnchor != true) {
        _showTransientHint('Could not anchor to this surface. Try again.');
        return;
      }

      final node = ARNode(
        type: NodeType.fileSystemAppFolderGLB,
        name: nodeName,
        uri: modelUri,
        transformation: _placementFrameTransformFor(
          userScaleMultiplier: ArFurnitureScale.defaultUserMultiplier,
          rotationY: 0,
          rawT: 0,
        ),
      );
      final didAddNode = await objectManager.addNode(node, planeAnchor: anchor);
      if (didAddNode != true) {
        await anchorManager.removeAnchor(anchor);
        _showTransientHint('Could not place the model. Try again.');
        return;
      }

      if (!mounted) return;

      final item = _PlacedFurniture(
        nodeName: nodeName,
        productId: pending.productId,
        productName: pending.productName,
        dimensions: pending.dimensions,
        node: node,
        anchor: anchor,
      );

      setState(() {
        _placed[nodeName] = item;
        _selectedNodeName = nodeName;
        _pending = null;
      });

      _revealingNodeName = nodeName;
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
  Matrix4 _restingNodeTransform(_PlacedFurniture item) {
    return Matrix4.compose(
      Vector3.zero(),
      Quaternion.axisAngle(Vector3(0, 1, 0), item.rotationY),
      ArFurnitureScale.nodeScaleForNativeNormalizedHeight(
        userMultiplier: item.userScaleMultiplier,
      ),
    );
  }

  void _finalizePlacementReveal() {
    final nodeName = _revealingNodeName;
    _revealingNodeName = null;
    _lastAppliedRevealT = null;
    if (nodeName == null) return;
    final item = _placed[nodeName];
    if (item == null) return;
    item.node.transform = _restingNodeTransform(item);
  }

  void _cancelPlacementReveal(String nodeName) {
    if (_revealingNodeName != nodeName) return;
    _revealingNodeName = null;
    _lastAppliedRevealT = null;
    _placementRevealController.stop();
    _finalizePlacementReveal();
  }

  void _onPlacementRevealTick() {
    final nodeName = _revealingNodeName;
    if (nodeName == null) return;
    final item = _placed[nodeName];
    if (item == null || item.isDragging || item.isRotating) return;

    final t = _placementRevealController.value;
    if (_lastAppliedRevealT != null &&
        t < 1.0 &&
        (t - _lastAppliedRevealT!).abs() < 0.03) {
      return;
    }
    _lastAppliedRevealT = t;
    item.node.transform = _placementFrameTransformFor(
      userScaleMultiplier: item.userScaleMultiplier,
      rotationY: item.rotationY,
      rawT: t,
    );
  }

  void _onNodeTapped(List<String> nodeNames) {
    final nodeName = nodeNames.firstWhere(
      (name) => _placed.containsKey(name),
      orElse: () => '',
    );
    if (nodeName.isEmpty) return;
    setState(() => _selectedNodeName = nodeName);
    _showEditingControls();
  }

  void _onPanStart(String nodeName) {
    final item = _placed[nodeName];
    if (item == null) return;
    _cancelPlacementReveal(nodeName);
    item.isDragging = true;
    setState(() {
      _selectedNodeName = nodeName;
      _isDragging = true;
    });
    _hintHideTimer?.cancel();
    if (mounted) setState(() => _hintVisible = false);
    _showEditingControls();
  }

  void _onPanChange(String nodeName) {
    if (!_placed.containsKey(nodeName)) return;
    _showEditingControls();
  }

  Future<void> _onPanEnd(String nodeName, Matrix4 transform) async {
    final item = _placed[nodeName];
    if (item == null) return;
    item.isDragging = false;
    setState(() => _isDragging = false);
    _writeConstrainedNodeTransform(item, transform);
    _scheduleHideEditingActions();
  }

  void _onRotationStart(String nodeName) {
    final item = _placed[nodeName];
    if (item == null) return;
    _cancelPlacementReveal(nodeName);
    item.isRotating = true;
    setState(() {
      _selectedNodeName = nodeName;
      _isRotating = true;
    });
    _hintHideTimer?.cancel();
    if (mounted) setState(() => _hintVisible = false);
    _showEditingControls();
  }

  Future<void> _onRotationEnd(String nodeName, Matrix4 transform) async {
    final item = _placed[nodeName];
    if (item == null) return;
    item.isRotating = false;
    setState(() => _isRotating = false);
    _writeConstrainedNodeTransform(item, transform);
    _scheduleHideEditingActions();
  }

  /// Single entry point for writing node transforms after gestures or UI edits.
  void _writeConstrainedNodeTransform(_PlacedFurniture item, Matrix4 raw) {
    final nextTransform = ArFurniturePlacement.constrainedLocalTransform(
      rawGestureTransform: raw,
      scale: ArFurnitureScale.nodeScaleForNativeNormalizedHeight(
        userMultiplier: item.userScaleMultiplier,
      ),
    );
    if (_matricesApproximatelyEqual(item.node.transform, nextTransform)) return;
    item.node.transform = nextTransform;
    item.rotationY = ArFurniturePlacement.yawFromTransform(nextTransform);
    item.placedRotationY = item.rotationY;
  }

  void _applyAnchoredNodeTransform(_PlacedFurniture item) {
    if (item.isDragging || item.isRotating || _revealingNodeName == item.nodeName) {
      return;
    }
    _writeConstrainedNodeTransform(item, item.node.transform);
  }

  bool _matricesApproximatelyEqual(Matrix4 a, Matrix4 b, [double epsilon = 2e-3]) {
    for (var i = 0; i < 16; i++) {
      if ((a.storage[i] - b.storage[i]).abs() > epsilon) return false;
    }
    return true;
  }

  void _onScaleSliderChanged(_PlacedFurniture item, double multiplier) {
    final clamped = multiplier.clamp(
      ArFurnitureScale.minUserMultiplier,
      ArFurnitureScale.maxUserMultiplier,
    );
    if (clamped == item.userScaleMultiplier) return;
    setState(() => item.userScaleMultiplier = clamped);
    _applyAnchoredNodeTransform(item);
  }

  void _resetPlacement(_PlacedFurniture item) {
    setState(() {
      item.userScaleMultiplier = item.placedScaleMultiplier;
      item.rotationY = item.placedRotationY;
    });
    _applyAnchoredNodeTransform(item);
    _showTransientHint('Placement reset');
  }

  /// Opens the in-AR tray so the user can pick another product to add.
  Future<void> _openProductTray() async {
    if (_hasPendingPlacement) return;
    final selected = await ArProductTray.show(
      context,
      products: widget.availableProducts,
    );
    if (selected == null || !mounted) return;

    setState(() {
      _pending = _PendingPlacement(
        productId: selected.id,
        productName: selected.name,
        dimensions: selected.dimensions,
        autoPlace: false,
      );
      _autoPlaceAttempts = 0;
    });
    await _loadPendingModel();
  }

  /// Removes a single placed item (e.g. via a "remove" action on the
  /// selected item's editing controls).
  // ignore: unused_element
  Future<void> _removeItem(String nodeName) async {
    final item = _placed[nodeName];
    final objectManager = _objectManager;
    final anchorManager = _anchorManager;
    if (item == null || objectManager == null || anchorManager == null) return;

    await objectManager.removeNode(item.node);
    await anchorManager.removeAnchor(item.anchor);

    if (!mounted) return;
    setState(() {
      _placed.remove(nodeName);
      if (_selectedNodeName == nodeName) {
        _selectedNodeName = _placed.keys.isEmpty ? null : _placed.keys.last;
      }
      if (_revealingNodeName == nodeName) _revealingNodeName = null;
    });
  }

  Future<void> _removeAllFurniture({
    required ARObjectManager objectManager,
    required ARAnchorManager anchorManager,
  }) async {
    for (final item in _placed.values.toList()) {
      await objectManager.removeNode(item.node);
      await anchorManager.removeAnchor(item.anchor);
    }
    _placed.clear();
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
    List<ArAddableProduct> availableProducts = const [],
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
            availableProducts: availableProducts,
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
