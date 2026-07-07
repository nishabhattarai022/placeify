import 'package:vector_math/vector_math_64.dart';

import '../../home/domain/models/product.dart';

/// Computes realistic AR scale from catalog dimensions.
///
/// Tripo multiview GLBs are normalized to roughly one meter on the longest axis.
abstract final class ArFurnitureScale {
  static const minUserMultiplier = 0.5;
  static const maxUserMultiplier = 2.0;
  static const defaultUserMultiplier = 1.0;

  /// Native plugin factors default to ~0.33–0.4 and shrink models; use 1.0 for
  /// real-world sizing with Tripo meter-based exports.
  static const nativeIosFactor = 1.0;
  static const nativeAndroidFactor = 1.0;

  /// Studio neutral lighting — aligned with model-viewer `environmentImage: neutral`.
  /// iOS applies ×2.2 internally on [ARSessionManager.setLightIntensityMultiplier].
  static const arLightIntensityMultiplier = 0.55;

  /// Android Filament rig — slightly below ModelViewer neutral to account for
  /// live camera fill light on the composited scene.
  static const androidArLightIntensityMultiplier = 0.9;

  /// Tripo reference bounding size in meters.
  static const _tripoReferenceMaxDimensionM = 1.0;

  /// Calibrates catalog dimensions to perceived real-world size in AR.
  static const realWorldCalibrationFactor = 1.65;

  /// Target height in meters for native iOS bounding-box normalization.
  static double targetHeightMeters(ProductDimensions dimensions) {
    final heightM = dimensions.heightCm / 100.0;
    final widthM = dimensions.widthCm / 100.0;
    final depthM = dimensions.depthCm / 100.0;
    final targetMeters = heightM > 0.15
        ? heightM
        : [heightM, widthM, depthM].reduce((a, b) => a > b ? a : b);
    return targetMeters * realWorldCalibrationFactor;
  }

  /// Node scale when native iOS already normalized mesh height to catalog size.
  static Vector3 nodeScaleForNativeNormalizedHeight({
    double userMultiplier = defaultUserMultiplier,
  }) {
    final clamped = userMultiplier.clamp(minUserMultiplier, maxUserMultiplier);
    return Vector3.all(clamped);
  }

  /// Base node scale before user pinch multiplier (uniform).
  static double baseScaleFromDimensions(ProductDimensions dimensions) {
    final heightM = dimensions.heightCm / 100.0;
    final widthM = dimensions.widthCm / 100.0;
    final depthM = dimensions.depthCm / 100.0;

    // Height is the primary perceptual cue for furniture (chair ~85 cm, table ~75 cm).
    final targetMeters = heightM > 0.15
        ? heightM
        : [heightM, widthM, depthM].reduce((a, b) => a > b ? a : b);

    return (targetMeters / _tripoReferenceMaxDimensionM * realWorldCalibrationFactor)
        .clamp(0.55, 2.8);
  }

  static Vector3 nodeScale({
    required ProductDimensions dimensions,
    double userMultiplier = defaultUserMultiplier,
  }) {
    final clamped = userMultiplier.clamp(minUserMultiplier, maxUserMultiplier);
    final base = baseScaleFromDimensions(dimensions);
    return Vector3.all(base * clamped);
  }

  static Vector3 applyUserMultiplier(Vector3 currentScale, double userMultiplier) {
    final clamped = userMultiplier.clamp(minUserMultiplier, maxUserMultiplier);
    final magnitude = currentScale.x;
    final base = magnitude / (userMultiplier == 0 ? 1 : userMultiplier);
    return Vector3.all(base * clamped);
  }
}
