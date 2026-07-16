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
  }) =>
      '$_idPrefix$vendorId-$productId';

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
        : fallbackImageForCategory(vendorProduct.categoryId);

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
      imageUrls: vendorProduct.imageUrls
          .where((url) => url.trim().isNotEmpty)
          .toList(growable: false),
      svgIconPath: _svgIconForCategory(vendorProduct.categoryId),
      hasArView: vendorProduct.hasArView,
      categoryId: vendorProduct.categoryId,
      dimensions: ProductDimensions(
        widthCm: vendorProduct.widthCm,
        depthCm: vendorProduct.depthCm,
        heightCm: vendorProduct.heightCm,
      ),
      vendorId: vendorProduct.vendorId,
      description: vendorProduct.description,
      materials:
          vendorProduct.materials.isNotEmpty ? vendorProduct.materials : null,
      weightKg: vendorProduct.weightKg > 0 ? vendorProduct.weightKg : null,
      assemblyNote:
          vendorProduct.offerLabel.isNotEmpty ? vendorProduct.offerLabel : null,
      careInstructions: null,
      warranty: vendorProduct.warrantyNote.isNotEmpty
          ? vendorProduct.warrantyNote
          : (vendorProduct.offerLabel.isNotEmpty
              ? vendorProduct.offerLabel
              : null),
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

  static String fallbackImageForCategory(String categoryId) {
    return switch (categoryId) {
      'chairs' =>
        'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
      'tables' =>
        'assets/images/splash/pexels-blackcurrant-great-2016663774-35378675.jpg',
      'sofas' => 'assets/images/splash/pexels-suhailat-35160826.jpg',
      'lights' => 'assets/images/home/explore_hero.jpg',
      'beds' =>
        'assets/images/splash/3d-room-decor-with-furniture-minimalist-beige-tones.jpg',
      'decor' => 'assets/images/splash/462222_1_800.jpg',
      _ => 'assets/images/splash/462222_1_800.jpg',
    };
  }
}
