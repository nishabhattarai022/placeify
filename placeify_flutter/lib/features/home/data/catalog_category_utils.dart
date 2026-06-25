/// Maps Nisha browse UI category ids to Serverpod catalog category names.
abstract final class CatalogCategoryUtils {
  /// Nisha browse category ids (see [furniture_categories.dart]).
  static const nishaBrowseCategoryIds = [
    'chairs',
    'sofas',
    'desks',
    'beds',
    'tables',
    'storage',
    'lighting',
    'outdoor',
  ];

  /// Legacy alias when reading old DB rows seeded before Phase 4.
  static String legacyCatalogName(String uiCategoryId) {
    return switch (uiCategoryId) {
      'lighting' => 'lights',
      'desks' => 'tables',
      'storage' => 'decor',
      'outdoor' => 'decor',
      _ => uiCategoryId,
    };
  }

  /// True when a catalog product row belongs under a Nisha browse category chip.
  static bool matchesUiCategory(String productCategoryId, String uiCategoryId) {
    final product = productCategoryId.trim().toLowerCase();
    final ui = uiCategoryId.trim().toLowerCase();
    if (product.isEmpty || ui.isEmpty) return false;
    if (product == ui) return true;

    return switch (ui) {
      'lighting' => product == 'lights' || product == 'lighting',
      'desks' => product == 'desks' || product == 'tables',
      'storage' => product == 'storage' || product == 'decor',
      'outdoor' => product == 'outdoor' || product == 'decor',
      _ => false,
    };
  }
}
