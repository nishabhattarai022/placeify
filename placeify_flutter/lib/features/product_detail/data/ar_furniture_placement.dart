import 'package:ar_flutter_plugin_plus/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_plus/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_plus/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:math' as math;
import '../../home/domain/models/product.dart';

/// Helpers for anchoring furniture models flush with detected AR planes.
abstract final class ArFurniturePlacement {
  /// No vertical offset — native bottom-snap aligns the model base to the plane.
  static const floorClearanceM = 0.0;

  /// Extra upward offset applied only during the placement reveal animation —
  /// the model starts slightly lifted and eases down as it grows to full size.
  static const placementLiftM = 0.12;

  /// Max plausible height (meters) above the first confirmed floor plane.
  /// Rejects tables, shelves, switchboards, and other elevated horizontal planes.
  static const maxFloorDeviationM = 0.12;

  /// Tracks the first accepted floor height for this AR session.
  /// Reset this externally (e.g. in ArRoomScreen) when a new session starts.
  static double? _confirmedFloorY;

  static void resetFloorReference() {
    _confirmedFloorY = null;
  }

  /// Picks the closest detected plane hit that is plausibly the floor.
  /// Falls back to feature points only if no valid plane exists.
  static ARHitTestResult? bestSurfaceHit(List<ARHitTestResult> hits) {
    if (hits.isEmpty) return null;

    final planes = hits
        .where((hit) => hit.type == ARHitTestResultType.plane)
        .toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));

    if (planes.isNotEmpty) {
      final validPlane = _selectPlausibleFloorPlane(planes);
      if (validPlane != null) return validPlane;
    }

    // No plane passed the floor-height check — do NOT fall back to a
    // random point hit for initial placement; that's how you end up on
    // walls or floating objects. Only fall back for points if there were
    // no planes detected at all (rare, early-session case).
    if (planes.isEmpty) {
      final points = hits
          .where((hit) => hit.type == ARHitTestResultType.point)
          .toList()
        ..sort((a, b) => a.distance.compareTo(b.distance));
      if (points.isNotEmpty) return points.first;
    }

    return null;
  }

  static ARHitTestResult? _selectPlausibleFloorPlane(
    List<ARHitTestResult> sortedPlanes,
  ) {
    for (final plane in sortedPlanes) {
      final y = plane.worldTransform.getTranslation().y;

      if (_confirmedFloorY == null) {
        // First plane accepted this session becomes the floor reference.
        _confirmedFloorY = y;
        return plane;
      }

      if ((y - _confirmedFloorY!).abs() <= maxFloorDeviationM) {
        return plane;
      }
      // Otherwise this plane is a table/shelf/object — skip it and try
      // the next-closest plane instead of silently accepting it.
    }
    return null;
  }

  /// World anchor on the detected plane (floor contact point).
  /// Only position + yaw are kept — pitch/roll from imperfect plane
  /// detection are discarded so the model can never anchor tilted.
  static Matrix4 anchorTransformForHit(ARHitTestResult hit) {
    final raw = hit.worldTransform;
    final translation = raw.getTranslation();
    final yaw = raw.matrixEulerAngles.y; // wall/tilt components dropped

    return Matrix4.compose(
      translation,
      Quaternion.axisAngle(Vector3(0, 1, 0), yaw),
      Vector3(1, 1, 1),
    );
  }

  /// Anchor-local Y-axis yaw (radians) for horizontal floor placement.
  /// Uses the rotation column of the 4×4 matrix — reliable with uniform scale,
  /// unlike [Matrix4.matrixEulerAngles].y which maps to pitch in this codebase.
  static double yawFromTransform(Matrix4 matrix) {
    return math.atan2(matrix.storage[8], matrix.storage[0]);
  }

  /// Anchor-local transform locked to floor clearance and yaw-only rotation.
  /// All gesture-driven node writes should pass through this function.
  static Matrix4 constrainedLocalTransform({
    required Matrix4 rawGestureTransform,
    required Vector3 scale,
    double? yawRadians,
  }) {
    final local = rawGestureTransform.getTranslation();
    final yaw = yawRadians ?? yawFromTransform(rawGestureTransform);    return Matrix4.compose(
      Vector3(local.x, floorClearanceM, local.z),
      Quaternion.axisAngle(Vector3(0, 1, 0), yaw),
      scale,
    );
  }

  /// Local Y offset after native GLB bottom snap — only clearance remains here.
  static Vector3 nodeLocalOffset({
    required ProductDimensions dimensions,
    required Vector3 nodeScale,
  }) {
    return Vector3(0, floorClearanceM, 0);
  }
}
