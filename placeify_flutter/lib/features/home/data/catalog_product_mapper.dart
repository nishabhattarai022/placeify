import 'package:placeify_client/placeify_client.dart' as api;

import '../../../core/config/resolve_media_url.dart';
import '../../cart/data/product_id_codec.dart';
import '../../product_detail/data/product_3d_model_resolver.dart';
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
    final imageUrl = await _resolvePrimaryImage(product);

    final dimensions = _dimensionsFromApi(product);
    final uiId = ProductIdCodec.fromDatabaseId(id);
    final effectivePrice = effectiveUnitPrice(product);
    final originalPrice = hasActiveOffer(product) ? product.price : null;
    final model3dUrl = product.model3dUrl?.trim();
    final has3dPreview = model3dUrl != null && model3dUrl.isNotEmpty;
    if (has3dPreview) {
      final resolved = await resolveMediaUrl(model3dUrl);
      Product3dModelResolver.setModelUrl(uiId, resolved);
    }

    return Product(
      id: uiId,
      name: product.name,
      brand: shopName,
      sku: 'PF${id.toString().padLeft(5, '0')}',
      price: effectivePrice,
      originalPrice: originalPrice,
      imageUrl: imageUrl.isEmpty
          ? 'assets/images/categories/chair.jpg'
          : imageUrl,
      svgIconPath: _categoryIcons[categoryId] ?? 'assets/icons/ic_chair.svg',
      hasArView: has3dPreview,
      categoryId: categoryId,
      dimensions: dimensions,
      vendorId: product.vendorId.toString(),
      offerLabel: hasActiveOffer(product) ? _offerLabelFromApi(product) : '',
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

  static double effectiveUnitPrice(api.Product product) {
    final listPrice = product.price;
    final discountPrice = product.discountPrice;
    if (discountPrice != null &&
        discountPrice > 0 &&
        discountPrice < listPrice) {
      return discountPrice;
    }
    final discountPercentage = product.discountPercentage;
    if (discountPercentage != null &&
        discountPercentage > 0 &&
        discountPercentage < 100) {
      return listPrice * (1 - discountPercentage / 100);
    }
    return listPrice;
  }

  static bool hasActiveOffer(api.Product product) {
    return product.isOffer || effectiveUnitPrice(product) < product.price;
  }

  static String _offerLabelFromApi(api.Product product) {
    return product.warranty?.trim() ?? '';
  }

  static Future<String> _resolvePrimaryImage(api.Product product) async {
    final thumbnail = product.thumbnailUrl?.trim();
    if (thumbnail != null && thumbnail.isNotEmpty) {
      return resolveMediaUrl(thumbnail);
    }

    for (final viewUrl in product.viewImageUrls ?? const <String>[]) {
      final trimmed = viewUrl.trim();
      if (trimmed.isEmpty) continue;
      return resolveMediaUrl(trimmed);
    }

    return '';
  }
}
