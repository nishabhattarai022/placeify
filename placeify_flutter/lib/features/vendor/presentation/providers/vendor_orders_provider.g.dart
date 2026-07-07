// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VendorOrders)
final vendorOrdersProvider = VendorOrdersProvider._();

final class VendorOrdersProvider
    extends $AsyncNotifierProvider<VendorOrders, List<VendorOrder>> {
  VendorOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorOrdersHash();

  @$internal
  @override
  VendorOrders create() => VendorOrders();
}

String _$vendorOrdersHash() => r'4bf43214606077a5490b63056c52583a364f8531';

abstract class _$VendorOrders extends $AsyncNotifier<List<VendorOrder>> {
  FutureOr<List<VendorOrder>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<VendorOrder>>, List<VendorOrder>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<VendorOrder>>, List<VendorOrder>>,
              AsyncValue<List<VendorOrder>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
