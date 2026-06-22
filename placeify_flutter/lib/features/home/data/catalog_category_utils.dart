/// Maps Nisha browse UI category ids to Serverpod catalog category names.
abstract final class CatalogCategoryUtils {
  static String catalogName(String uiCategoryId) {
    return switch (uiCategoryId) {
      'lighting' => 'lights',
      'desks' => 'tables',
      'storage' => 'decor',
      'outdoor' => 'decor',
      _ => uiCategoryId,
    };
  }

  static bool matchesUiCategory(String productCategoryId, String uiCategoryId) {
    final normalizedProduct = productCategoryId.toLowerCase();
    final catalog = catalogName(uiCategoryId).toLowerCase();
    if (normalizedProduct == catalog) return true;
    if (normalizedProduct == uiCategoryId.toLowerCase()) return true;
    return false;
  }
}
