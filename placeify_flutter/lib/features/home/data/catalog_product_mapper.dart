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

  static const _categoryAssets = <String, String>{
    'chairs': 'assets/images/categories/chair.jpg',
    'sofas': 'assets/images/categories/sofa.jpg',
    'tables': 'assets/images/categories/table.jpg',
    'desks': 'assets/images/categories/desk.jpg',
    'beds': 'assets/images/categories/bed.jpg',
    'storage': 'assets/images/categories/storage.jpg',
    'lighting': 'assets/images/categories/lighting.jpg',
    'lights': 'assets/images/categories/lighting.jpg',
    'outdoor': 'assets/images/categories/outdoor.jpg',
    'decor': 'assets/images/categories/outdoor.jpg',
  };

  static String _categoryAsset(String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) {
      return _categoryAssets['chairs']!;
    }
    return _categoryAssets[categoryId] ?? _categoryAssets['chairs']!;
  }

  static bool _isBrokenThumbnail(String? url) {
    if (url == null || url.isEmpty) return true;
    return url.contains('Instance of');
  }

  static Future<Product> toUiProduct(api.Product product) async {
    final id = product.id;
    if (id == null) {
      throw StateError('Catalog product is missing a database id.');
    }

    final categoryId = product.category?.name ?? 'chairs';
    final shopName = product.vendor?.shopName ?? 'Placeify vendor';
    final imageUrls = await _resolveImageUrls(product, categoryId);
    final imageUrl =
        imageUrls.isNotEmpty ? imageUrls.first : _categoryAsset(categoryId);

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
      imageUrl: imageUrl,
      imageUrls: imageUrls,
      svgIconPath: _categoryIcons[categoryId] ?? 'assets/icons/ic_chair.svg',
      hasArView: has3dPreview,
      categoryId: categoryId,
      dimensions: dimensions,
      vendorId: product.vendorId.uuid,
      description: product.description,
      materials: product.materials,
      weightKg: product.weightKg,
      assemblyNote: product.assemblyNote,
      careInstructions: product.careInstructions,
      warranty: product.warranty,
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

  static Future<String> _resolvePrimaryImage(
    api.Product product,
    String categoryId,
  ) async {
    final urls = await _resolveImageUrls(product, categoryId);
    return urls.isNotEmpty ? urls.first : _categoryAsset(categoryId);
  }

  /// Returns all real uploaded images (thumbnail + view images). Never pads
  /// with category placeholders when at least one upload exists.
  static Future<List<String>> _resolveImageUrls(
    api.Product product,
    String categoryId,
  ) async {
    final resolved = <String>[];

    Future<void> addResolved(String? raw) async {
      final trimmed = raw?.trim();
      if (trimmed == null || trimmed.isEmpty || _isBrokenThumbnail(trimmed)) {
        return;
      }
      final url = await resolveMediaUrl(trimmed);
      if (url.isEmpty || resolved.contains(url)) return;
      resolved.add(url);
    }

    await addResolved(product.thumbnailUrl);
    for (final viewUrl in product.viewImageUrls ?? const <String>[]) {
      await addResolved(viewUrl);
    }

    return resolved;
  }
}
