import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:placeify_client/placeify_client.dart' hide Order;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/config/placeify_server_client.dart';
import '../../../../core/debug/agent_debug_log.dart';
import '../../../../core/utils/vendor_purchase_policy.dart';
import '../../../auth/domain/models/app_user_extensions.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/catalog_provider.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../../../profile/presentation/providers/profile_dashboard_provider.dart';
import '../../data/cart_api_errors.dart';
import '../../data/product_id_codec.dart';
import '../../data/serverpod_cart_repository.dart';
import '../../domain/cart_line_item.dart';
import '../../domain/constants/cart_strings.dart';

part 'cart_provider.g.dart';

final _cartRepository = ServerpodCartRepository();

@Riverpod(keepAlive: true)
class Cart extends _$Cart {
  @override
  List<CartLineItem> build() {
    // Do not watch [catalogIndexProvider] — catalog sync rebuilds wipe cart
    // state back to [] and race Confirm Order into an empty-cart failure.
    ref.listen(catalogIndexProvider, (previous, next) {
      if (!next.hasValue || state.isEmpty) return;
      unawaited(
        ref
            .read(catalogIndexProvider.notifier)
            .ensureProducts(state.map((item) => item.productId)),
      );
    });
    ref.listen(currentUserProvider, (previous, next) {
      final wasLoggedIn = previous?.value != null;
      next.whenData((user) {
        if (user != null) {
          if (!wasLoggedIn && state.isNotEmpty) {
            unawaited(_mergeLocalCartOnSignIn());
          } else {
            unawaited(_refreshFromServer());
          }
        } else {
          state = const [];
        }
      });
    });
    Future.microtask(_refreshFromServer);
    return const [];
  }

  Future<void> _refreshFromServer() async {
    if (!client.auth.isAuthenticated) return;
    try {
      final before = state.length;
      final localBefore = [...state];
      final fetched = await _cartRepository.fetchItems();
      // Never clobber a non-empty local cart with an empty server snapshot.
      // That race empties checkout mid-flow and yields silent / CART_EMPTY failures.
      if (fetched.isEmpty && localBefore.isNotEmpty) {
        // #region agent log
        agentDebugLog(
          location: 'cart_provider.dart:_refreshFromServer:skipEmpty',
          message: 'Skipped empty server overwrite of local cart',
          hypothesisId: 'H2',
          data: {
            'before': before,
            'fetched': 0,
            'keptLocalIds':
                localBefore.map((e) => e.productId).take(8).toList(),
          },
          runId: 'post-fix',
        );
        // #endregion
        return;
      }
      state = fetched;
      // #region agent log
      agentDebugLog(
        location: 'cart_provider.dart:_refreshFromServer',
        message: 'Cart refreshed from server',
        hypothesisId: 'H2',
        data: {
          'before': before,
          'after': state.length,
          'ids': state.map((e) => e.productId).take(8).toList(),
        },
        runId: 'post-fix',
      );
      // #endregion
      await ref
          .read(catalogIndexProvider.notifier)
          .ensureProducts(state.map((item) => item.productId));
    } catch (_) {
      // Keep last known server snapshot on transient refresh failures.
    }
  }

  Future<void> refresh() => _refreshFromServer();

  void replaceItems(List<CartLineItem> items) {
    // #region agent log
    agentDebugLog(
      location: 'cart_provider.dart:replaceItems',
      message: 'Cart replaced locally',
      hypothesisId: 'H2',
      data: {
        'before': state.length,
        'after': items.length,
      },
    );
    // #endregion
    state = items;
  }

  /// Ensures server cart has items before checkout (pushes local items when needed).
  Future<List<CartLineItem>> resolveServerCartForCheckout() async {
    await client.auth.initialize();
    if (!client.auth.isAuthenticated) {
      throw StateError('Sign in to sync your cart with the server.');
    }

    final localItems = [...state];
    var serverItems = await _fetchServerCartOrRetry();

    debugPrint(
      '[cart] resolveServerCart local=${localItems.length} '
      'server=${serverItems.length}',
    );

    Object? lastSyncError;
    final needsPush = (serverItems.isEmpty && localItems.isNotEmpty) ||
        _localHasMissingServerLines(localItems, serverItems);

    if (needsPush && localItems.isNotEmpty) {
      for (final item in localItems) {
        final normalizedId = ProductIdCodec.normalizeUiProductId(item.productId);
        try {
          await _cartRepository.addProduct(
            normalizedId,
            quantity: item.quantity,
          );
        } catch (error) {
          lastSyncError = error;
          debugPrint(
            '[cart] checkout sync failed productId=$normalizedId: $error',
          );
        }
      }
      serverItems = await _fetchServerCartOrRetry();
      if (serverItems.isNotEmpty) {
        state = serverItems;
      } else if (lastSyncError != null) {
        throw lastSyncError;
      }
    }

    return serverItems;
  }

  bool _localHasMissingServerLines(
    List<CartLineItem> localItems,
    List<CartLineItem> serverItems,
  ) {
    if (localItems.isEmpty) return false;
    final serverIds = {
      for (final item in serverItems)
        ProductIdCodec.normalizeUiProductId(item.productId),
    };
    for (final item in localItems) {
      final id = ProductIdCodec.normalizeUiProductId(item.productId);
      if (!serverIds.contains(id)) return true;
    }
    return false;
  }

  Future<List<CartLineItem>> _fetchServerCartOrRetry() async {
    try {
      return await _cartRepository.fetchItems();
    } catch (error) {
      debugPrint('[cart] fetchItems failed, retrying after auth init: $error');
      await client.auth.initialize();
      return _cartRepository.fetchItems();
    }
  }

  Future<void> _mergeLocalCartOnSignIn() async {
    if (!client.auth.isAuthenticated) return;

    final localItems = [...state];
    await _refreshFromServer();
    if (localItems.isEmpty) return;

    for (final item in localItems) {
      try {
        await _cartRepository.addProduct(
          item.productId,
          quantity: item.quantity,
        );
      } catch (_) {
        // Skip catalog previews or invalid product ids.
      }
    }
    await _refreshFromServer();
  }

  /// Returns an error message when the server cart could not be updated.
  Future<String?> addProduct(String productId, {int quantity = 1}) async {
    final normalizedId = ProductIdCodec.normalizeUiProductId(productId);
    var user = ref.read(currentUserProvider).value;

    // Ensure vendorId is loaded so own-shop purchase policy can apply.
    if (user != null &&
        user.isVendorAccount &&
        !user.hasVendorShop) {
      await ref.read(currentUserProvider.notifier).refresh();
      user = ref.read(currentUserProvider).value;
    }

    await ref
        .read(catalogIndexProvider.notifier)
        .ensureProducts([normalizedId]);
    final catalog = ref.read(catalogIndexProvider).value;
    final product = catalog?[normalizedId] ?? catalog?[productId];
    if (product == null) {
      return 'This product is not available. Refresh and try again.';
    }
    if (!VendorPurchasePolicy.canPurchase(
      user: user,
      productVendorId: product.vendorId,
    )) {
      return VendorPurchasePolicy.addToCartBlockedMessage;
    }

    if (!client.auth.isAuthenticated) {
      _applyLocalAdd(normalizedId, quantity: quantity);
      return 'Sign in to save items to your cart for checkout.';
    }

    // Optimistic update so badge/count and Cart page feel immediate (like wishlist).
    _applyLocalAdd(normalizedId, quantity: quantity);
    try {
      await _cartRepository.addProduct(normalizedId, quantity: quantity);
      await _refreshFromServer();
      return null;
    } catch (error) {
      await _refreshFromServer();
      return CartApiErrors.message(error);
    }
  }

  Future<String?> increment(String productId) async {
    final index = state.indexWhere((e) => e.productId == productId);
    if (index < 0) return null;

    final nextQuantity = state[index].quantity + 1;
    if (!client.auth.isAuthenticated) {
      _setLocalQuantity(productId, nextQuantity);
      return null;
    }

    try {
      await _cartRepository.setQuantity(productId, nextQuantity);
      await _refreshFromServer();
      return null;
    } catch (error) {
      await _refreshFromServer();
      return CartApiErrors.message(error);
    }
  }

  Future<String?> decrement(String productId) async {
    final index = state.indexWhere((e) => e.productId == productId);
    if (index < 0) return null;

    if (state[index].quantity > 1) {
      return _decrementQuantity(productId, state[index].quantity - 1);
    }

    return remove(productId);
  }

  Future<String?> _decrementQuantity(String productId, int nextQuantity) async {
    if (!client.auth.isAuthenticated) {
      _setLocalQuantity(productId, nextQuantity);
      return null;
    }

    try {
      await _cartRepository.setQuantity(productId, nextQuantity);
      await _refreshFromServer();
      return null;
    } catch (error) {
      await _refreshFromServer();
      return CartApiErrors.message(error);
    }
  }

  Future<String?> remove(String productId) async {
    if (!client.auth.isAuthenticated) {
      state = state.where((e) => e.productId != productId).toList();
      return null;
    }

    try {
      await _cartRepository.removeProduct(productId);
      await _refreshFromServer();
      return null;
    } catch (error) {
      await _refreshFromServer();
      return CartApiErrors.message(error);
    }
  }

  Future<String> checkout({PaymentMethod paymentMethod = PaymentMethod.cashOnDelivery}) async {
    if (!client.auth.isAuthenticated) {
      return 'Sign in to checkout';
    }

    try {
      final serverItems = await _cartRepository.fetchItems();
      if (serverItems.isEmpty) {
        return CartApiErrors.message(
          StateError('CART_EMPTY'),
          fallback:
              'Your cart is empty on the server. Sign in, add products from Browse, then try again.',
        );
      }

      state = serverItems;

      final user = ref.read(currentUserProvider).value;
      final catalog = ref.read(catalogIndexProvider).value ?? {};
      for (final item in serverItems) {
        final product = catalog[item.productId];
        if (!VendorPurchasePolicy.canPurchase(
          user: user,
          productVendorId: product?.vendorId,
        )) {
          return VendorPurchasePolicy.checkoutBlockedMessage;
        }
      }

      final profile = await client.user.getCurrentUser();
      final savedAddress = profile?.address?.trim();
      if (savedAddress == null || savedAddress.isEmpty) {
        return CartStrings.deliveryAddressRequired;
      }

      await _cartRepository.checkout(
        savedAddress,
        paymentMethod: paymentMethod,
      );

      state = const [];
      ref.invalidate(profileDashboardProvider);
      ref.invalidate(ordersProvider);
      return CartStrings.orderPlacedSuccess;
    } catch (error) {
      await _refreshFromServer();
      return CartApiErrors.message(
        error,
        fallback: 'Checkout failed. Add items while signed in and try again.',
      );
    }
  }

  void _applyLocalAdd(String productId, {int quantity = 1}) {
    final items = [...state];
    final index = items.indexWhere((e) => e.productId == productId);
    if (index >= 0) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + quantity,
      );
    } else {
      items.add(CartLineItem(productId: productId, quantity: quantity));
    }
    state = items;
  }

  void _setLocalQuantity(String productId, int quantity) {
    state = [
      for (final item in state)
        if (item.productId == productId)
          item.copyWith(quantity: quantity)
        else
          item,
    ];
  }
}

@riverpod
int cartItemCount(Ref ref) {
  final items = ref.watch(cartProvider);
  return items.fold<int>(0, (sum, item) => sum + item.quantity);
}

@riverpod
class CartEditMode extends _$CartEditMode {
  @override
  bool build() => false;

  void toggle() => state = !state;
}
