import 'package:flutter/material.dart';

/// Room filters and recommended products for the home screen.
abstract final class HomeCategoriesConfig {
  /// Room filter labels for the home category chip row.
  static const List<RoomCategory> rooms = [
    RoomCategory(id: 'living', name: 'Living Room'),
    RoomCategory(id: 'dining', name: 'Dining Room'),
    RoomCategory(id: 'office', name: 'Office Room'),
  ];

  /// SVG quick-browse row (black pill + icon circles).
  static const List<RoomCategory> quickBrowseRooms = [
    RoomCategory(
      id: 'living',
      name: 'Living',
      iconAsset: 'assets/icons/ic_living.svg',
    ),
    RoomCategory(
      id: 'bedroom',
      name: 'Bedroom',
      iconAsset: 'assets/icons/ic_bedroom.svg',
    ),
    RoomCategory(
      id: 'bathroom',
      name: 'Bathroom',
      iconAsset: 'assets/icons/ic_bathroom.svg',
    ),
    RoomCategory(
      id: 'office',
      name: 'Office',
      iconAsset: 'assets/icons/ic_chair.svg',
    ),
    RoomCategory(
      id: 'study',
      name: 'Study room',
      iconAsset: 'assets/icons/ic_study_room.svg',
    ),
  ];

  static const List<RecommendProduct> recommended = [
    RecommendProduct(
      id: 'rec-crimson',
      displayName: 'Crimson Comfort',
      displayPrice: 'NPR 100',
      imageAsset:
          'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
      productId: 'p1',
      roomIds: ['living', 'dining', 'office'],
      swatches: [
        Color(0xFF8B5A3C),
        Color(0xFFB8D43A),
        Color(0xFFE8C547),
      ],
    ),
    RecommendProduct(
      id: 'rec-emerald',
      displayName: 'Emerald Ease',
      displayPrice: 'NPR 86',
      imageAsset: 'assets/images/splash/pexels-suhailat-35160826.jpg',
      productId: 'p5',
      roomIds: ['living', 'dining', 'office'],
      swatches: [
        Color(0xFFD4A017),
        Color(0xFF2C2C2C),
        Color(0xFFE07B5F),
      ],
    ),
  ];

  static List<RecommendProduct> forRoom(String roomId) {
    final filtered = recommended
        .where((p) => p.roomIds.contains(roomId))
        .toList();
    return filtered.isNotEmpty ? filtered : recommended;
  }
}

class RoomCategory {
  const RoomCategory({
    required this.id,
    required this.name,
    this.iconAsset,
    this.icon,
  });

  final String id;
  final String name;
  final String? iconAsset;
  final IconData? icon;
}

class RecommendProduct {
  const RecommendProduct({
    required this.id,
    required this.displayName,
    required this.displayPrice,
    required this.imageAsset,
    required this.productId,
    required this.roomIds,
    required this.swatches,
  });

  final String id;
  final String displayName;
  final String displayPrice;
  final String imageAsset;
  final String productId;
  final List<String> roomIds;
  final List<Color> swatches;
}

/// @deprecated Use [RecommendProduct]. Kept for any legacy imports.
typedef FeaturedProduct = RecommendProduct;
