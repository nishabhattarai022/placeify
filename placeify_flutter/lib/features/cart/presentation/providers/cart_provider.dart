import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/config/placeify_server_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/catalog_provider.dart';
import '../../../home/presentation/providers/category_provider.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../../../profile/presentation/providers/profile_dashboard_provider.dart';
import '../../data/cart_display_config.dart';
import '../../data/serverpod_cart_repository.dart';
import '../../domain/cart_line_item.dart';

part 'cart_provider.g.dart';

class CartTotals {
  const CartTotals({
    required this.subtotal,
    required this.discount,
    required this.total,
  });

  final double subtotal;
  final double discount;
  final double total;
}

final _cartRepository = ServerpodCartRepository();

@Riverpod(keepAlive: true)
class Cart extends _$Cart {
  @override
  List<CartLineItem> build() {
    ref.watch(catalogIndexProvider);
    ref.listen(currentUserProvider, (previous, next) {
      next.whenData((user) {
        if (user != null) {
          _refreshFromServer();
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
      state = await _cartRepository.fetchItems();
    } catch (_) {}
  }

  Future<void> refresh() => _refreshFromServer();

  Future<void> addProduct(String productId, {int quantity = 1}) async {
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

    if (!client.auth.isAuthenticated) return;
    try {
      await _cartRepository.addProduct(productId, quantity: quantity);
      await _refreshFromServer();
    } catch (_) {
      await _refreshFromServer();
    }
  }

  Future<void> increment(String productId) async {
    final index = state.indexWhere((e) => e.productId == productId);
    if (index < 0) return;

    final nextQuantity = state[index].quantity + 1;
    state = [
      for (final item in state)
        if (item.productId == productId)
          item.copyWith(quantity: nextQuantity)
        else
          item,
    ];

    if (!client.auth.isAuthenticated) return;
    try {
      await _cartRepository.setQuantity(productId, nextQuantity);
    } catch (_) {}
  }

  Future<void> decrement(String productId) async {
    final index = state.indexWhere((e) => e.productId == productId);
    if (index < 0) return;

    if (state[index].quantity > 1) {
      final nextQuantity = state[index].quantity - 1;
      state = [
        for (final line in state)
          if (line.productId == productId)
            line.copyWith(quantity: nextQuantity)
          else
            line,
      ];
      if (!client.auth.isAuthenticated) return;
      try {
        await _cartRepository.setQuantity(productId, nextQuantity);
      } catch (_) {}
      return;
    }

    await remove(productId);
  }

  Future<void> remove(String productId) async {
    state = state.where((e) => e.productId != productId).toList();
    if (!client.auth.isAuthenticated) return;
    try {
      await _cartRepository.removeProduct(productId);
    } catch (_) {}
  }

  Future<String> checkout() async {
    if (!client.auth.isAuthenticated) {
      return 'Sign in to checkout';
    }

    try {
      final profile = await client.user.getCurrentUser();
      final savedAddress = profile?.address?.trim();
      final shippingAddress = savedAddress != null && savedAddress.isNotEmpty
          ? savedAddress
          : 'Kathmandu, Nepal';

      final result = await _cartRepository.checkout(shippingAddress);
      state = const [];
      ref.invalidate(profileOrdersProvider);
      ref.invalidate(profileDashboardProvider);
      ref.invalidate(ordersProvider);
      return 'Order #${result.order.id} placed successfully';
    } catch (_) {
      return 'Checkout failed. Add items and try again.';
    }
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

@riverpod
CartTotals cartTotals(Ref ref) {
  final items = ref.watch(cartProvider);

  var subtotal = 0.0;
  for (final item in items) {
    final product = ref.watch(productByIdProvider(item.productId));
    if (product == null) continue;
    final unit = CartDisplayConfig.priceFor(product.id, product.price);
    subtotal += unit * item.quantity;
  }

  final discount = _roundMoney(subtotal * CartDisplayConfig.discountRate);
  final total = _roundMoney(subtotal - discount);

  return CartTotals(
    subtotal: _roundMoney(subtotal),
    discount: discount,
    total: total,
  );
}

double _roundMoney(double value) {
  return (value * 100).roundToDouble() / 100;
}
