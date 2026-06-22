import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:placeify_client/placeify_client.dart' hide Order;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/config/placeify_server_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/catalog_provider.dart';
import '../../../home/presentation/providers/category_provider.dart';
import '../../data/cart_api_errors.dart';
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
      await ref
          .read(catalogIndexProvider.notifier)
          .ensureProducts(state.map((item) => item.productId));
    } catch (_) {
      // Keep last known server snapshot on transient refresh failures.
    }
  }

  Future<void> refresh() => _refreshFromServer();

  /// Returns an error message when the server cart could not be updated.
  Future<String?> addProduct(String productId, {int quantity = 1}) async {
    if (!client.auth.isAuthenticated) {
      _applyLocalAdd(productId, quantity: quantity);
      return 'Sign in to save items to your cart for checkout.';
    }

    try {
      await _cartRepository.addProduct(productId, quantity: quantity);
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

  Future<String> checkout() async {
    if (!client.auth.isAuthenticated) {
      return 'Sign in to checkout';
    }

    try {
      final serverItems = await _cartRepository.fetchItems();
      if (serverItems.isEmpty) {
        state = const [];
        return CartApiErrors.message(
          StateError('CART_EMPTY'),
          fallback:
              'Your cart is empty on the server. Sign in, add products from Browse, then try again.',
        );
      }

      state = serverItems;

      final profile = await client.user.getCurrentUser();
      final savedAddress = profile?.address?.trim();
      final shippingAddress = savedAddress != null && savedAddress.isNotEmpty
          ? savedAddress
          : 'Kathmandu, Nepal';

      final result = await _cartRepository.checkout(
        shippingAddress,
        paymentMethod: PaymentMethod.mockOnline,
      );

      // Dev/mock flow: complete online payment immediately so vendor dashboard
      // shows a confirmed order and the consumer UI can display paid status.
      if (result.order.id != null) {
        await client.user.completePayment(result.order.id!);
      }

      state = const [];
      return 'Order #${result.order.id} placed successfully';
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

@riverpod
CartTotals cartTotals(Ref ref) {
  final items = ref.watch(cartProvider);

  var subtotal = 0.0;
  for (final item in items) {
    final product = ref.watch(productByIdProvider(item.productId));
    if (product == null) continue;
    subtotal += product.price * item.quantity;
  }

  return CartTotals(
    subtotal: _roundMoney(subtotal),
    discount: 0,
    total: _roundMoney(subtotal),
  );
}

double _roundMoney(double value) {
  return (value * 100).roundToDouble() / 100;
}
