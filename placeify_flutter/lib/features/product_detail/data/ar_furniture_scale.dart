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
  static const arLightIntensityMultiplier = 1.0;

  /// Android uses the same neutral rig as iOS after unified Filament rendering.
  static const androidArLightIntensityMultiplier = 1.0;

  /// Tripo reference bounding size in meters.
  static const _tripoReferenceMaxDimensionM = 1.0;

  /// Calibrates catalog dimensions to perceived real-world size in AR.
  static const realWorldCalibrationFactor = 1.28;

  /// Base node scale before user pinch multiplier (uniform).
  static double baseScaleFromDimensions(ProductDimensions dimensions) {
    final heightM = dimensions.heightCm / 100.0;
    final widthM = dimensions.widthCm / 100.0;
    final depthM = dimensions.depthCm / 100.0;
    // Height drives perceived furniture size (seat ~45 cm, chair ~85 cm).
    final targetMeters = [
      heightM,
      widthM,
      depthM,
    ].reduce((a, b) => a > b ? a : b);
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
