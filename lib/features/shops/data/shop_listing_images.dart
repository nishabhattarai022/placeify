import 'package:placeify/features/admin/data/config/admin_seed_data.dart';
import 'package:placeify/features/home/domain/models/product.dart';
import 'package:placeify/features/shops/data/vendor_product_mapper.dart';
import 'package:placeify/features/vendor/data/config/vendor_mock_config.dart';
import 'package:placeify/features/vendor/domain/models/vendor_profile.dart';

/// Resolves consumer-facing logo and banner URLs for shop cards.
abstract final class ShopListingImages {
  static const defaultBanner =
      'assets/images/splash/3d-room-decor-with-furniture-minimalist-beige-tones.jpg';

  static const defaultLogo = 'assets/images/splash/462222_1_800.jpg';

  static const _bannerCategories = {'tables', 'beds', 'sofas', 'decor'};

  static const _vendorBanners = {
    VendorMockConfig.demoVendorId:
        'assets/images/splash/3d-room-decor-with-furniture-minimalist-beige-tones.jpg',
    AdminSeedData.approvedVendorId:
        'assets/images/splash/pexels-blackcurrant-great-2016663774-35378675.jpg',
    AdminSeedData.shopVendorNestId:
        'assets/images/splash/Diane_Sofa_Venice_Vegan_Suede_Sage_1.jpg',
    AdminSeedData.shopVendorHimalayaId:
        'assets/images/splash/462222_1_800.jpg',
    AdminSeedData.shopVendorCraftsId:
        'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
    AdminSeedData.shopVendorUrbanId:
        'assets/images/splash/pexels-suhailat-35160826.jpg',
  };

  static const _vendorLogos = {
    VendorMockConfig.demoVendorId:
        'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
    AdminSeedData.approvedVendorId:
        'assets/images/splash/pexels-suhailat-35160826.jpg',
    AdminSeedData.shopVendorNestId:
        'assets/images/splash/3d-room-decor-with-furniture-minimalist-beige-tones.jpg',
    AdminSeedData.shopVendorHimalayaId:
        'assets/images/splash/pexels-blackcurrant-great-2016663774-35378675.jpg',
    AdminSeedData.shopVendorCraftsId:
        'assets/images/splash/462222_1_800.jpg',
    AdminSeedData.shopVendorUrbanId:
        'assets/images/splash/Diane_Sofa_Venice_Vegan_Suede_Sage_1.jpg',
  };

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

    return _vendorLogos[profile.id] ?? defaultLogo;
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

    return _vendorBanners[profile.id] ?? defaultBanner;
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
