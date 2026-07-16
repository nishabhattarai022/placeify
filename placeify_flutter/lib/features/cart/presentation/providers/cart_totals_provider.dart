import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../home/presentation/providers/catalog_provider.dart';
import '../../data/cart_product_resolver.dart';
import '../../domain/cart_totals.dart';
import '../../domain/cart_totals_calculator.dart';
import 'cart_provider.dart';

part 'cart_totals_provider.g.dart';

/// Cart subtotal/total — depends only on cart items + catalog prices.
@riverpod
CartTotals cartTotals(Ref ref) {
  final items = ref.watch(cartProvider);
  ref.watch(catalogIndexProvider);

  return CartTotalsCalculator.compute(
    items,
    (productId) => CartProductResolver.resolveSync(ref, productId),
  );
}
