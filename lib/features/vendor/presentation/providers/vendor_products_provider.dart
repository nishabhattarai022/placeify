import 'package:placeify/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify/features/vendor/data/mock_vendor_product_repository.dart';
import 'package:placeify/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify/features/vendor/domain/models/vendor_product.dart';
import 'package:placeify/features/vendor/presentation/providers/vendor_profile_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_products_provider.g.dart';

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
    }
  }
}
