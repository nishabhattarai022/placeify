import 'package:flutter/material.dart';
import 'package:placeify_flutter/features/home/data/mock_product_repository.dart';
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

  static const _fallbackAsset =
      'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg';

  static const _defaultSwatches = [
    Color(0xFF8B5A3C),
    Color(0xFFB8D43A),
    Color(0xFFE8C547),
  ];

  static Product _product(String id) =>
      MockProductRepository.products.firstWhere((p) => p.id == id);

  static final List<RecommendProduct> recommended = [
    fromProduct(
      _product('p4'),
      id: 'rec-living-sofa',
      roomIds: ['living'],
      swatches: [
        Color(0xFFD4A017),
        Color(0xFF2C2C2C),
        Color(0xFFE07B5F),
      ],
    ),
    fromProduct(
      _product('p15'),
      id: 'rec-living-lamp',
      roomIds: ['living'],
      swatches: [
        Color(0xFF8B5A3C),
        Color(0xFFB8D43A),
        Color(0xFFE8C547),
      ],
    ),
    fromProduct(
      _product('p1'),
      id: 'rec-living-accent',
      roomIds: ['living'],
      swatches: [
        Color(0xFF7A8C6E),
        Color(0xFFD4C4A8),
        Color(0xFF3D3D3D),
      ],
    ),
    fromProduct(
      _product('p3'),
      id: 'rec-living-side',
      roomIds: ['living'],
      swatches: [
        Color(0xFF6B4F3A),
        Color(0xFFC9A96E),
        Color(0xFF2C2C2C),
      ],
    ),
    fromProduct(
      _product('p11'),
      id: 'rec-dining-table',
      roomIds: ['dining'],
      swatches: [
        Color(0xFF6B4F3A),
        Color(0xFFC9A96E),
        Color(0xFF2C2C2C),
      ],
    ),
    fromProduct(
      _product('p12'),
      id: 'rec-dining-console',
      roomIds: ['dining'],
      swatches: [
        Color(0xFF8B7355),
        Color(0xFFD4C4A8),
        Color(0xFF3D3D3D),
      ],
    ),
    fromProduct(
      _product('p7'),
      id: 'rec-office-desk',
      roomIds: ['office'],
      swatches: [
        Color(0xFF5C4033),
        Color(0xFF8B6914),
        Color(0xFF1A1A1A),
      ],
    ),
    fromProduct(
      _product('p8'),
      id: 'rec-office-chair',
      roomIds: ['office'],
      swatches: [
        Color(0xFF4A5568),
        Color(0xFF718096),
        Color(0xFF2D3748),
      ],
    ),
  ];

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
        imageAsset: product.imageUrl.startsWith('http')
            ? _fallbackAsset
            : product.imageUrl,
        roomIds: roomIds,
        swatches: swatches ?? _defaultSwatches,
      );

  static List<RecommendProduct> forRoom(String roomId) => recommended
      .where((p) => p.roomIds.contains(roomId))
      .toList();
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
