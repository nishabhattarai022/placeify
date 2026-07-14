// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_products_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VendorProductsSaving)
final vendorProductsSavingProvider = VendorProductsSavingProvider._();

final class VendorProductsSavingProvider
    extends $NotifierProvider<VendorProductsSaving, bool> {
  VendorProductsSavingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorProductsSavingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorProductsSavingHash();

  @$internal
  @override
  VendorProductsSaving create() => VendorProductsSaving();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$vendorProductsSavingHash() =>
    r'1d977cbe5cc4e623cd072effb82103f07ddebfc1';

abstract class _$VendorProductsSaving extends $Notifier<bool> {
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

@ProviderFor(VendorProducts)
final vendorProductsProvider = VendorProductsProvider._();

final class VendorProductsProvider
    extends $AsyncNotifierProvider<VendorProducts, List<VendorProduct>> {
  VendorProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorProductsHash();

  @$internal
  @override
  VendorProducts create() => VendorProducts();
}

String _$vendorProductsHash() => r'6decb7b68c00e6eed046fa058a785663ff6b3072';

abstract class _$VendorProducts extends $AsyncNotifier<List<VendorProduct>> {
  FutureOr<List<VendorProduct>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<VendorProduct>>, List<VendorProduct>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<VendorProduct>>, List<VendorProduct>>,
              AsyncValue<List<VendorProduct>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
