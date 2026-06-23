import 'package:ar_flutter_plugin_plus/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_plus/models/ar_hittest_result.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../home/domain/models/product.dart';

/// Helpers for anchoring furniture models flush with detected AR planes.
abstract final class ArFurniturePlacement {
  static const floorClearanceM = 0.01;

  /// Picks the closest detected plane hit, falling back to feature points.
  static ARHitTestResult? bestSurfaceHit(List<ARHitTestResult> hits) {
    if (hits.isEmpty) return null;

    final planes = hits
        .where((hit) => hit.type == ARHitTestResultType.plane)
        .toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));
    if (planes.isNotEmpty) return planes.first;

    final points = hits
        .where((hit) => hit.type == ARHitTestResultType.point)
        .toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));
    if (points.isNotEmpty) return points.first;

    return hits.first;
  }

  /// World anchor on the detected plane (floor contact point).
  ///
  /// Vertical offset for model height belongs on the node in [nodeLocalOffset],
  /// not on the anchor — keeps the anchor locked to the physical surface.
  static Matrix4 anchorTransformForHit(ARHitTestResult hit) {
    return Matrix4.copy(hit.worldTransform);
  }

  /// Local Y offset so the model's bottom rests on the anchor plane.
  static Vector3 nodeLocalOffset({
    required ProductDimensions dimensions,
    required Vector3 nodeScale,
  }) {
    final halfHeightM = (dimensions.heightCm / 100.0) * nodeScale.y * 0.5;
    return Vector3(0, halfHeightM + floorClearanceM, 0);
  }
}
