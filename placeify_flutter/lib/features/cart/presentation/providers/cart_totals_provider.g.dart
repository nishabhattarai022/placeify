// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_totals_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Cart subtotal/total — depends only on cart items + catalog prices.

@ProviderFor(cartTotals)
final cartTotalsProvider = CartTotalsProvider._();

/// Cart subtotal/total — depends only on cart items + catalog prices.

final class CartTotalsProvider
    extends $FunctionalProvider<CartTotals, CartTotals, CartTotals>
    with $Provider<CartTotals> {
  /// Cart subtotal/total — depends only on cart items + catalog prices.
  CartTotalsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartTotalsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartTotalsHash();

  @$internal
  @override
  $ProviderElement<CartTotals> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CartTotals create(Ref ref) {
    return cartTotals(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CartTotals value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CartTotals>(value),
    );
  }
}

String _$cartTotalsHash() => r'c5650608c06a2c327dc6b8b2e8228d10b9745473';
