import 'package:placeify_client/placeify_client.dart' as api;

import '../../../core/config/resolve_media_url.dart';
import '../../cart/data/product_id_codec.dart';
import '../../product_detail/data/product_model_3d_urls.dart';
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

    final uiId = ProductIdCodec.fromDatabaseId(id);
    final model3dUrl = product.model3dUrl?.trim();
    final has3dPreview = model3dUrl != null && model3dUrl.isNotEmpty;
    if (has3dPreview) {
      ProductModel3dUrls.set(uiId, await resolveMediaUrl(model3dUrl));
    }

    return VendorProduct(
      id: uiId,
      vendorId: vendorId,
      name: product.name,
      sku: 'PF${id.toString().padLeft(5, '0')}',
      price: product.price,
      stock: 0,
      imageUrls: imageUrls,
      categoryId: product.category?.name ?? 'chairs',
      isActive: product.status == api.ProductStatus.active,
      createdAt: product.createdAt,
      description: product.description,
      brand: product.vendor?.shopName ?? '',
      widthCm: product.widthCm ?? 0,
      depthCm: product.depthCm ?? 0,
      heightCm: product.heightCm ?? 0,
      weightKg: product.weightKg ?? 0,
      hasArView: has3dPreview,
      materials: product.materials ?? '',
    );
  }
}
