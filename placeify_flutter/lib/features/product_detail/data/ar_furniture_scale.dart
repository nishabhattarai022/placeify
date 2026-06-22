import 'package:vector_math/vector_math_64.dart';

import '../../home/domain/models/product.dart';

/// Computes realistic AR scale from catalog dimensions.
///
/// Tripo multiview GLBs are normalized to roughly one meter on the longest axis.
abstract final class ArFurnitureScale {
  static const minUserMultiplier = 0.5;
  static const maxUserMultiplier = 3.0;
  static const defaultUserMultiplier = 1.0;

  /// Native plugin factors default to ~0.33–0.4 and shrink models; use 1.0 for
  /// real-world sizing with Tripo meter-based exports.
  static const nativeIosFactor = 1.0;
  static const nativeAndroidFactor = 1.0;

  /// Brighter scene lighting so Tripo PBR textures read with their real colors.
  static const arLightIntensityMultiplier = 3.5;

  /// Tripo reference bounding size in meters.
  static const _tripoReferenceMaxDimensionM = 1.0;

  /// Base node scale before user pinch multiplier (uniform).
  static double baseScaleFromDimensions(ProductDimensions dimensions) {
    final maxCm = _maxDimensionCm(dimensions);
    final targetMeters = maxCm / 100.0;
    return (targetMeters / _tripoReferenceMaxDimensionM)
        .clamp(0.35, 2.5);
  }

  static double _maxDimensionCm(ProductDimensions dimensions) {
    return [
      dimensions.widthCm,
      dimensions.depthCm,
      dimensions.heightCm,
    ].reduce((a, b) => a > b ? a : b);
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
