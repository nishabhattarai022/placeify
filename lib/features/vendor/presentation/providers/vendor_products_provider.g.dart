// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_products_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$vendorProductsHash() => r'29642a3793f6d8b6ed4b305b9f7ba70aaf113efa';

abstract class _$VendorProducts extends $AsyncNotifier<List<VendorProduct>> {
  FutureOr<List<VendorProduct>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<VendorProduct>>, List<VendorProduct>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<VendorProduct>>, List<VendorProduct>>,
        AsyncValue<List<VendorProduct>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
