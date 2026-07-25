import 'package:flutter/material.dart';

class FurnitureCategory {
  final String id;
  final String name;
  final String imagePath;
  final String svgIconAssetPath;
  final Color bgColor;

  const FurnitureCategory({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.svgIconAssetPath,
    required this.bgColor,
  });
}

const List<FurnitureCategory> furnitureCategories = [
  FurnitureCategory(
    id: 'chairs',
    name: 'Chairs',
    imagePath: 'assets/images/categories/chair.jpg',
    svgIconAssetPath: 'assets/icons/ic_chair.svg',
    bgColor: Color(0xFFC4B49E),
  ),
  FurnitureCategory(
    id: 'sofas',
    name: 'Sofas',
    imagePath: 'assets/images/categories/sofa.jpg',
    svgIconAssetPath: 'assets/icons/ic_sofa.svg',
    bgColor: Color(0xFFA8B5A2),
  ),
  FurnitureCategory(
    id: 'desks',
    name: 'Desks',
    imagePath: 'assets/images/categories/desk.jpg',
    svgIconAssetPath: 'assets/icons/ic_armchair.svg',
    bgColor: Color(0xFFB0AABF),
  ),
  FurnitureCategory(
    id: 'beds',
    name: 'Beds',
    imagePath: 'assets/images/categories/bed.jpg',
    svgIconAssetPath: 'assets/icons/ic_bed.svg',
    bgColor: Color(0xFFBFB09A),
  ),
  FurnitureCategory(
    id: 'tables',
    name: 'Tables',
    imagePath: 'assets/images/categories/table.jpg',
    svgIconAssetPath: 'assets/icons/ic_table.svg',
    bgColor: Color(0xFF98A8A4),
  ),
  FurnitureCategory(
    id: 'storage',
    name: 'Storage',
    imagePath: 'assets/images/categories/storage.jpg',
    svgIconAssetPath: 'assets/icons/ic_box.svg',
    bgColor: Color(0xFFC2B8A8),
  ),
  FurnitureCategory(
    id: 'lighting',
    name: 'Lighting',
    imagePath: 'assets/images/categories/lighting.jpg',
    svgIconAssetPath: 'assets/icons/ic_lamp.svg',
    bgColor: Color(0xFFB8B0C4),
  ),
  FurnitureCategory(
    id: 'outdoor',
    name: 'Outdoor',
    imagePath: 'assets/images/categories/outdoor.jpg',
    svgIconAssetPath: 'assets/icons/ic_plant.svg',
    bgColor: Color(0xFFA8B8A0),
  ),
];

FurnitureCategory? furnitureCategoryById(String id) {
  for (final cat in furnitureCategories) {
    if (cat.id == id) return cat;
  }
  return null;
}

/// Singular label for breadcrumbs and category titles (Chair, Sofa, …).
String categoryDisplayName(FurnitureCategory category) {
  return switch (category.id) {
    'chairs' => 'Chair',
    'sofas' => 'Sofa',
    'desks' => 'Desk',
    'beds' => 'Bed',
    'tables' => 'Table',
    'storage' => 'Storage',
    'lighting' => 'Lighting',
    'outdoor' => 'Outdoor',
    _ => category.name,
  };
}
