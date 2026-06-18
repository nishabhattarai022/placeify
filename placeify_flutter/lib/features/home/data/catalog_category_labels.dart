import '../../../data/furniture_categories.dart';
import '../presentation/data/category_showcase_config.dart';

/// Display labels and icons for API category ids (`chairs`, `sofas`, …).
abstract final class CatalogCategoryLabels {
  static String label(String categoryId) {
    final fromBrowse = furnitureCategoryById(categoryId)?.name;
    if (fromBrowse != null) return fromBrowse;

    final titled = CategoryShowcaseConfig.title(categoryId);
    if (titled != categoryId.toUpperCase()) {
      return _titleCase(titled);
    }
    return _titleCase(categoryId);
  }

  static String iconAsset(String categoryId) {
    return switch (categoryId) {
      'chairs' => 'assets/icons/ic_chair.svg',
      'sofas' => 'assets/icons/ic_sofa.svg',
      'tables' || 'desks' => 'assets/icons/ic_table.svg',
      'beds' => 'assets/icons/ic_bed.svg',
      'storage' => 'assets/icons/ic_package.svg',
      'lighting' || 'lights' => 'assets/icons/ic_lamp.svg',
      'outdoor' || 'decor' => 'assets/icons/ic_plant.svg',
      _ => 'assets/icons/ic_chair.svg',
    };
  }

  static String _titleCase(String value) {
    if (value.isEmpty) return value;
    final lower = value.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }
}
