import 'tripo_client.dart';

/// Maps 5–6 vendor views into Tripo's fixed [front, left, back, right] slots.
abstract final class TripoViewMapper {
  /// All captured views: front, left, back, right, frontLeft, frontRight.
  static List<TripoViewImage?> toTripoMultiviewSlots({
    required TripoViewImage? front,
    required TripoViewImage? left,
    required TripoViewImage? back,
    required TripoViewImage? right,
    required TripoViewImage? frontLeft,
    required TripoViewImage? frontRight,
  }) {
    return [
      front,
      left ?? frontLeft,
      back,
      right ?? frontRight,
    ];
  }

  static int countProvidedViews({
    required TripoViewImage? front,
    required TripoViewImage? left,
    required TripoViewImage? back,
    required TripoViewImage? right,
    required TripoViewImage? frontLeft,
    required TripoViewImage? frontRight,
  }) {
    return [
      front,
      left,
      back,
      right,
      frontLeft,
      frontRight,
    ].whereType<TripoViewImage>().length;
  }
}
