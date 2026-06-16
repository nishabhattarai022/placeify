/// Resolves original photo paths stored alongside catalog JPEG uploads.
abstract final class Product3dImagePaths {
  /// Candidate Tripo source paths for a catalog URL (original photo, no bg removal).
  ///
  /// `/uploads/123_chair.jpg` → `/uploads/123_chair_tripo.jpg`, `_tripo.png`, etc.
  static List<String> tripoSourceCandidatesForCatalog(String catalogUrlPath) {
    final trimmed = catalogUrlPath.trim();
    if (trimmed.isEmpty) return const [];

    final match = RegExp(r'^(.*)\.jpe?g$', caseSensitive: false).firstMatch(trimmed);
    if (match == null) return const [];

    final base = match.group(1)!;
    return [
      '${base}_tripo.jpg',
      '${base}_tripo.jpeg',
      '${base}_tripo.png',
      '${base}_tripo.webp',
    ];
  }
}
