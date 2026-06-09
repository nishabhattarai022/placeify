// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VendorShopOrders)
final vendorShopOrdersProvider = VendorShopOrdersProvider._();

final class VendorShopOrdersProvider
    extends $AsyncNotifierProvider<VendorShopOrders, List<VendorShopOrder>> {
  VendorShopOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorShopOrdersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorShopOrdersHash();

  @$internal
  @override
  VendorShopOrders create() => VendorShopOrders();
}

String _$vendorShopOrdersHash() => r'57afe425e0d1a1aadb30893267ac5992eb9f63a9';

abstract class _$VendorShopOrders
    extends $AsyncNotifier<List<VendorShopOrder>> {
  FutureOr<List<VendorShopOrder>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<VendorShopOrder>>, List<VendorShopOrder>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<VendorShopOrder>>,
                List<VendorShopOrder>
              >,
              AsyncValue<List<VendorShopOrder>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(vendorShopOrderDetail)
final vendorShopOrderDetailProvider = VendorShopOrderDetailFamily._();

final class VendorShopOrderDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<VendorShopOrder>,
          VendorShopOrder,
          FutureOr<VendorShopOrder>
        >
    with $FutureModifier<VendorShopOrder>, $FutureProvider<VendorShopOrder> {
  VendorShopOrderDetailProvider._({
    required VendorShopOrderDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'vendorShopOrderDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$vendorShopOrderDetailHash();

  @override
  String toString() {
    return r'vendorShopOrderDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<VendorShopOrder> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VendorShopOrder> create(Ref ref) {
    final argument = this.argument as int;
    return vendorShopOrderDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VendorShopOrderDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$vendorShopOrderDetailHash() =>
    r'ad15317f9377d9a7999508e93991bf805155d624';

final class VendorShopOrderDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<VendorShopOrder>, int> {
  VendorShopOrderDetailFamily._()
    : super(
        retry: null,
        name: r'vendorShopOrderDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VendorShopOrderDetailProvider call(int orderId) =>
      VendorShopOrderDetailProvider._(argument: orderId, from: this);

  @override
  String toString() => r'vendorShopOrderDetailProvider';
}
