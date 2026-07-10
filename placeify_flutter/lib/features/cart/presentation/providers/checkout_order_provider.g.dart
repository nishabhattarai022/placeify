// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Places an order from checkout — separate from [Cart] to avoid provider cycles.

@ProviderFor(CheckoutOrderAction)
final checkoutOrderActionProvider = CheckoutOrderActionProvider._();

/// Places an order from checkout — separate from [Cart] to avoid provider cycles.
final class CheckoutOrderActionProvider
    extends $NotifierProvider<CheckoutOrderAction, bool> {
  /// Places an order from checkout — separate from [Cart] to avoid provider cycles.
  CheckoutOrderActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutOrderActionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutOrderActionHash();

  @$internal
  @override
  CheckoutOrderAction create() => CheckoutOrderAction();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$checkoutOrderActionHash() =>
    r'b55efadc5c1443b0fc35245bf52cb450598868af';

/// Places an order from checkout — separate from [Cart] to avoid provider cycles.

abstract class _$CheckoutOrderAction extends $Notifier<bool> {
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
