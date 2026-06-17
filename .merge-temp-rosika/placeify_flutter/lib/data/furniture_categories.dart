import 'package:flutter/material.dart';

class FurnitureCategory {
  final String id;
  final String name;
  final String imagePath;
  final int itemCount;
  final Color bgColor;

  const FurnitureCategory({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.itemCount,
    required this.bgColor,
  });
}

const List<FurnitureCategory> furnitureCategories = [
  FurnitureCategory(
    id: 'chairs',
    name: 'Chairs',
    imagePath: 'assets/images/categories/chair.jpg',
    itemCount: 24,
    bgColor: Color(0xFFC4B49E),
  ),
  FurnitureCategory(
    id: 'sofas',
    name: 'Sofas',
    imagePath: 'assets/images/categories/sofa.jpg',
    itemCount: 12,
    bgColor: Color(0xFFA8B5A2),
  ),
  FurnitureCategory(
    id: 'desks',
    name: 'Desks',
    imagePath: 'assets/images/categories/desk.jpg',
    itemCount: 9,
    bgColor: Color(0xFFB0AABF),
  ),
  FurnitureCategory(
    id: 'beds',
    name: 'Beds',
    imagePath: 'assets/images/categories/bed.jpg',
    itemCount: 17,
    bgColor: Color(0xFFBFB09A),
  ),
  FurnitureCategory(
    id: 'tables',
    name: 'Tables',
    imagePath: 'assets/images/categories/table.jpg',
    itemCount: 19,
    bgColor: Color(0xFF98A8A4),
  ),
  FurnitureCategory(
    id: 'storage',
    name: 'Storage',
    imagePath: 'assets/images/categories/storage.jpg',
    itemCount: 14,
    bgColor: Color(0xFFC2B8A8),
  ),
  FurnitureCategory(
    id: 'lighting',
    name: 'Lighting',
    imagePath: 'assets/images/categories/lighting.jpg',
    itemCount: 8,
    bgColor: Color(0xFFB8B0C4),
  ),
  FurnitureCategory(
    id: 'outdoor',
    name: 'Outdoor',
    imagePath: 'assets/images/categories/outdoor.jpg',
    itemCount: 11,
    bgColor: Color(0xFFA8B8A0),
  ),
];

FurnitureCategory? furnitureCategoryById(String id) {
  for (final cat in furnitureCategories) {
    if (cat.id == id) return cat;
  }
  return null;
}

/// Sum of display item counts across all browse categories (e.g. 114).
int get furnitureCatalogItemCount =>
    furnitureCategories.fold<int>(0, (sum, c) => sum + c.itemCount);

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
