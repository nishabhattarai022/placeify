import 'package:placeify_client/placeify_client.dart';
import 'package:flutter/material.dart';

import '../../cart/data/product_id_codec.dart';
import '../../../core/config/resolve_media_url.dart';
import 'discounted_products.dart';

abstract final class SpecialOfferMapper {
  static Future<DiscountedProduct> toUi(SpecialOfferSummary offer) async {
    final productId = ProductIdCodec.fromDatabaseId(offer.productId);
    final remoteImage = offer.imageUrl?.trim();
    final imagePath = remoteImage == null || remoteImage.isEmpty
        ? _fallbackAssetFor(productId)
        : await resolveMediaUrl(remoteImage);

    return DiscountedProduct(
      id: productId,
      name: offer.productName,
      imagePath: imagePath,
      originalPrice: offer.originalPrice,
      discountedPrice: offer.discountedPrice,
      discountPercent: offer.discountPercent,
      tagline: offer.tagline,
      cardColor: _parseColor(offer.cardColorHex),
    );
  }

  static Color _parseColor(String hex) {
    final normalized = hex.trim().replaceFirst('#', '');
    if (normalized.length == 6) {
      final value = int.tryParse(normalized, radix: 16);
      if (value != null) return Color(0xFF000000 | value);
    }
    return const Color(0xFFA8B5A0);
  }

  static String _fallbackAssetFor(String productId) {
    final dbId = ProductIdCodec.toDatabaseId(productId) ?? 1;
    return switch (dbId % 4) {
      0 => 'assets/images/splash/462222_1_800.jpg',
      1 =>
        'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
      2 => 'assets/images/splash/Diane_Sofa_Venice_Vegan_Suede_Sage_1.jpg',
      _ =>
        'assets/images/splash/pexels-blackcurrant-great-2016663774-35378675.jpg',
    };
  }
}
