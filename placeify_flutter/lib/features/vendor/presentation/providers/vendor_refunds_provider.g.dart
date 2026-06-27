// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_refunds_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(vendorRefundRepository)
final vendorRefundRepositoryProvider = VendorRefundRepositoryProvider._();

final class VendorRefundRepositoryProvider
    extends
        $FunctionalProvider<
          ServerpodVendorRefundRepository,
          ServerpodVendorRefundRepository,
          ServerpodVendorRefundRepository
        >
    with $Provider<ServerpodVendorRefundRepository> {
  VendorRefundRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorRefundRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorRefundRepositoryHash();

  @$internal
  @override
  $ProviderElement<ServerpodVendorRefundRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServerpodVendorRefundRepository create(Ref ref) {
    return vendorRefundRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerpodVendorRefundRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerpodVendorRefundRepository>(
        value,
      ),
    );
  }
}

String _$vendorRefundRepositoryHash() =>
    r'2a8c035248bde0b4bf75a12e0dec493773aa8c99';

@ProviderFor(VendorPendingRefunds)
final vendorPendingRefundsProvider = VendorPendingRefundsProvider._();

final class VendorPendingRefundsProvider
    extends
        $AsyncNotifierProvider<
          VendorPendingRefunds,
          List<VendorPendingRefund>
        > {
  VendorPendingRefundsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorPendingRefundsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorPendingRefundsHash();

  @$internal
  @override
  VendorPendingRefunds create() => VendorPendingRefunds();
}

String _$vendorPendingRefundsHash() =>
    r'bda3453bed5dba2b7cb22dac23ace7415f0c0b80';

abstract class _$VendorPendingRefunds
    extends $AsyncNotifier<List<VendorPendingRefund>> {
  FutureOr<List<VendorPendingRefund>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<VendorPendingRefund>>,
              List<VendorPendingRefund>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<VendorPendingRefund>>,
                List<VendorPendingRefund>
              >,
              AsyncValue<List<VendorPendingRefund>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
