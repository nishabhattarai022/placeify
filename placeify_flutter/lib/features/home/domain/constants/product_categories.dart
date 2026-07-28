import 'package:placeify_flutter/features/home/domain/models/category.dart';

/// Canonical furniture category list shared by vendor and consumer UIs.
abstract final class ProductCategories {
  static const List<ProductCategory> all = [
    ProductCategory(
      id: 'chairs',
      label: 'Chairs',
      svgIconAssetPath: 'assets/icons/ic_chair.svg',
      isActive: true,
    ),
    ProductCategory(
      id: 'sofas',
      label: 'Sofas',
      svgIconAssetPath: 'assets/icons/ic_sofa.svg',
    ),
    ProductCategory(
      id: 'tables',
      label: 'Tables',
      svgIconAssetPath: 'assets/icons/ic_table.svg',
    ),
    ProductCategory(
      id: 'lights',
      label: 'Lights',
      svgIconAssetPath: 'assets/icons/ic_lamp.svg',
    ),
    ProductCategory(
      id: 'beds',
      label: 'Beds',
      svgIconAssetPath: 'assets/icons/ic_bed.svg',
    ),
    ProductCategory(
      id: 'decor',
      label: 'Decor',
      svgIconAssetPath: 'assets/icons/ic_plant.svg',
    ),
  ];

  static ProductCategory? byId(String id) {
    for (final category in all) {
      if (category.id == id) return category;
    }
    return null;
  }
}
