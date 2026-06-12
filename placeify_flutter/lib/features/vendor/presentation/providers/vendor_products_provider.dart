import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/home/presentation/providers/catalog_provider.dart';
import 'package:placeify_flutter/features/vendor/data/mock_vendor_product_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_product.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_profile_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_products_provider.g.dart';

@riverpod
class VendorProductsSaving extends _$VendorProductsSaving {
  @override
  bool build() => false;
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
    ref.read(vendorProductsSavingProvider.notifier).state = value;
  }

  Future<String?> createProduct(VendorProduct product) async {
    await _setSaving(true);
    try {
      final user = await ref.read(currentUserProvider.future);
      final vendorId = user?.vendorId;
      if (vendorId == null) {
        return 'Vendor account not found.';
      }

      final repo = ref.read(vendorProductRepositoryProvider);
      final created = await repo.createProduct(vendorId, product);

      final products = state.value ?? [];
      state = AsyncData([created, ...products]);
      ref.invalidate(catalogIndexProvider);
      return null;
    } on VendorProductActionException catch (e) {
      return e.message;
    } catch (_) {
      return 'Could not create product. Try again.';
    } finally {
      await _setSaving(false);
    }
  }

  Future<String?> updateProduct(VendorProduct product) async {
    final previous = state;
    final products = state.value;
    if (products == null) return 'Products are still loading.';

    final index = products.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      state = AsyncData([
        ...products.sublist(0, index),
        product,
        ...products.sublist(index + 1),
      ]);
    }

    await _setSaving(true);
    try {
      final user = await ref.read(currentUserProvider.future);
      final vendorId = user?.vendorId;
      if (vendorId == null) {
        state = previous;
        return 'Vendor account not found.';
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
      return null;
    } on VendorProductActionException catch (e) {
      state = previous;
      return e.message;
    } catch (_) {
      state = previous;
      return 'Could not update product. Try again.';
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
      if (error != null) return error;
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

    await _setSaving(true);
    try {
      final user = await ref.read(currentUserProvider.future);
      final vendorId = user?.vendorId;
      if (vendorId == null) {
        state = previous;
        return 'Vendor account not found.';
      }

      final repo = ref.read(vendorProductRepositoryProvider);
      await repo.deleteProducts(vendorId, productIds.toList());
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
}
