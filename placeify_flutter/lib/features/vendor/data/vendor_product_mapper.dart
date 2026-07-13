import 'package:placeify_client/placeify_client.dart' as api;

import '../../../core/config/resolve_media_url.dart';
import '../../cart/data/product_id_codec.dart';
import '../../home/data/catalog_product_mapper.dart';
import '../../product_detail/data/product_3d_model_resolver.dart';
import '../domain/models/vendor_product.dart';

abstract final class VendorProductMapper {
  static Future<VendorProduct> fromApiProduct(
    api.Product product, {
    required String vendorId,
  }) async {
    final id = product.id;
    if (id == null) {
      throw StateError('Server product is missing a database id.');
    }

    final thumbnail = product.thumbnailUrl;
    final imageUrls = <String>[];
    if (thumbnail != null && thumbnail.isNotEmpty) {
      imageUrls.add(await resolveMediaUrl(thumbnail));
    }
    final extraViews = product.viewImageUrls ?? const <String>[];
    for (final viewUrl in extraViews) {
      final trimmed = viewUrl.trim();
      if (trimmed.isEmpty) continue;
      imageUrls.add(await resolveMediaUrl(trimmed));
    }

    final uiId = ProductIdCodec.fromDatabaseId(id);
    final model3dUrl = product.model3dUrl?.trim();
    final has3dPreview = model3dUrl != null && model3dUrl.isNotEmpty;
    if (has3dPreview) {
      Product3dModelResolver.setModelUrl(
        uiId,
        await resolveMediaUrl(model3dUrl),
      );
    }

    final listPrice = product.price;
    final effectivePrice = CatalogProductMapper.effectiveUnitPrice(product);
    final hasOffer = CatalogProductMapper.hasActiveOffer(product);
    final model3dStatus = (product.model3dStatus ?? 'none').trim().isEmpty
        ? 'none'
        : product.model3dStatus!.trim();

    return VendorProduct(
      id: uiId,
      vendorId: vendorId,
      name: product.name,
      sku: 'PF${id.toString().padLeft(5, '0')}',
      price: effectivePrice,
      originalPrice: hasOffer ? listPrice : null,
      stock: 0,
      imageUrls: imageUrls,
      categoryId: product.category?.name ?? 'chairs',
      isActive: product.status == api.ProductStatus.active,
      createdAt: product.createdAt,
      description: product.description,
      brand: product.assemblyNote ?? product.vendor?.shopName ?? '',
      offerLabel: product.warranty ?? '',
      widthCm: product.widthCm ?? 0,
      depthCm: product.depthCm ?? 0,
      heightCm: product.heightCm ?? 0,
      weightKg: product.weightKg ?? 0,
      hasArView: has3dPreview,
      model3dStatus: model3dStatus,
      model3dError: product.model3dError?.trim() ?? '',
      materials: product.materials ?? '',
    );
  }
}
