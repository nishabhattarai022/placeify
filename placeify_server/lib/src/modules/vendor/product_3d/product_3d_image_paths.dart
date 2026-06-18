/// Resolves original photo paths stored alongside catalog JPEG uploads.
abstract final class Product3dImagePaths {
  /// Candidate Tripo source paths for a catalog URL (vendor originals).
  ///
  /// `/uploads/123_chair.jpg` → `/uploads/123_chair_tripo.jpg`, `_tripo.png`, etc.
  static List<String> tripoSourceCandidatesForCatalog(String catalogUrlPath) {
    final trimmed = catalogUrlPath.trim();
    if (trimmed.isEmpty) return const [];

    final base = _catalogBasePath(trimmed);
    if (base == null) return const [];

    return [
      '${base}_tripo.jpg',
      '${base}_tripo.jpeg',
      '${base}_tripo.png',
      '${base}_tripo.webp',
    ];
  }

  /// Storage path for the high-fidelity original saved next to a catalog JPEG.
  static String tripoStoragePathForCatalog({
    required String catalogStoragePath,
    required String originalExtension,
  }) {
    final base = _catalogBasePath(catalogStoragePath);
    if (base == null) return '';
    return '${base}_tripo$originalExtension';
  }

  static String? _catalogBasePath(String catalogUrlPath) {
    final match =
        RegExp(r'^(.*)\.jpe?g$', caseSensitive: false).firstMatch(catalogUrlPath);
    return match?.group(1);
  }
}
