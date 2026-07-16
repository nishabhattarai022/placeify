// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Places an order from checkout — separate from [Cart] to avoid provider cycles.
/// keepAlive: confirm() awaits network work; autoDispose would dispose this
/// notifier between awaits when nothing watches it (one-shot ref.read).

@ProviderFor(CheckoutOrderAction)
final checkoutOrderActionProvider = CheckoutOrderActionProvider._();

/// Places an order from checkout — separate from [Cart] to avoid provider cycles.
/// keepAlive: confirm() awaits network work; autoDispose would dispose this
/// notifier between awaits when nothing watches it (one-shot ref.read).
final class CheckoutOrderActionProvider
    extends $NotifierProvider<CheckoutOrderAction, bool> {
  /// Places an order from checkout — separate from [Cart] to avoid provider cycles.
  /// keepAlive: confirm() awaits network work; autoDispose would dispose this
  /// notifier between awaits when nothing watches it (one-shot ref.read).
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
    r'9ede8b57eb860fdf2e8f5a4fc6e771e2b566c3c4';

/// Places an order from checkout — separate from [Cart] to avoid provider cycles.
/// keepAlive: confirm() awaits network work; autoDispose would dispose this
/// notifier between awaits when nothing watches it (one-shot ref.read).

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
