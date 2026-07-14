import 'package:placeify_flutter/features/admin/data/config/admin_seed_data.dart';
import 'package:placeify_flutter/features/home/data/mock_product_repository.dart';
import 'package:placeify_flutter/features/home/domain/models/product.dart';
import 'package:placeify_flutter/features/shops/data/consumer_shop_seed.dart';
import 'package:placeify_flutter/features/vendor/data/config/vendor_mock_config.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_product.dart';

/// Maps vendor inventory to consumer-facing [Product] rows with namespaced IDs.
abstract final class VendorProductMapper {
  static const _idPrefix = 'shop-';

  static String consumerProductId({
    required String vendorId,
    required String productId,
  }) => '$_idPrefix$vendorId-$productId';

  static bool isShopProductId(String id) => id.startsWith(_idPrefix);

  /// Parses `shop-{vendorId}-{productId}` (vendor UUID may contain dashes).
  static ({String vendorId, String productId})? parseConsumerProductId(
    String id,
  ) {
    if (!isShopProductId(id)) return null;

    final rest = id.substring(_idPrefix.length);
    final productMarker = rest.lastIndexOf('-p');
    if (productMarker <= 0) return null;

    final vendorId = rest.substring(0, productMarker);
    final productId = rest.substring(productMarker + 1);
    if (vendorId.isEmpty || productId.isEmpty) return null;

    return (vendorId: vendorId, productId: productId);
  }

  static Iterable<String> get searchableVendorIds sync* {
    yield VendorMockConfig.demoVendorId;
    yield AdminSeedData.approvedVendorId;
    yield* AdminSeedData.catalogShopVendorIds;
    yield* ConsumerShopSeed.catalogVendorIds;
  }

  static VendorProduct? resolveVendorProduct(String consumerProductId) {
    if (!isShopProductId(consumerProductId)) return null;

    for (final vendorId in searchableVendorIds) {
      final prefix = '$_idPrefix$vendorId-';
      if (!consumerProductId.startsWith(prefix)) continue;
      final productId = consumerProductId.substring(prefix.length);
      final product = _vendorProductById(vendorId, productId);
      if (product != null) return product;
    }
    return null;
  }

  static VendorProduct? _vendorProductById(String vendorId, String productId) {
    if (VendorMockConfig.isKnownVendor(vendorId) ||
        VendorMockConfig.usesDemoPortalData(vendorId)) {
      final product = VendorMockConfig.productById(productId);
      if (product != null) return product;
    }
    if (ConsumerShopSeed.hasSeedProducts(vendorId)) {
      for (final product in ConsumerShopSeed.productsFor(vendorId)) {
        if (product.id == productId) return product;
      }
    }
    return null;
  }

  static Product toConsumerProduct(VendorProduct vendorProduct) {
    final imageUrl = vendorProduct.imageUrls.isNotEmpty
        ? vendorProduct.imageUrls.first
        : fallbackImageForCategory(
            vendorProduct.categoryId,
            productId: vendorProduct.id,
          );

    return Product(
      id: consumerProductId(
        vendorId: vendorProduct.vendorId,
        productId: vendorProduct.id,
      ),
      name: vendorProduct.name,
      brand: vendorProduct.brand.isNotEmpty
          ? vendorProduct.brand
          : 'Placeify Vendor',
      sku: vendorProduct.sku,
      price: vendorProduct.price,
      originalPrice: vendorProduct.originalPrice,
      imageUrl: imageUrl,
      svgIconPath: _svgIconForCategory(vendorProduct.categoryId),
      hasArView: vendorProduct.hasArView,
      categoryId: vendorProduct.categoryId,
      dimensions: ProductDimensions(
        widthCm: vendorProduct.widthCm,
        depthCm: vendorProduct.depthCm,
        heightCm: vendorProduct.heightCm,
      ),
      vendorId: vendorProduct.vendorId,
    );
  }

  static String _svgIconForCategory(String categoryId) {
    for (final category in MockProductRepository.categories) {
      if (category.id == categoryId) {
        return category.svgIconAssetPath;
      }
    }
    return 'assets/icons/ic_chair.svg';
  }

  /// Category-biased fallback that still varies by [productId].
  ///
  /// When [productId] is omitted (legacy callers), returns the first image in
  /// the category pool for compatibility.
  static String fallbackImageForCategory(
    String categoryId, {
    String productId = '',
  }) {
    final pool = _fallbackPoolForCategory(categoryId);
    if (productId.trim().isEmpty) return pool.first;
    final hash = '${categoryId.trim().toLowerCase()}|$productId'.hashCode &
        0x7fffffff;
    return pool[hash % pool.length];
  }

  static List<String> _fallbackPoolForCategory(String categoryId) {
    return switch (categoryId.trim().toLowerCase()) {
      'chairs' => const [
          'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
          'assets/images/categories/chair.jpg',
          'assets/images/home/offer_chair_1.png',
          'assets/images/home/offer_chair_2.png',
        ],
      'tables' || 'desks' => const [
          'assets/images/splash/pexels-blackcurrant-great-2016663774-35378675.jpg',
          'assets/images/categories/table.jpg',
          'assets/images/categories/desk.jpg',
          'assets/images/home/explore_hero.jpg',
        ],
      'sofas' => const [
          'assets/images/splash/pexels-suhailat-35160826.jpg',
          'assets/images/categories/sofa.jpg',
          'assets/images/splash/Diane_Sofa_Venice_Vegan_Suede_Sage_1.jpg',
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400',
        ],
      'lights' || 'lighting' => const [
          'assets/images/categories/lighting.jpg',
          'assets/images/home/explore_hero.jpg',
          'assets/images/splash/Diane_Sofa_Venice_Vegan_Suede_Sage_1.jpg',
          'assets/images/home/offer_chair_3.png',
        ],
      'beds' => const [
          'assets/images/splash/3d-room-decor-with-furniture-minimalist-beige-tones.jpg',
          'assets/images/categories/bed.jpg',
          'assets/images/splash/462222_1_800.jpg',
          'assets/images/home/offer_chair_4.png',
        ],
      'decor' || 'storage' || 'outdoor' => const [
          'assets/images/splash/462222_1_800.jpg',
          'assets/images/categories/storage.jpg',
          'assets/images/categories/outdoor.jpg',
          'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
        ],
      _ => const [
          'assets/images/splash/462222_1_800.jpg',
          'assets/images/home/explore_hero.jpg',
          'assets/images/categories/chair.jpg',
          'assets/images/splash_hero.jpg',
        ],
    };
  }
}
