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

  static Future<List<RecommendProduct>> toRecommendProducts(
    List<api.Product> products, {
    String? roomId,
  }) async {
    final mapped = <RecommendProduct>[];
    for (final item in products) {
      final ui = await CatalogProductMapper.toUiProduct(item);
      if (roomId != null && !_matchesRoom(ui.categoryId, roomId)) {
        continue;
      }
      mapped.add(
        RecommendProduct(
          id: 'rec-${ui.id}',
          productId: ui.id,
          displayName: ui.name,
          displayPrice: 'NPR ${ui.price.toInt()}',
          imageAsset: ui.imageUrl,
          roomIds: [roomId ?? 'living'],
          swatches: _defaultSwatches,
        ),
      );
      if (mapped.length >= 2) break;
    }
    return mapped;
  }

  static bool _matchesRoom(String categoryId, String roomId) {
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
