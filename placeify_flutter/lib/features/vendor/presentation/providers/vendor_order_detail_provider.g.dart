// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_order_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(vendorOrderDetail)
final vendorOrderDetailProvider = VendorOrderDetailFamily._();

final class VendorOrderDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<VendorOrderDetail?>,
          VendorOrderDetail?,
          FutureOr<VendorOrderDetail?>
        >
    with
        $FutureModifier<VendorOrderDetail?>,
        $FutureProvider<VendorOrderDetail?> {
  VendorOrderDetailProvider._({
    required VendorOrderDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'vendorOrderDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$vendorOrderDetailHash();

  @override
  String toString() {
    return r'vendorOrderDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<VendorOrderDetail?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VendorOrderDetail?> create(Ref ref) {
    final argument = this.argument as String;
    return vendorOrderDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VendorOrderDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$vendorOrderDetailHash() => r'b7773c6f92e94521ddfccd12bc0cd393f91bb443';

final class VendorOrderDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<VendorOrderDetail?>, String> {
  VendorOrderDetailFamily._()
    : super(
        retry: null,
        name: r'vendorOrderDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VendorOrderDetailProvider call(String orderId) =>
      VendorOrderDetailProvider._(argument: orderId, from: this);

  @override
  String toString() => r'vendorOrderDetailProvider';
}
