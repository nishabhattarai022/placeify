import 'package:ar_flutter_plugin_plus/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_plus/models/ar_hittest_result.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../home/domain/models/product.dart';

/// Helpers for anchoring furniture models flush with detected AR planes.
abstract final class ArFurniturePlacement {
  /// No vertical offset — native bottom-snap aligns the model base to the plane.
  static const floorClearanceM = 0.0;

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
  /// Native code freezes this matrix at placement — it is never updated per frame.
  static Matrix4 anchorTransformForHit(ARHitTestResult hit) {
    return Matrix4.copy(hit.worldTransform);
  }

  /// Local Y offset after native GLB bottom snap — only clearance remains here.
  static Vector3 nodeLocalOffset({
    required ProductDimensions dimensions,
    required Vector3 nodeScale,
  }) {
    return Vector3(0, floorClearanceM, 0);
  }
}
