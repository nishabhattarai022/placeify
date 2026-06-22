import 'package:placeify_client/placeify_client.dart' as api;

import '../../../core/config/resolve_media_url.dart';
import '../../cart/data/product_id_codec.dart';
import '../../product_detail/data/product_model_3d_urls.dart';
import '../domain/models/product.dart';

abstract final class CatalogProductMapper {
  static const _defaultDimensions = ProductDimensions(
    widthCm: 70,
    depthCm: 68,
    heightCm: 85,
  );

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

  static Future<Product> toUiProduct(api.Product product) async {
    final id = product.id;
    if (id == null) {
      throw StateError('Catalog product is missing a database id.');
    }

    final categoryId = product.category?.name ?? 'chairs';
    final shopName = product.vendor?.shopName ?? 'Placeify vendor';
    final thumbnail = product.thumbnailUrl;
    final imageUrl = thumbnail == null || thumbnail.isEmpty
        ? 'assets/icons/ic_chair.svg'
        : await resolveMediaUrl(thumbnail);

    final dimensions = _dimensionsFromApi(product);
    final uiId = ProductIdCodec.fromDatabaseId(id);
    final model3dUrl = product.model3dUrl?.trim();
    final has3dPreview = model3dUrl != null && model3dUrl.isNotEmpty;
    if (has3dPreview) {
      ProductModel3dUrls.set(uiId, await resolveMediaUrl(model3dUrl));
    }

    return Product(
      id: uiId,
      name: product.name,
      brand: shopName,
      sku: 'PF${id.toString().padLeft(5, '0')}',
      price: product.price,
      vendorId: product.vendor?.id?.toString() ?? product.vendorId.toString(),
      imageUrl: imageUrl.isEmpty
          ? 'assets/images/categories/chair.jpg'
          : imageUrl,
      svgIconPath: _categoryIcons[categoryId] ?? 'assets/icons/ic_chair.svg',
      hasArView: has3dPreview,
      categoryId: categoryId,
      dimensions: dimensions,
    );
  }

  static ProductDimensions _dimensionsFromApi(api.Product product) {
    if (product.widthCm != null &&
        product.depthCm != null &&
        product.heightCm != null) {
      return ProductDimensions(
        widthCm: product.widthCm!,
        depthCm: product.depthCm!,
        heightCm: product.heightCm!,
      );
    }
    return _defaultDimensions;
  }
}
