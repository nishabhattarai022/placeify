// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_product_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VendorProductForm)
final vendorProductFormProvider = VendorProductFormProvider._();

final class VendorProductFormProvider
    extends $NotifierProvider<VendorProductForm, VendorProductFormState> {
  VendorProductFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorProductFormProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorProductFormHash();

  @$internal
  @override
  VendorProductForm create() => VendorProductForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VendorProductFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VendorProductFormState>(value),
    );
  }
}

String _$vendorProductFormHash() => r'cd884fe14471c5a7c0518204ac07969a35c2f1d5';

abstract class _$VendorProductForm extends $Notifier<VendorProductFormState> {
  VendorProductFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<VendorProductFormState, VendorProductFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VendorProductFormState, VendorProductFormState>,
              VendorProductFormState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
