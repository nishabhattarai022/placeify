import 'tripo_client.dart';

/// Maps 5–6 vendor views into Tripo's fixed [front, left, back, right] slots.
abstract final class TripoViewMapper {
  static const slotLabels = ['front', 'left', 'back', 'right'];

  /// All captured views: front, left, back, right, frontLeft, frontRight.
  ///
  /// Side slots prefer the higher-resolution image when both cardinal and 45°
  /// views exist, so Tripo receives maximum texture detail per slot.
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
      _pickHighestDetail(left, frontLeft),
      back,
      _pickHighestDetail(right, frontRight),
    ];
  }

  /// Which vendor view fed each Tripo slot (for logging).
  static List<String> slotSourceLabels({
    required TripoViewImage? front,
    required TripoViewImage? left,
    required TripoViewImage? back,
    required TripoViewImage? right,
    required TripoViewImage? frontLeft,
    required TripoViewImage? frontRight,
  }) {
    return [
      front != null ? 'front' : 'missing',
      _labelForPick(left, frontLeft, 'left', 'frontLeft'),
      back != null ? 'back' : 'missing',
      _labelForPick(right, frontRight, 'right', 'frontRight'),
    ];
  }

  static String _labelForPick(
    TripoViewImage? primary,
    TripoViewImage? alternate,
    String primaryLabel,
    String alternateLabel,
  ) {
    final picked = _pickHighestDetail(primary, alternate);
    if (picked == null) return 'missing';
    if (primary != null && picked == primary) return primaryLabel;
    if (alternate != null && picked == alternate) return alternateLabel;
    return primaryLabel;
  }

  static TripoViewImage? _pickHighestDetail(
    TripoViewImage? primary,
    TripoViewImage? alternate,
  ) {
    if (primary == null) return alternate;
    if (alternate == null) return primary;
    return primary.bytes.length >= alternate.bytes.length ? primary : alternate;
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
