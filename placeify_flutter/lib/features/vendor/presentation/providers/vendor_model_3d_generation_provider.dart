import 'package:placeify_flutter/features/vendor/data/vendor_3d_model_store.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_product.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_products_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_model_3d_generation_provider.g.dart';

/// Tracks in-flight "start Tripo" client calls so Build 3D can leave the screen
/// without abandoning photo sync / queue work.
@Riverpod(keepAlive: true)
class VendorModel3dGeneration extends _$VendorModel3dGeneration {
  @override
  Set<String> build() => {};

  bool isStarting(String productId) => state.contains(productId);

  /// Uploads any local picks (if needed), queues Tripo, and updates local store.
  /// Survives leaving Build 3D — store / product list are updated even if no UI
  /// is watching.
  Future<String?> start(
    String productId, {
    required List<String> imageSources,
  }) async {
    if (state.contains(productId)) return null;

    state = {...state, productId};
    Vendor3dModelStore.markProcessing(productId);

    try {
      final error = await ref
          .read(vendorProductsProvider.notifier)
          .regenerateProductModel3d(
            productId,
            imageSources: imageSources,
          );

      if (error != null) {
        Vendor3dModelStore.markFailed(productId, error);
        return error;
      }

      final products = ref.read(vendorProductsProvider).value ?? const [];
      final updated = _productById(products, productId);
      if (updated != null) {
        Vendor3dModelStore.preloadFromProduct(updated);
      } else {
        Vendor3dModelStore.markProcessing(productId);
      }
      return null;
    } catch (error) {
      final message = error.toString().replaceFirst('Exception: ', '').trim();
      final fallback = message.isEmpty
          ? 'Could not build 3D preview. Try again.'
          : message;
      Vendor3dModelStore.markFailed(productId, fallback);
      return fallback;
    } finally {
      final next = Set<String>.from(state)..remove(productId);
      state = next;
    }
  }

  VendorProduct? _productById(List<VendorProduct> products, String productId) {
    for (final product in products) {
      if (product.id == productId) return product;
    }
    return null;
  }
}
