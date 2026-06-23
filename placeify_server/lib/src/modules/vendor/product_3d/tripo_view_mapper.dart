import 'tripo_client.dart';

/// Maps vendor views into Tripo's fixed [front, left, back, right] slots.
abstract final class TripoViewMapper {
  static const slotLabels = ['front', 'left', 'back', 'right'];

  static List<TripoViewImage?> toTripoMultiviewSlots({
    required TripoViewImage? front,
    required TripoViewImage? left,
    required TripoViewImage? back,
    required TripoViewImage? right,
  }) {
    return [front, left, back, right];
  }

  static List<String> slotSourceLabels({
    required TripoViewImage? front,
    required TripoViewImage? left,
    required TripoViewImage? back,
    required TripoViewImage? right,
  }) {
    return [
      front != null ? 'front' : 'missing',
      left != null ? 'left' : 'missing',
      back != null ? 'back' : 'missing',
      right != null ? 'right' : 'missing',
    ];
  }

  static int countProvidedViews({
    required TripoViewImage? front,
    required TripoViewImage? left,
    required TripoViewImage? back,
    required TripoViewImage? right,
  }) {
    return [front, left, back, right].whereType<TripoViewImage>().length;
  }
}
