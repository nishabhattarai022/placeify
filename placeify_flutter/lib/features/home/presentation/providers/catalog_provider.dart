import 'dart:async';

import 'package:placeify_client/placeify_client.dart' hide Product;
import 'package:placeify_flutter/features/shops/presentation/providers/consumer_shop_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../cart/data/product_id_codec.dart';
import '../../../vendor/domain/models/vendor_product.dart';
import '../../data/catalog_category_utils.dart';
import '../../data/catalog_product_mapper.dart';
import '../../data/serverpod_product_repository.dart';
import '../../data/vendor_product_catalog_mapper.dart';
import '../../domain/models/product.dart';
import 'home_room_provider.dart';
import 'room_category_products_provider.dart';

part 'catalog_provider.g.dart';

const _catalogSyncInterval = Duration(seconds: 20);

@Riverpod(keepAlive: true)
ServerpodProductRepository catalogRepository(Ref ref) {
  return ServerpodProductRepository();
}

/// All active marketplace products (seed + vendor listings).
@Riverpod(keepAlive: true)
class CatalogIndex extends _$CatalogIndex {
  Timer? _syncTimer;

  @override
  Future<Map<String, Product>> build() async {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(_catalogSyncInterval, (_) {
      unawaited(refresh(silent: true));
    });
    ref.onDispose(() => _syncTimer?.cancel());
    return _loadIndex();
  }

  Future<Map<String, Product>> _loadIndex() async {
    final repo = ref.read(catalogRepositoryProvider);
    final categoryNamesById = await _loadCategoryNamesById(repo);
    final page = await repo.search(
      pagination: PaginationInput(page: 1, pageSize: 200),
    );

    final index = <String, Product>{};
    for (final item in page.items) {
      final ui = await CatalogProductMapper.toUiProduct(
        item,
        categoryNamesById: categoryNamesById,
      );
      index[ui.id] = ui;
    }
    return index;
  }

  Future<Map<int, String>> _loadCategoryNamesById(
    ServerpodProductRepository repo,
  ) async {
    final categories = await repo.listCategories();
    return {
      for (final category in categories)
        if (category.id != null) category.id!: category.name,
    };
  }

  Future<void> upsertVendorProduct(VendorProduct vendorProduct) async {
    if (!vendorProduct.isActive) {
      removeProduct(vendorProduct.id);
      return;
    }

    final ui = await VendorProductCatalogMapper.toUiProduct(vendorProduct);
    upsertProduct(ui);
  }

  void upsertProduct(Product product) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData({...current, product.id: product});
  }

  void removeProduct(String productId) {
    final current = state.value;
    if (current == null || !current.containsKey(productId)) return;
    final next = Map<String, Product>.from(current)..remove(productId);
    state = AsyncData(next);
  }

  Future<void> refresh({bool silent = false}) async {
    if (!silent) {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(_loadIndex);
  }

  /// Fetches catalog products missing from the in-memory index (e.g. cart lines).
  Future<void> ensureProducts(Iterable<String> productIds) async {
    final current = state.value ?? {};
    final missing = productIds
        .where((id) => id.trim().isNotEmpty && current[id] == null)
        .toSet();
    if (missing.isEmpty) return;

    final repo = ref.read(catalogRepositoryProvider);
    final categoryNamesById = await _loadCategoryNamesById(repo);
    final additions = <String, Product>{};

    for (final id in missing) {
      final apiProduct = await repo.getByUiId(id);
      if (apiProduct == null) continue;
      final ui = await CatalogProductMapper.toUiProduct(
        apiProduct,
        categoryNamesById: categoryNamesById,
      );
      additions[ui.id] = ui;
    }

    if (additions.isEmpty) return;
    state = AsyncData({...current, ...additions});
  }
}

@riverpod
List<Product> catalogProducts(Ref ref) {
  final index = ref.watch(catalogIndexProvider).value;
  if (index == null) return const [];
  final products = index.values.toList()
    ..sort((a, b) => ProductIdCodec.compareNewestFirst(a.id, b.id));
  return products;
}

@riverpod
List<Product> catalogProductsByCategory(Ref ref, String categoryId) {
  ref.watch(catalogIndexProvider);
  return ref
      .watch(catalogProductsProvider)
      .where((product) => product.categoryId == categoryId)
      .toList();
}

/// Nisha browse category list: live catalog only.
@riverpod
List<Product> browseCategoryProducts(Ref ref, String uiCategoryId) {
  ref.watch(catalogIndexProvider);
  return ref
      .watch(catalogProductsProvider)
      .where(
        (product) => CatalogCategoryUtils.matchesUiCategory(
          product.categoryId,
          uiCategoryId,
        ),
      )
      .toList();
}

@riverpod
int browseCatalogItemCount(Ref ref) {
  ref.watch(catalogIndexProvider);
  return ref.watch(catalogProductsProvider).length;
}

@riverpod
int categoryProductCount(Ref ref, String categoryId) {
  return ref.watch(browseCategoryProductsProvider(categoryId)).length;
}

@riverpod
List<Product> catalogDiscountedProducts(Ref ref) {
  return ref
      .watch(catalogProductsProvider)
      .where((product) => product.isOnSale)
      .take(6)
      .toList();
}

@riverpod
List<Product> catalogNewestProducts(Ref ref, int count) {
  return ref.watch(catalogProductsProvider).take(count).toList();
}

@riverpod
List<Product> homeFeaturedProducts(Ref ref) {
  final products = ref.watch(catalogProductsProvider);
  if (products.length <= 4) return products;
  return products.sublist(0, 4);
}

@riverpod
Future<Product?> productDetail(Ref ref, String id) async {
  final cached = ref.watch(catalogIndexProvider).value?[id];
  if (cached != null) return cached;

  final repo = ref.read(catalogRepositoryProvider);
  final apiProduct = await repo.getByUiId(id);
  if (apiProduct == null) return null;

  final categoryNamesById = {
    for (final category in await repo.listCategories())
      if (category.id != null) category.id!: category.name,
  };
  return CatalogProductMapper.toUiProduct(
    apiProduct,
    categoryNamesById: categoryNamesById,
  );
}

/// Room → furniture category ids for home recommendations.
@riverpod
List<Product> roomCatalogProducts(Ref ref, String roomId) {
  ref.watch(catalogIndexProvider);
  final products = ref.watch(catalogProductsProvider);
  final categoryIds = CatalogCategoryUtils.furnitureCategoryIdsForRoom(roomId);
  if (categoryIds.isEmpty) return products;

  return products
      .where(
        (product) => categoryIds.any(
          (categoryId) => CatalogCategoryUtils.matchesUiCategory(
            product.categoryId,
            categoryId,
          ),
        ),
      )
      .toList();
}

@riverpod
List<Product> homeRecommendedProducts(Ref ref, String roomId) {
  ref.watch(catalogIndexProvider);
  final roomProducts = ref.watch(roomCatalogProductsProvider(roomId));
  if (roomProducts.isEmpty) {
    return ref.watch(catalogProductsProvider).take(2).toList();
  }

  final categoryIds = CatalogCategoryUtils.furnitureCategoryIdsForRoom(roomId);
  final picked = <Product>[];

  for (final categoryId in categoryIds) {
    if (picked.length >= 2) break;
    for (final product in roomProducts) {
      if (picked.length >= 2) break;
      if (picked.any((item) => item.id == product.id)) continue;
      if (CatalogCategoryUtils.matchesUiCategory(
        product.categoryId,
        categoryId,
      )) {
        picked.add(product);
        break;
      }
    }
  }

  if (picked.length >= 2) return picked;

  for (final product in roomProducts) {
    if (picked.length >= 2) break;
    if (picked.any((item) => item.id == product.id)) continue;
    picked.add(product);
  }
  return picked;
}

@riverpod
int catalogProductCount(Ref ref) {
  final index = ref.watch(catalogIndexProvider).value;
  return index?.length ?? 0;
}

void invalidateCustomerCatalog(Ref ref) {
  ref.invalidate(catalogProductsByCategoryProvider);
  ref.invalidate(browseCategoryProductsProvider);
  ref.invalidate(categoryProductCountProvider);
  ref.invalidate(catalogDiscountedProductsProvider);
  ref.invalidate(catalogNewestProductsProvider);
  ref.invalidate(productDetailProvider);
  ref.invalidate(homeRecommendedProductsProvider);
  ref.invalidate(roomCatalogProductsProvider);
  ref.invalidate(roomCategoryProductsProvider);
  ref.invalidate(recommendedProductsProvider);
  ref.invalidate(catalogProductCountProvider);
}

Future<void> publishProductToCustomerCatalog(
  Ref ref,
  VendorProduct savedProduct,
) async {
  final notifier = ref.read(catalogIndexProvider.notifier);
  await notifier.upsertVendorProduct(savedProduct);
  ref.invalidate(shopProductsProvider(savedProduct.vendorId));
  invalidateCustomerCatalog(ref);
  unawaited(notifier.refresh(silent: true));
}

Future<void> refreshCustomerCatalog(Ref ref) async {
  invalidateCustomerCatalog(ref);
  await ref.read(catalogIndexProvider.notifier).refresh(silent: true);
}
