import 'package:flutter/material.dart';
import 'package:placeify_client/placeify_client.dart' as api;

import 'catalog_product_mapper.dart';
import '../presentation/data/home_categories_config.dart';
import 'discounted_products.dart';
import '../domain/models/product.dart';

abstract final class MarketplaceHighlightsMapper {
  static const _cardColors = [
    Color(0xFFB5A99A),
    Color(0xFFA8B5A0),
    Color(0xFFB0AABF),
    Color(0xFFBFAE98),
  ];

  static const _defaultSwatches = [
    Color(0xFF8B5A3C),
    Color(0xFFB8D43A),
    Color(0xFFE8C547),
  ];

  static Future<List<DiscountedProduct>> toDiscountedProducts(
    List<api.Product> offers,
  ) async {
    final mapped = <DiscountedProduct>[];
    for (var i = 0; i < offers.length; i++) {
      final offer = offers[i];
      final ui = await CatalogProductMapper.toUiProduct(offer);
      if (!ui.isOnSale) continue;
      mapped.add(_toDiscountedProduct(ui, i));
    }
    mapped.sort(
      (a, b) => b.discountPercent.compareTo(a.discountPercent),
    );
    return mapped;
  }

  static DiscountedProduct _toDiscountedProduct(Product product, int index) {
    final original = product.originalPrice ?? product.price;
    return DiscountedProduct(
      id: product.id,
      name: product.name,
      imagePath: product.imageUrl,
      originalPrice: original,
      discountedPrice: product.price,
      discountPercent: product.discountPercent.round(),
      tagline: product.brand,
      cardColor: _cardColors[index % _cardColors.length],
    );
  }

  /// Maps live catalog products into carousel cards for Special Offers.
  static List<DiscountedProduct> fromUiProducts(List<Product> products) {
    final onSale = products.where((p) => p.isOnSale).toList()
      ..sort((a, b) => b.discountPercent.compareTo(a.discountPercent));
    return [
      for (var i = 0; i < onSale.length; i++)
        _toDiscountedProduct(onSale[i], i),
    ];
  }

  static Future<List<RecommendProduct>> toRecommendProducts(
    List<api.Product> products, {
    String? roomId,
  }) async {
    final mapped = <RecommendProduct>[];
    for (final item in products) {
      final ui = await CatalogProductMapper.toUiProduct(item);
      if (roomId != null && !matchesRoom(ui.categoryId, roomId)) {
        continue;
      }
      mapped.add(_recommendFromUi(ui, roomId: roomId));
      if (mapped.length >= 4) break;
    }
    return mapped;
  }

  /// Maps live catalog [Product] rows into home recommendation cards.
  static List<RecommendProduct> recommendFromUiProducts(
    List<Product> products, {
    String? roomId,
  }) {
    return [
      for (final ui in products.take(4))
        _recommendFromUi(ui, roomId: roomId),
    ];
  }

  static RecommendProduct _recommendFromUi(
    Product ui, {
    String? roomId,
  }) {
    return RecommendProduct(
      id: 'rec-${ui.id}',
      productId: ui.id,
      displayName: ui.name,
      displayPrice: 'NPR ${ui.price.toInt()}',
      imageAsset: ui.imageUrl,
      roomIds: [roomId ?? 'living'],
      swatches: _defaultSwatches,
    );
  }

  static bool matchesRoom(String categoryId, String roomId) {
    const roomCategories = <String, List<String>>{
      'living': ['sofas', 'chairs', 'tables'],
      'dining': ['tables', 'chairs'],
      'office': ['desks', 'chairs'],
      'bedroom': ['beds', 'storage'],
      'bathroom': ['storage', 'lighting', 'lights'],
      'study': ['desks', 'chairs', 'storage'],
    };
    final categories = roomCategories[roomId];
    if (categories == null) return true;
    return categories.contains(categoryId);
  }
}
