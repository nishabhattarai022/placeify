/// Resolves Tripo source paths stored alongside catalog JPEG uploads.
abstract final class Product3dImagePaths {
  /// Candidate raw originals for a catalog URL (thumbnail white-bg JPEG).
  ///
  /// `/uploads/123_chair.jpg` → `/uploads/123_chair_tripo.jpg`, etc.
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
