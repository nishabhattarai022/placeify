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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import '../../../../core/services/haptic_service.dart';
import '../../ar/data/ar_snapshot_service.dart';
import '../../ar/data/room_snapshot_store.dart';
import '../../ar/presentation/providers/room_snapshots_provider.dart';
import '../../cart/data/product_id_codec.dart';
import '../../home/domain/models/product.dart';
import '../data/ar_furniture_gesture_config.dart';
import '../data/ar_furniture_placement.dart';
import '../data/ar_furniture_scale.dart';
import '../data/ar_session_recorder.dart';
import '../data/product_3d_model_loader.dart';
import 'ar_room_ui_tokens.dart';
import 'webcam_ar_room_screen.dart';
import 'widgets/ar_frosted_surface.dart';
import 'widgets/ar_placement_controls.dart';
import 'widgets/ar_product_carousel.dart';
import 'widgets/ar_product_tray.dart';
import 'widgets/ar_room_overlays.dart';

/// One instance of a product placed in the room. Multiple instances may
/// share the same [productId] (two of the same chair) or not.
///
/// Each item owns its own placement-reveal [AnimationController] so that
/// placing a new item can never cut short a previous item's "grow to full
/// size" animation.
class _PlacedFurniture {
  _PlacedFurniture({
    required this.nodeName,
    required this.productId,
    required this.productName,
    required this.dimensions,
    required this.node,
    required this.anchor,
    required this.revealController,
  });

  final String nodeName;
  final String productId;
  final String productName;
  final ProductDimensions dimensions;
  final ARNode node;
  final ARPlaneAnchor anchor;
  final AnimationController revealController;

  double userScaleMultiplier = ArFurnitureScale.defaultUserMultiplier;
  double placedScaleMultiplier = ArFurnitureScale.defaultUserMultiplier;
  double rotationY = 0;
  double placedRotationY = 0;
  double? lastAppliedRevealT;

  bool isDragging = false;
  bool isRotating = false;
}

/// A product that has been chosen (either the initial one or one from the
/// carousel) and is loading / waiting for a floor tap before it becomes a
/// [_PlacedFurniture].
class _PendingPlacement {
  _PendingPlacement({
    required this.productId,
    required this.productName,
    required this.dimensions,
  });

  final String productId;
  final String productName;
  final ProductDimensions dimensions;
  String? modelUri;
}

/// Full-screen AR furniture placement (IKEA Place–style workflow).
/// Supports placing any number of products — including repeats — in the
/// same session via the persistent product carousel.
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

  /// Other catalog products the user can add to the room from the
  /// persistent carousel. Pass everything reasonable to offer here (e.g.
  /// same category, or the whole catalog).
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

  ARSessionManager? _sessionManager;
  ARObjectManager? _objectManager;
  ARAnchorManager? _anchorManager;
  ArSnapshotService? _snapshotService;

  final RoomSnapshotStore _snapshotStore = RoomSnapshotStore();

  /// All furniture currently placed in the room, keyed by unique node name.
  final Map<String, _PlacedFurniture> _placed = {};
  int _placementCounter = 0;

  /// UI product ids already recorded as an AR session this camera visit —
  /// prevents duplicate ar_session rows when the same product is placed
  /// more than once.
  final Set<String> _recordedSessionProductIds = {};

  /// The item most recently tapped / placed — the scale slider acts on
  /// this one.
  String? _selectedNodeName;

  /// The item awaiting a floor tap right now, if any.
  _PendingPlacement? _pending;

  /// The reveal controller currently animating in a just-placed item, if
  /// any — used to drive the placement-moment overlay.
  AnimationController? _activeRevealController;
  String _revealProductName = '';

  bool _isPlaneDetected = false;
  bool _isDragging = false;
  bool _isRotating = false;
  bool _isPlacing = false;
  bool _modelLoading = true;
  bool _isCapturing = false;
  bool _captureFlashVisible = false;

  String _cameraTrackingState = 'INITIALIZING';
  DateTime? _trackingSince;

  String? _hintMessage;
  bool _hintVisible = false;
  Timer? _hintHideTimer;

  late final AnimationController _scanPulseController;
  late final AnimationController _scanLineController;
  late final AnimationController _reticlePulseController;

  @override
  void initState() {
    super.initState();
    _pending = _PendingPlacement(
      productId: widget.productId,
      productName: widget.productName,
      dimensions: widget.dimensions,
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
    _scanPulseController.dispose();
    _scanLineController.dispose();
    _reticlePulseController.dispose();
    for (final item in _placed.values) {
      item.revealController.dispose();
    }

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

  Animation<double> get _revealProgress =>
      _activeRevealController ?? const AlwaysStoppedAnimation<double>(0);

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
          if (_isPlacing || _activeRevealController != null)
            IgnorePointer(
              child: ArPlacementMomentOverlay(
                progress: _revealProgress,
                productName: _revealProductName,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ArRoomUiTokens.screenPadding,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            // Slightly more room than a lone icon button;
                            // carousel still keeps the majority of the row.
                            flex: widget.availableProducts.isEmpty ? 1 : 2,
                            child: ArSaveRoomShotBar(
                              compact: true,
                              enabled: !_isCapturing,
                              onCapture: _onCaptureTap,
                            ),
                          ),
                          if (widget.availableProducts.isNotEmpty) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 5,
                              child: ArProductCarousel(
                                products: widget.availableProducts,
                                selectedProductId: _pending?.productId ??
                                    selected?.productId,
                                enabled: !_modelLoading,
                                onSelected: _selectProductForPlacement,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (selected != null) ...[
                      const SizedBox(height: 12),
                      ArScaleControlBar(
                        dimensions: selected.dimensions,
                        scaleMultiplier: selected.userScaleMultiplier,
                        minMultiplier: ArFurnitureScale.minUserMultiplier,
                        maxMultiplier: ArFurnitureScale.maxUserMultiplier,
                        onScaleChanged: (value) =>
                            _onScaleSliderChanged(selected, value),
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
    // Global native target height remains as a fallback for nodes that
    // omit per-node targetHeightMeters (backward compatible).
    objectManager.onInitialize(
      iosScaleFactor: ArFurnitureScale.nativeIosFactor,
      androidScaleFactor: ArFurnitureScale.nativeAndroidFactor,
      targetHeightMeters: ArFurnitureScale.targetHeightMetersForNative(
        widget.dimensions,
      ),
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
      // Keep profile Saved Rooms count / gallery in sync.
      ProviderScope.containerOf(context, listen: false)
          .invalidate(roomSnapshotsProvider);
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
    } else {
      _trackingSince = null;
    }
  }

  void _onPlaneDetected() {
    if (!mounted || _modelLoading || _isPlaneDetected) return;
    setState(() => _isPlaneDetected = true);
    unawaited(_sessionManager?.setShowPlanes(false));
    final pending = _pending;
    if (pending?.modelUri != null) {
      _showTransientHint('Tap the floor to place ${pending!.productName}');
    }
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

    // The user may have switched the pending selection again while this
    // model was still downloading — if so, drop this stale result.
    if (!mounted || !identical(_pending, pending)) return;

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
    if (_isPlaneDetected) {
      _showTransientHint('Tap the floor to place ${pending.productName}');
    }
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
        targetHeightMeters: ArFurnitureScale.targetHeightMetersForNative(
          pending.dimensions,
        ),
      );
      final didAddNode = await objectManager.addNode(node, planeAnchor: anchor);
      if (didAddNode != true) {
        await anchorManager.removeAnchor(anchor);
        _showTransientHint('Could not place the model. Try again.');
        return;
      }

      if (!mounted) return;

      // Each item gets its own reveal controller so placing item #2 can
      // never cut short item #1's still-playing "grow to full size"
      // animation (that was the cause of items looking permanently
      // undersized after a second/third placement).
      final revealController = AnimationController(
        vsync: this,
        duration: ArRoomUiTokens.placementReveal,
      );

      final item = _PlacedFurniture(
        nodeName: nodeName,
        productId: pending.productId,
        productName: pending.productName,
        dimensions: pending.dimensions,
        node: node,
        anchor: anchor,
        revealController: revealController,
      );

      revealController.addListener(() => _onPlacementRevealTick(nodeName));
      revealController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _finalizePlacementReveal(nodeName);
        }
        if (mounted &&
            (status == AnimationStatus.completed ||
                status == AnimationStatus.dismissed)) {
          setState(() {});
        }
      });

      setState(() {
        _placed[nodeName] = item;
        _selectedNodeName = nodeName;
        _pending = null;
      });

      // Record one AR session row per distinct product placed this visit.
      // Silently no-ops for guests / codec failures / network errors —
      // ArSessionRecorder.recordQuietly already swallows all of that.
      if (_recordedSessionProductIds.add(pending.productId)) {
        unawaited(ArSessionRecorder.recordQuietly(pending.productId));
      }

      _revealProductName = item.productName;
      _activeRevealController = revealController;
      revealController.forward(from: 0);
      _onPlacementRevealTick(nodeName);
      await _sessionManager?.setShowPlanes(false);
      await _sessionManager?.setLightIntensityMultiplier(_arLightIntensity);
      _showTransientHint('Drag to move · twist to rotate');
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

  void _finalizePlacementReveal(String nodeName) {
    final item = _placed[nodeName];
    if (item == null) return;
    item.lastAppliedRevealT = null;
    item.node.transform = _restingNodeTransform(item);
    if (_activeRevealController == item.revealController) {
      _activeRevealController = null;
    }
  }

  void _cancelPlacementReveal(String nodeName) {
    final item = _placed[nodeName];
    if (item == null || !item.revealController.isAnimating) return;
    item.revealController.stop();
    _finalizePlacementReveal(nodeName);
  }

  void _onPlacementRevealTick(String nodeName) {
    final item = _placed[nodeName];
    if (item == null || item.isDragging || item.isRotating) return;

    final t = item.revealController.value;
    final last = item.lastAppliedRevealT;
    if (last != null && t < 1.0 && (t - last).abs() < 0.03) {
      return;
    }
    item.lastAppliedRevealT = t;
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
  }

  void _onPanChange(String nodeName) {
    // No-op — kept as a named handler for the ar_object_manager callback API.
  }

  Future<void> _onPanEnd(String nodeName, Matrix4 transform) async {
    final item = _placed[nodeName];
    if (item == null) return;
    item.isDragging = false;
    setState(() => _isDragging = false);
    _writeConstrainedNodeTransform(item, transform);
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
  }

  Future<void> _onRotationEnd(String nodeName, Matrix4 transform) async {
    final item = _placed[nodeName];
    if (item == null) return;
    item.isRotating = false;
    setState(() => _isRotating = false);
    _writeConstrainedNodeTransform(item, transform);
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
    if (item.isDragging || item.isRotating || item.revealController.isAnimating) {
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

  /// Selects a product from the persistent carousel to place next — loads
  /// its model and waits for a floor tap (same tap-to-place path as the
  /// very first product).
  Future<void> _selectProductForPlacement(ArAddableProduct product) async {
    if (_pending?.productId == product.id) return;
    setState(() {
      _pending = _PendingPlacement(
        productId: product.id,
        productName: product.name,
        dimensions: product.dimensions,
      );
    });
    await _loadPendingModel();
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
            productId: productId,
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
