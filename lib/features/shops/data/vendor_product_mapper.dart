import 'package:placeify/features/home/data/mock_product_repository.dart';
import 'package:placeify/features/home/domain/models/product.dart';
import 'package:placeify/features/vendor/domain/models/vendor_product.dart';

/// Maps vendor inventory to consumer-facing [Product] rows with namespaced IDs.
abstract final class VendorProductMapper {
  static const _idPrefix = 'shop-';

  static String consumerProductId({
    required String vendorId,
    required String productId,
  }) =>
      '$_idPrefix$vendorId-$productId';

  static bool isShopProductId(String id) => id.startsWith(_idPrefix);

  static Product toConsumerProduct(VendorProduct vendorProduct) {
    final imageUrl = vendorProduct.imageUrls.isNotEmpty
        ? vendorProduct.imageUrls.first
        : _fallbackImageForCategory(vendorProduct.categoryId);

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

  static String _fallbackImageForCategory(String categoryId) {
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
