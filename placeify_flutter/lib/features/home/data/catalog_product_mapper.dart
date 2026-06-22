import 'package:placeify_client/placeify_client.dart' as api;

import '../../../core/config/resolve_media_url.dart';
import '../../cart/data/product_id_codec.dart';
import '../../product_detail/data/product_3d_model_resolver.dart';
import '../domain/models/product.dart';

abstract final class CatalogProductMapper {
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
    final brand = product.assemblyNote?.trim();
    final thumbnail = product.thumbnailUrl;
    final imageUrl = thumbnail == null || thumbnail.isEmpty
        ? 'assets/icons/ic_chair.svg'
        : await resolveMediaUrl(thumbnail);

    final dimensions = _dimensionsFromApi(product);
    final uiId = ProductIdCodec.fromDatabaseId(id);
    final model3dUrl = product.model3dUrl?.trim();
    final has3dPreview = model3dUrl != null && model3dUrl.isNotEmpty;
    if (has3dPreview) {
      final resolved = await resolveMediaUrl(model3dUrl);
      Product3dModelResolver.setModelUrl(uiId, resolved);
    }

    final resolvedImage =
        imageUrl.isEmpty ? 'assets/images/categories/chair.jpg' : imageUrl;

    return Product(
      id: uiId,
      name: product.name,
      brand: brand != null && brand.isNotEmpty ? brand : shopName,
      sku: 'PF${id.toString().padLeft(5, '0')}',
      price: product.price,
      imageUrl: resolvedImage,
      svgIconPath: _categoryIcons[categoryId] ?? 'assets/icons/ic_chair.svg',
      hasArView: has3dPreview,
      categoryId: categoryId,
      dimensions: dimensions,
      vendorId: product.vendorId.toString(),
    );
  }

  static ProductDimensions _dimensionsFromApi(api.Product product) {
    return ProductDimensions(
      widthCm: product.widthCm ?? 0,
      depthCm: product.depthCm ?? 0,
      heightCm: product.heightCm ?? 0,
    );
  }
}
