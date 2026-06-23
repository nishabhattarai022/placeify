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

  /// Raises the anchor so the model's bottom sits on the plane, not its center.
  static Matrix4 anchorTransformForHit({
    required ARHitTestResult hit,
    required ProductDimensions dimensions,
    required Vector3 nodeScale,
  }) {
    final transform = Matrix4.copy(hit.worldTransform);
    final halfHeightM = (dimensions.heightCm / 100.0) * nodeScale.y * 0.5;
    final translation = transform.getTranslation();
    transform.setTranslation(
      Vector3(
        translation.x,
        translation.y + halfHeightM + floorClearanceM,
        translation.z,
      ),
    );
    return transform;
  }
}
