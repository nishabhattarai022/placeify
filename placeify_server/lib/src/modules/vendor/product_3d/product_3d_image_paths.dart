/// Resolves high-fidelity PNG paths stored alongside catalog JPEG uploads.
abstract final class Product3dImagePaths {
  /// `/uploads/123_chair.jpg` → `/uploads/123_chair_tripo.png`
  static String? tripoSourcePathForCatalog(String catalogUrlPath) {
    final trimmed = catalogUrlPath.trim();
    if (trimmed.isEmpty) return null;

    final match = RegExp(r'^(.*)\.jpe?g$', caseSensitive: false).firstMatch(trimmed);
    if (match == null) return null;
    return '${match.group(1)}_tripo.png';
  }
}
