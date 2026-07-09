import 'dart:async';

import 'package:placeify_client/placeify_client.dart' hide Product;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../cart/data/product_id_codec.dart';
import '../../../../core/config/placeify_server_client.dart';
import '../../data/catalog_product_mapper.dart';
import '../../data/serverpod_product_repository.dart';
import '../../domain/models/product.dart';
import '../../domain/models/wishlist_snapshot.dart';
import '../../../profile/data/wishlist_api_errors.dart';
import '../providers/catalog_provider.dart';
import '../../../profile/presentation/providers/profile_dashboard_provider.dart';
import '../../../user/presentation/providers/user_wishlist_provider.dart';
import 'wishlist_toggle_result.dart';

part 'wishlist_provider.g.dart';

@Riverpod(keepAlive: true)
class Wishlist extends _$Wishlist {
  @override
  WishlistSnapshot build() {
    ref.listen(catalogIndexProvider, (previous, next) {
      if (!next.hasValue || state.isEmpty) return;
      unawaited(
        ref.read(catalogIndexProvider.notifier).ensureProducts(state.keys),
      );
    });
    ref.listen(currentUserProvider, (previous, next) {
      // Only react to resolved auth data — never clear on AsyncLoading (e.g.
      // profile refresh), which was wiping the list while counts stayed up.
      next.whenData((user) {
        if (user == null) {
          state = WishlistSnapshot.empty;
          return;
        }
        unawaited(_refresh());
      });
    });
    Future.microtask(_refresh);
    return WishlistSnapshot.empty;
  }

  Future<void> refresh() => _refresh();

  Future<void> _refresh() async {
    if (!client.auth.isAuthenticated) {
      state = WishlistSnapshot.empty;
      return;
    }

    try {
      final page = await ref
          .read(userWishlistRepositoryProvider)
          .listWishlist(
            pagination: PaginationInput(page: 1, pageSize: 100),
          );

      final catalog = ref.read(catalogIndexProvider.notifier);
      final productRepo = ref.read(catalogRepositoryProvider);
      final nextSavedAt = <String, DateTime>{};
      final nextProducts = <Product>[];

      final categoryNamesById = {
        for (final category
            in await ref.read(catalogRepositoryProvider).listCategories())
          if (category.id != null) category.id!: category.name,
      };

      for (final item in page.items) {
        final dbProductId = item.product?.id ?? item.productId;
        final uiId = ProductIdCodec.fromDatabaseId(dbProductId);
        nextSavedAt[uiId] = item.createdAt;

        Product? uiProduct;
        final apiProduct = item.product;
        if (apiProduct?.id != null) {
          try {
            uiProduct = await CatalogProductMapper.toUiProduct(
              apiProduct!,
              categoryNamesById: categoryNamesById,
            );
          } catch (_) {
            // Fall through to direct fetch below.
          }
        }

        uiProduct ??= await _fetchUiProduct(
          productRepo,
          uiId,
          categoryNamesById: categoryNamesById,
        );
        if (uiProduct == null) continue;

        nextProducts.add(uiProduct);
        catalog.upsertProduct(uiProduct);
      }

      state = WishlistSnapshot(
        savedAt: nextSavedAt,
        products: nextProducts,
      );

      if (nextSavedAt.isNotEmpty) {
        try {
          await catalog.ensureProducts(nextSavedAt.keys);
        } catch (_) {
          // Catalog enrichment must not block wishlist display.
        }
      }
    } catch (_) {
      // Keep previous snapshot on transient errors.
    }
  }

  Future<Product?> _fetchUiProduct(
    ServerpodProductRepository repo,
    String uiId, {
    required Map<int, String> categoryNamesById,
  }) async {
    try {
      final apiProduct = await repo.getByUiId(uiId);
      if (apiProduct == null) return null;
      return CatalogProductMapper.toUiProduct(
        apiProduct,
        categoryNamesById: categoryNamesById,
      );
    } catch (_) {
      return null;
    }
  }

  bool isLiked(String productId) {
    final id = ProductIdCodec.normalizeUiProductId(productId);
    return state.savedAt.containsKey(id);
  }

  Future<WishlistToggleResult> toggle(String productId) async {
    final id = ProductIdCodec.normalizeUiProductId(productId);
    if (!client.auth.isAuthenticated) {
      return WishlistToggleResult.error(
        'Sign in to save items to your wishlist.',
      );
    }

    final wasLiked = state.savedAt.containsKey(id);

    try {
      final repo = ref.read(userWishlistRepositoryProvider);
      if (wasLiked) {
        await repo.remove(id);
      } else {
        await repo.add(id);
      }
      await _refresh();
      ref.invalidate(profileDashboardProvider);
      return wasLiked
          ? const WishlistToggleResult.removed()
          : const WishlistToggleResult.added();
    } catch (error) {
      return WishlistToggleResult.error(WishlistApiErrors.message(error));
    }
  }
}
