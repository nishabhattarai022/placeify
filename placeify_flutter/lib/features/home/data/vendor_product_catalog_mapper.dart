import '../../vendor/domain/models/vendor_product.dart';
import '../domain/models/product.dart';
import 'catalog_image_resolver.dart';

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

    final imageUrl = await CatalogImageResolver.resolveFromUrlList(
      vendor.imageUrls,
      categoryId: vendor.categoryId,
      productName: vendor.name,
      productId: vendor.id,
    );

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
}
