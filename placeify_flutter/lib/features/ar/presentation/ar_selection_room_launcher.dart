import 'package:flutter/material.dart';

import '../../../core/widgets/toast_overlay.dart';
import '../../home/domain/models/product.dart';
import '../../product_detail/data/product_3d_model_resolver.dart';
import '../../product_detail/presentation/ar_room_screen.dart';
import '../../product_detail/presentation/widgets/ar_product_tray.dart';

/// Launches the existing live AR room with the selected products.
///
/// Shared by My AR and the product-grid selection bar so both entry points
/// prepare models, pass tray products, and report failures identically.
abstract final class ArSelectionRoomLauncher {
  static Future<ArRoomOpenResult?> open({
    required BuildContext context,
    required List<Product> selectedProducts,
  }) async {
    if (selectedProducts.isEmpty) return null;

    final primary = selectedProducts.first;
    final remoteUrl = await Product3dModelResolver.ensureSrcForProduct(primary);
    if (!context.mounted) return null;
    if (remoteUrl == null || remoteUrl.isEmpty) {
      PlaceifyToast.show(
        context,
        '3D model is not available for ${primary.name} yet.',
      );
      return ArRoomOpenResult.modelDownloadFailed;
    }

    final availableProducts = <ArAddableProduct>[];
    for (final product in selectedProducts) {
      if (!product.hasArView) continue;
      if (product.id != primary.id) {
        await Product3dModelResolver.ensureSrcForProduct(product);
      }
      final addable = ArAddableProduct.tryFromProduct(product);
      if (addable != null) availableProducts.add(addable);
    }

    if (!context.mounted) return null;
    final result = await ArRoomLauncher.open(
      context: context,
      remoteModelUrl: remoteUrl,
      productId: primary.id,
      productName: primary.name,
      dimensions: primary.dimensions,
      availableProducts: availableProducts,
    );

    if (!context.mounted) return result;
    switch (result) {
      case ArRoomOpenResult.permissionDenied:
        PlaceifyToast.show(context, 'Camera permission is required for AR.');
      case ArRoomOpenResult.modelDownloadFailed:
        PlaceifyToast.show(context, 'Could not load the 3D model.');
      case ArRoomOpenResult.opened:
        break;
    }
    return result;
  }
}
