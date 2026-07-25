import 'package:placeify_flutter/features/admin/domain/models/admin_product_summary.dart';
import 'package:placeify_flutter/features/admin/domain/repositories/admin_product_repository.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/admin_product_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_products_provider.g.dart';

@riverpod
class AdminProductsList extends _$AdminProductsList {
  @override
  Future<List<AdminProductSummary>> build(AdminProductListQuery query) async {
    final repo = ref.watch(adminProductRepositoryProvider);
    return repo.listProducts(query);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(adminProductRepositoryProvider);
      return repo.listProducts(query);
    });
  }
}

@riverpod
Future<AdminProductDetail?> adminProductDetail(Ref ref, int productId) async {
  final repo = ref.watch(adminProductRepositoryProvider);
  return repo.getProductDetails(productId);
}

@riverpod
class AdminProductActions extends _$AdminProductActions {
  @override
  FutureOr<void> build() {}

  Future<String?> removeProduct({
    required int productId,
    required String reason,
  }) async {
    try {
      final repo = ref.read(adminProductRepositoryProvider);
      await repo.removeProduct(productId, reason: reason);
      ref.invalidate(adminProductDetailProvider(productId));
      ref.invalidate(adminProductsListProvider);
      return null;
    } catch (error) {
      return error.toString();
    }
  }

  Future<String?> restoreProduct(int productId) async {
    try {
      final repo = ref.read(adminProductRepositoryProvider);
      await repo.restoreProduct(productId);
      ref.invalidate(adminProductDetailProvider(productId));
      ref.invalidate(adminProductsListProvider);
      return null;
    } catch (error) {
      return error.toString();
    }
  }
}
