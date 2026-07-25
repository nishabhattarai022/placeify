import 'package:placeify_flutter/features/home/domain/models/product.dart';
import 'package:placeify_flutter/features/shops/data/vendor_product_mapper.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_profile.dart';

/// Resolves consumer-facing logo and banner URLs for shop cards.
abstract final class ShopListingImages {
  static const defaultBanner =
      'assets/images/splash/3d-room-decor-with-furniture-minimalist-beige-tones.jpg';

  static const defaultLogo = 'assets/images/splash/462222_1_800.jpg';

  static const _bannerCategories = {'tables', 'beds', 'sofas', 'decor'};

  static String resolveLogoUrl(
    VendorProfile profile,
    List<Product> products,
  ) {
    final fromProfile = profile.logoUrl?.trim();
    if (fromProfile != null && fromProfile.isNotEmpty) {
      return fromProfile;
    }

    final fromProduct = _firstProductImage(products);
    if (fromProduct != null) return fromProduct;

    return defaultLogo;
  }

  static String resolveBannerUrl(
    VendorProfile profile,
    List<Product> products,
  ) {
    final fromProfile = profile.bannerUrl?.trim();
    if (fromProfile != null && fromProfile.isNotEmpty) {
      return fromProfile;
    }

    final fromProduct = _bannerProductImage(products);
    if (fromProduct != null) return fromProduct;

    return defaultBanner;
  }

  static String? _firstProductImage(List<Product> products) {
    for (final product in products) {
      final url = product.imageUrl.trim();
      if (url.isNotEmpty) return url;
    }
    return null;
  }

  static String? _bannerProductImage(List<Product> products) {
    for (final product in products) {
      if (!_bannerCategories.contains(product.categoryId)) continue;
      final url = product.imageUrl.trim();
      if (url.isNotEmpty) return url;
    }
    return _firstProductImage(products);
  }

  /// Category-aware fallback when an image fails to load.
  static String fallbackForCategory(String? categoryId) {
    return VendorProductMapper.fallbackImageForCategory(categoryId ?? '');
  }
}
