import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/home/presentation/providers/catalog_provider.dart';
import 'package:placeify_flutter/features/product_detail/data/product_3d_model_loader.dart';
import 'package:placeify_flutter/features/product_detail/data/product_3d_model_resolver.dart';
import 'package:placeify_flutter/features/vendor/domain/exceptions/vendor_product_action_exception.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_product.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_profile_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_products_provider.g.dart';

@riverpod
class VendorProductsSaving extends _$VendorProductsSaving {
  @override
  bool build() => false;

  void setSaving(bool value) => state = value;
}

@riverpod
class VendorProducts extends _$VendorProducts {
  @override
  Future<List<VendorProduct>> build() => _load();

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  Future<List<VendorProduct>> _load() async {
    final user = await ref.watch(currentUserProvider.future);
    if (user?.vendorStatus != VendorStatus.approved || user?.vendorId == null) {
      return [];
    }

    final repo = ref.watch(vendorProductRepositoryProvider);
    return repo.getProducts(user!.vendorId!);
  }

  Future<void> _setSaving(bool value) async {
    ref.read(vendorProductsSavingProvider.notifier).setSaving(value);
  }

  Future<({VendorProduct? product, String? error})> createProduct(
    VendorProduct product,
  ) async {
    try {
      await _setSaving(true);
      final user = await ref.read(currentUserProvider.future);
      final vendorId = user?.vendorId;
      if (vendorId == null) {
        return (product: null, error: 'Vendor account not found.');
      }

      final repo = ref.read(vendorProductRepositoryProvider);
      final created = await repo.createProduct(vendorId, product);

      final products = state.value ?? [];
      state = AsyncData([created, ...products]);
      try {
        await publishProductToCustomerCatalog(ref, created);
      } catch (_) {
        // Upload succeeded; catalog sync can retry on refresh.
      }
      return (product: created, error: null);
    } on VendorProductActionException catch (e) {
      return (product: null, error: e.message);
    } catch (error) {
      return (
        product: null,
        error: _unexpectedProductError(error, 'Could not create product. Try again.'),
      );
    } finally {
      await _setSaving(false);
    }
  }

  Future<({VendorProduct? product, String? error})> updateProduct(
    VendorProduct product,
  ) async {
    final previous = state;
    final products = state.value;
    if (products == null) {
      return (product: null, error: 'Products are still loading.');
    }

    final index = products.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      state = AsyncData([
        ...products.sublist(0, index),
        product,
        ...products.sublist(index + 1),
      ]);
    }

    try {
      await _setSaving(true);
      final user = await ref.read(currentUserProvider.future);
      final vendorId = user?.vendorId;
      if (vendorId == null) {
        state = previous;
        return (product: null, error: 'Vendor account not found.');
      }

      final repo = ref.read(vendorProductRepositoryProvider);
      final updated = await repo.updateProduct(vendorId, product);

      if (index >= 0) {
        final synced = [...state.value!];
        synced[index] = updated;
        state = AsyncData(synced);
      } else {
        await refresh();
      }
      try {
        await publishProductToCustomerCatalog(ref, updated);
      } catch (_) {
        // Update succeeded; catalog sync can retry on refresh.
      }
      return (product: updated, error: null);
    } on VendorProductActionException catch (e) {
      state = previous;
      return (product: null, error: e.message);
    } catch (error) {
      state = previous;
      return (
        product: null,
        error: _unexpectedProductError(error, 'Could not update product. Try again.'),
      );
    } finally {
      await _setSaving(false);
    }
  }

  Future<String?> regenerateProductModel3d(
    String productId, {
    List<String>? imageSources,
  }) async {
    try {
      await _setSaving(true);
      final user = await ref.read(currentUserProvider.future);
      final vendorId = user?.vendorId;
      if (vendorId == null) {
        return 'Vendor account not found.';
      }

      final repo = ref.read(vendorProductRepositoryProvider);
      final updated = await repo.regenerateProductModel3d(
        vendorId,
        productId,
        imageSources: imageSources,
      );

      await Product3dModelLoader.invalidateCache(productId);
      Product3dModelResolver.clearModelUrl(productId);

      final products = state.value;
      if (products != null) {
        final index = products.indexWhere((item) => item.id == productId);
        if (index >= 0) {
          final synced = [...products];
          synced[index] = updated;
          state = AsyncData(synced);
        } else {
          await refresh();
        }
      }
      await publishProductToCustomerCatalog(ref, updated);
      return null;
    } on VendorProductActionException catch (e) {
      return e.message;
    } catch (error) {
      return _unexpectedProductError(
        error,
        'Could not build 3D preview. Try again.',
      );
    } finally {
      await _setSaving(false);
    }
  }

  Future<String?> applyBulkDiscount(
    List<String> productIds,
    double discountPercent,
  ) async {
    if (productIds.isEmpty) return 'No products selected.';

    final products = state.value;
    if (products == null) return 'Products are still loading.';

    final ids = productIds.toSet();
    final targets = products.where((product) => ids.contains(product.id));
    if (targets.isEmpty) return 'Selected products not found.';

    for (final product in targets) {
      final listPrice = product.originalPrice ?? product.price;
      final salePrice = listPrice * (1 - discountPercent / 100);
      final updated = product.copyWith(
        price: salePrice,
        originalPrice: listPrice,
        offerLabel: '${discountPercent.round()}% off',
      );
      final error = await updateProduct(updated);
      if (error.error != null) return error.error;
    }

    return null;
  }

  Future<String?> deleteProducts(List<String> productIds) async {
    if (productIds.isEmpty) return 'No products selected.';

    final previous = state;
    final products = state.value;
    if (products == null) return 'Products are still loading.';

    final ids = productIds.toSet();
    state = AsyncData(
      products.where((product) => !ids.contains(product.id)).toList(),
    );

    try {
      await _setSaving(true);
      final user = await ref.read(currentUserProvider.future);
      final vendorId = user?.vendorId;
      if (vendorId == null) {
        state = previous;
        return 'Vendor account not found.';
      }

      final repo = ref.read(vendorProductRepositoryProvider);
      await repo.deleteProducts(vendorId, productIds.toList());
      for (final id in productIds) {
        ref.read(catalogIndexProvider.notifier).removeProduct(id);
      }
      invalidateCustomerCatalog(ref);
      return null;
    } on VendorProductActionException catch (e) {
      state = previous;
      return e.message;
    } catch (_) {
      state = previous;
      return 'Could not delete products. Try again.';
    } finally {
      await _setSaving(false);
    }
  }

  String _unexpectedProductError(Object error, String fallback) {
    if (error is StateError) return error.message;
    final text = error.toString().replaceFirst('Exception: ', '').trim();
    if (text.isEmpty || text == error.runtimeType.toString()) return fallback;
    return text.length <= 160 ? text : fallback;
  }
}
