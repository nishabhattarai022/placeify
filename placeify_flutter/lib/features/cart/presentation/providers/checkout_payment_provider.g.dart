// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_payment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Selected payment method on the checkout screen (independent of cart totals).

@ProviderFor(SelectedPaymentMethod)
final selectedPaymentMethodProvider = SelectedPaymentMethodProvider._();

/// Selected payment method on the checkout screen (independent of cart totals).
final class SelectedPaymentMethodProvider
    extends $NotifierProvider<SelectedPaymentMethod, CheckoutPaymentOption?> {
  /// Selected payment method on the checkout screen (independent of cart totals).
  SelectedPaymentMethodProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedPaymentMethodProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedPaymentMethodHash();

  @$internal
  @override
  SelectedPaymentMethod create() => SelectedPaymentMethod();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CheckoutPaymentOption? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CheckoutPaymentOption?>(value),
    );
  }
}

String _$selectedPaymentMethodHash() =>
    r'90d7713855adcdf9683f06a0d5e4bc59ec7c11a1';

/// Selected payment method on the checkout screen (independent of cart totals).

abstract class _$SelectedPaymentMethod
    extends $Notifier<CheckoutPaymentOption?> {
  CheckoutPaymentOption? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<CheckoutPaymentOption?, CheckoutPaymentOption?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CheckoutPaymentOption?, CheckoutPaymentOption?>,
              CheckoutPaymentOption?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
