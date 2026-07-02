import 'package:flutter/material.dart';

import 'package:placeify_flutter/features/home/domain/models/product.dart';

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

  static const _defaultSwatches = [
    Color(0xFF8B5A3C),
    Color(0xFFB8D43A),
    Color(0xFFE8C547),
  ];

  /// API category label sent to the backend for a room chip id.
  static String apiCategoryForRoom(String roomId) {
    return rooms
        .firstWhere(
          (room) => room.id == roomId,
          orElse: () => rooms.first,
        )
        .name;
  }

  static RoomCategory roomById(String roomId) {
    return rooms.firstWhere(
      (room) => room.id == roomId,
      orElse: () => rooms.first,
    );
  }

  static RecommendProduct fromProduct(
    Product product, {
    required String id,
    required List<String> roomIds,
    List<Color>? swatches,
  }) =>
      RecommendProduct(
        id: id,
        productId: product.id,
        displayName: product.name,
        displayPrice: 'NPR ${product.price.toInt()}',
        imageAsset: product.imageUrl,
        roomIds: roomIds,
        swatches: swatches ?? _defaultSwatches,
      );
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
