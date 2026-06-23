// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_payments_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(vendorPaymentRepository)
final vendorPaymentRepositoryProvider = VendorPaymentRepositoryProvider._();

final class VendorPaymentRepositoryProvider
    extends
        $FunctionalProvider<
          VendorPaymentRepository,
          VendorPaymentRepository,
          VendorPaymentRepository
        >
    with $Provider<VendorPaymentRepository> {
  VendorPaymentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorPaymentRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorPaymentRepositoryHash();

  @$internal
  @override
  $ProviderElement<VendorPaymentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VendorPaymentRepository create(Ref ref) {
    return vendorPaymentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VendorPaymentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VendorPaymentRepository>(value),
    );
  }
}

String _$vendorPaymentRepositoryHash() =>
    r'664c57bb8614f1222c63bf401474244f2a092169';

@ProviderFor(VendorPayments)
final vendorPaymentsProvider = VendorPaymentsProvider._();

final class VendorPaymentsProvider
    extends $AsyncNotifierProvider<VendorPayments, VendorPaymentsData> {
  VendorPaymentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorPaymentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorPaymentsHash();

  @$internal
  @override
  VendorPayments create() => VendorPayments();
}

String _$vendorPaymentsHash() => r'6b4ae514516ab58a707fcdaeba29635a3c617bd8';

abstract class _$VendorPayments extends $AsyncNotifier<VendorPaymentsData> {
  FutureOr<VendorPaymentsData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<VendorPaymentsData>, VendorPaymentsData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<VendorPaymentsData>, VendorPaymentsData>,
              AsyncValue<VendorPaymentsData>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(orderPaymentAuditTrail)
final orderPaymentAuditTrailProvider = OrderPaymentAuditTrailFamily._();

final class OrderPaymentAuditTrailProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PaymentUpdate>>,
          List<PaymentUpdate>,
          FutureOr<List<PaymentUpdate>>
        >
    with
        $FutureModifier<List<PaymentUpdate>>,
        $FutureProvider<List<PaymentUpdate>> {
  OrderPaymentAuditTrailProvider._({
    required OrderPaymentAuditTrailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'orderPaymentAuditTrailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderPaymentAuditTrailHash();

  @override
  String toString() {
    return r'orderPaymentAuditTrailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<PaymentUpdate>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PaymentUpdate>> create(Ref ref) {
    final argument = this.argument as String;
    return orderPaymentAuditTrail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderPaymentAuditTrailProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderPaymentAuditTrailHash() =>
    r'453165b2713032fb2c7ddf0ca4a4a394350c8690';

final class OrderPaymentAuditTrailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<PaymentUpdate>>, String> {
  OrderPaymentAuditTrailFamily._()
    : super(
        retry: null,
        name: r'orderPaymentAuditTrailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OrderPaymentAuditTrailProvider call(String orderId) =>
      OrderPaymentAuditTrailProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderPaymentAuditTrailProvider';
}
