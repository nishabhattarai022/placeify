import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../home/presentation/providers/category_provider.dart';
import '../../data/cart_display_config.dart';
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

@riverpod
class Cart extends _$Cart {
  @override
  List<CartLineItem> build() => const [
        CartLineItem(productId: 'p4', quantity: 1),
        CartLineItem(productId: 'p5', quantity: 1),
        CartLineItem(productId: 'p6', quantity: 1),
        CartLineItem(productId: 'p1', quantity: 1),
      ];

  void addProduct(String productId, {int quantity = 1}) {
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

  void increment(String productId) {
    state = [
      for (final item in state)
        if (item.productId == productId)
          item.copyWith(quantity: item.quantity + 1)
        else
          item,
    ];
  }

  void decrement(String productId) {
    final index = state.indexWhere((e) => e.productId == productId);
    if (index < 0) return;

    if (state[index].quantity > 1) {
      state = [
        for (final line in state)
          if (line.productId == productId)
            line.copyWith(quantity: line.quantity - 1)
          else
            line,
      ];
    } else {
      remove(productId);
    }
  }

  void remove(String productId) {
    state = state.where((e) => e.productId != productId).toList();
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
