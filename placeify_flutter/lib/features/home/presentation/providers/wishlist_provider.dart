import 'dart:async';

import 'package:placeify_client/placeify_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../cart/data/product_id_codec.dart';
import '../../../../core/config/placeify_server_client.dart';
import '../../../profile/presentation/providers/profile_dashboard_provider.dart';
import '../../../user/presentation/providers/user_wishlist_provider.dart';

part 'wishlist_provider.g.dart';

/// Product id → time saved (newest first when listed).
@Riverpod(keepAlive: true)
class Wishlist extends _$Wishlist {
  @override
  Map<String, DateTime> build() {
    ref.listen(currentUserProvider, (previous, next) {
      unawaited(_refresh());
    });
    Future.microtask(_refresh);
    return {};
  }

  Future<void> _refresh() async {
    if (!client.auth.isAuthenticated) {
      state = {};
      return;
    }

    try {
      final page = await ref.read(userWishlistRepositoryProvider).listWishlist(
            pagination: PaginationInput(page: 1, pageSize: 100),
          );
      state = {
        for (final item in page.items)
          if (item.product?.id != null)
            ProductIdCodec.fromDatabaseId(item.product!.id!): item.createdAt,
      };
    } catch (_) {
      // Keep previous state on transient errors.
    }
  }

  bool isLiked(String productId) {
    final id = ProductIdCodec.normalizeUiProductId(productId);
    return state.containsKey(id);
  }

  Future<void> toggle(String productId) async {
    final id = ProductIdCodec.normalizeUiProductId(productId);
    if (!client.auth.isAuthenticated) return;

    final wasLiked = state.containsKey(id);
    if (wasLiked) {
      state = Map<String, DateTime>.from(state)..remove(id);
    } else {
      state = Map<String, DateTime>.from(state)..[id] = DateTime.now();
    }

    try {
      await ref.read(userWishlistRepositoryProvider).toggle(id);
      await _refresh();
      ref.invalidate(profileDashboardProvider);
    } catch (_) {
      await _refresh();
    }
  }
}
