import 'package:flutter/material.dart';

/// Room filters for the home screen quick-browse row.
abstract final class HomeCategoriesConfig {
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
