import 'package:placeify_flutter/data/furniture_categories.dart';
import 'package:placeify_flutter/features/home/presentation/data/home_categories_config.dart';

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

  /// Room → furniture category ids for home recommendations and room listings.
  static const roomCategoryIds = <String, List<String>>{
    'living': ['sofas', 'chairs', 'tables'],
    'dining': ['tables', 'chairs'],
    'office': ['desks', 'chairs'],
    'bedroom': ['beds', 'storage'],
    'bathroom': ['storage', 'lighting'],
    'study': ['desks', 'chairs', 'storage'],
  };

  /// Legacy alias when reading old DB rows seeded before Phase 4.
  static String legacyCatalogName(String uiCategoryId) {
    return switch (uiCategoryId) {
      'lighting' => 'lights',
      _ => uiCategoryId,
    };
  }

  /// True when a catalog product row belongs under a Nisha browse category chip.
  ///
  /// Matching is strict: Sofa shows only `sofas`, Chair only `chairs`, etc.
  /// The only alias pair is `lighting` ↔ `lights`.
  static bool matchesUiCategory(String productCategoryId, String uiCategoryId) {
    final product = productCategoryId.trim().toLowerCase();
    final ui = uiCategoryId.trim().toLowerCase();
    if (product.isEmpty || ui.isEmpty) return false;
    if (product == ui) return true;

    return switch (ui) {
      'lighting' => product == 'lights' || product == 'lighting',
      'lights' => product == 'lights' || product == 'lighting',
      _ => false,
    };
  }

  static String? roomIdForLabel(String label) {
    final normalized = label.trim().toLowerCase();
    if (normalized.isEmpty) return null;

    for (final room in HomeCategoriesConfig.quickBrowseRooms) {
      if (room.id == normalized || room.name.toLowerCase() == normalized) {
        return room.id;
      }
    }
    return null;
  }

  static List<String> furnitureCategoryIdsForRoom(String roomId) {
    return roomCategoryIds[roomId] ?? const [];
  }

  static FurnitureCategory? furnitureCategoryForQuery(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return null;

    final byId = furnitureCategoryById(normalized);
    if (byId != null) return byId;

    for (final category in furnitureCategories) {
      if (category.name.toLowerCase() == normalized) return category;
      if (categoryDisplayName(category).toLowerCase() == normalized) {
        return category;
      }
    }
    return null;
  }
}
