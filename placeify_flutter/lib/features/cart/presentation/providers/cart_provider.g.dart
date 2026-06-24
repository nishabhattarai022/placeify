// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Cart)
final cartProvider = CartProvider._();

final class CartProvider extends $NotifierProvider<Cart, List<CartLineItem>> {
  CartProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartHash();

  @$internal
  @override
  Cart create() => Cart();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CartLineItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CartLineItem>>(value),
    );
  }
}

String _$cartHash() => r'98a92a8815dc159a75e2af857a598ac2d71ac3b2';

abstract class _$Cart extends $Notifier<List<CartLineItem>> {
  List<CartLineItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<CartLineItem>, List<CartLineItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<CartLineItem>, List<CartLineItem>>,
              List<CartLineItem>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(cartItemCount)
final cartItemCountProvider = CartItemCountProvider._();

final class CartItemCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  CartItemCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartItemCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartItemCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return cartItemCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$cartItemCountHash() => r'83462867f323f725f57c14b4f38bd50b2e6d8faf';

@ProviderFor(CartEditMode)
final cartEditModeProvider = CartEditModeProvider._();

final class CartEditModeProvider extends $NotifierProvider<CartEditMode, bool> {
  CartEditModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartEditModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartEditModeHash();

  @$internal
  @override
  CartEditMode create() => CartEditMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$cartEditModeHash() => r'3acc30e0f5bb1cacbe6c0cf762e2f386adafba80';

abstract class _$CartEditMode extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(cartTotals)
final cartTotalsProvider = CartTotalsProvider._();

final class CartTotalsProvider
    extends $FunctionalProvider<CartTotals, CartTotals, CartTotals>
    with $Provider<CartTotals> {
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

String _$cartTotalsHash() => r'53b1f86e4a49156e4e37ba5f8fe694ef3a5220e6';
