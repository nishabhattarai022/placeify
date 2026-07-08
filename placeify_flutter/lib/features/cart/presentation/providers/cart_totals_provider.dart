import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../home/presentation/providers/catalog_provider.dart';
import '../../../shops/data/mock_consumer_shop_repository.dart';
import '../../domain/cart_totals.dart';
import '../../domain/cart_totals_calculator.dart';
import 'cart_provider.dart';

part 'cart_totals_provider.g.dart';

/// Cart subtotal/total — depends only on cart items + catalog prices.
@riverpod
CartTotals cartTotals(Ref ref) {
  final items = ref.watch(cartProvider);
  final catalog = ref.watch(catalogIndexProvider).value ?? {};

  return CartTotalsCalculator.compute(
    items,
    (productId) =>
        catalog[productId] ??
        MockConsumerShopRepository.productByIdSync(productId),
  );
}
