import '../../../core/config/resolve_media_url.dart';
import '../../../core/utils/local_image_store.dart';
import '../../vendor/domain/models/vendor_product.dart';
import '../domain/models/product.dart';

/// Maps vendor catalog rows into customer-facing [Product] UI models.
abstract final class VendorProductCatalogMapper {
  static const _categoryIcons = <String, String>{
    'chairs': 'assets/icons/ic_chair.svg',
    'sofas': 'assets/icons/ic_sofa.svg',
    'tables': 'assets/icons/ic_table.svg',
    'desks': 'assets/icons/ic_table.svg',
    'beds': 'assets/icons/ic_bed.svg',
    'storage': 'assets/icons/ic_package.svg',
    'lighting': 'assets/icons/ic_lamp.svg',
    'lights': 'assets/icons/ic_lamp.svg',
    'outdoor': 'assets/icons/ic_plant.svg',
    'decor': 'assets/icons/ic_plant.svg',
  };

  static Future<Product> toUiProduct(VendorProduct vendor) async {
    final dimensions = ProductDimensions(
      widthCm: vendor.widthCm > 0 ? vendor.widthCm : 0,
      depthCm: vendor.depthCm > 0 ? vendor.depthCm : 0,
      heightCm: vendor.heightCm > 0 ? vendor.heightCm : 0,
    );

    final gallery = <String>[];
    for (final source in vendor.imageUrls) {
      final resolved = await _resolveImageUrl([source]);
      if (!_isPlaceholderAsset(resolved)) {
        gallery.add(resolved);
      }
    }
    final imageUrl = gallery.isNotEmpty
        ? gallery.first
        : await _resolveImageUrl(vendor.imageUrls);

    return Product(
      id: vendor.id,
      name: vendor.name,
      brand: vendor.brand.isNotEmpty ? vendor.brand : 'Placeify vendor',
      sku: vendor.sku,
      price: vendor.price,
      originalPrice: vendor.originalPrice,
      imageUrl: imageUrl,
      svgIconPath:
          _categoryIcons[vendor.categoryId] ?? 'assets/icons/ic_chair.svg',
      hasArView: vendor.hasArView,
      categoryId: vendor.categoryId,
      dimensions: dimensions,
      vendorId: vendor.vendorId,
    );
  }

  static bool _isPlaceholderAsset(String url) {
    return url.startsWith('assets/icons/') ||
        url == 'assets/images/categories/chair.jpg';
  }

  static Future<String> _resolveImageUrl(List<String> imageUrls) async {
    if (imageUrls.isEmpty) {
      return 'assets/images/categories/chair.jpg';
    }

    final source = imageUrls.first.trim();
    if (source.isEmpty) return 'assets/images/categories/chair.jpg';
    if (source.startsWith('assets/')) return source;
    if (source.startsWith(LocalImageStore.scheme)) {
      return 'assets/images/categories/chair.jpg';
    }
    if (source.startsWith('http://') || source.startsWith('https://')) {
      return source;
    }

    final resolved = await resolveMediaUrl(source);
    return resolved.isEmpty ? 'assets/images/categories/chair.jpg' : resolved;
  }
}
