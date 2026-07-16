import 'dart:async';

import 'package:placeify_client/placeify_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../cart/data/product_id_codec.dart';
import '../../../../core/config/placeify_server_client.dart';
import '../../data/catalog_product_mapper.dart';
import '../../../profile/data/wishlist_api_errors.dart';
import '../providers/catalog_provider.dart';
import '../../../profile/presentation/providers/profile_dashboard_provider.dart';
import '../../../user/presentation/providers/user_wishlist_provider.dart';
import 'wishlist_toggle_result.dart';

part 'wishlist_provider.g.dart';

/// Product id → time saved. Backed by Serverpod wishlist endpoints.
@Riverpod(keepAlive: true)
class Wishlist extends _$Wishlist {
  @override
  Map<String, DateTime> build() {
    // Do not watch [catalogIndexProvider] — periodic catalog sync would rebuild
    // this notifier and wipe wishlist ids.
    ref.listen(catalogIndexProvider, (previous, next) {
      if (!next.hasValue || state.isEmpty) return;
      unawaited(
        ref.read(catalogIndexProvider.notifier).ensureProducts(state.keys),
      );
    });
    ref.listen(currentUserProvider, (previous, next) {
      next.whenData((user) {
        if (user == null) {
          state = {};
          return;
        }
        unawaited(_refresh());
      });
    });
    Future.microtask(_refresh);
    return {};
  }

  Future<void> refresh() => _refresh();

  Future<void> _refresh() async {
    if (!client.auth.isAuthenticated) {
      state = {};
      return;
    }

    try {
      final page = await ref.read(userWishlistRepositoryProvider).listWishlist(
            pagination: PaginationInput(page: 1, pageSize: 100),
          );

      final catalog = ref.read(catalogIndexProvider.notifier);
      final uiIds = <String>[];
      final nextState = <String, DateTime>{};

      for (final item in page.items) {
        final dbProductId = item.product?.id ?? item.productId;
        final uiId = ProductIdCodec.fromDatabaseId(dbProductId);
        uiIds.add(uiId);
        nextState[uiId] = item.createdAt;

        final apiProduct = item.product;
        if (apiProduct?.id != null) {
          try {
            final uiProduct =
                await CatalogProductMapper.toUiProduct(apiProduct!);
            catalog.upsertProduct(uiProduct);
          } catch (_) {
            // ensureProducts below still attempts a direct fetch.
          }
        }
      }

      state = nextState;

      if (uiIds.isNotEmpty) {
        try {
          await catalog.ensureProducts(uiIds);
        } catch (_) {
          // Catalog enrichment must not block wishlist ids/count sync.
        }
      }
    } catch (_) {
      // Keep previous state on transient errors.
    }
  }

  bool isLiked(String productId) {
    final id = ProductIdCodec.normalizeUiProductId(productId);
    return state.containsKey(id);
  }

  Future<WishlistToggleResult> toggle(String productId) async {
    final id = ProductIdCodec.normalizeUiProductId(productId);
    if (!client.auth.isAuthenticated) {
      return WishlistToggleResult.error(
        'Sign in to save items to your wishlist.',
      );
    }

    final wasLiked = state.containsKey(id);

    // Optimistic local update for instant icon feedback.
    if (wasLiked) {
      state = Map<String, DateTime>.from(state)..remove(id);
    } else {
      state = Map<String, DateTime>.from(state)..[id] = DateTime.now();
    }

    try {
      final repo = ref.read(userWishlistRepositoryProvider);
      await repo.toggle(id);
      await _refresh();
      ref.invalidate(profileDashboardProvider);
      ref.invalidate(userWishlistProvider);
      return wasLiked
          ? const WishlistToggleResult.removed()
          : const WishlistToggleResult.added();
    } catch (error) {
      // Revert optimistic state, then resync.
      await _refresh();
      return WishlistToggleResult.error(WishlistApiErrors.message(error));
    }
  }
}
