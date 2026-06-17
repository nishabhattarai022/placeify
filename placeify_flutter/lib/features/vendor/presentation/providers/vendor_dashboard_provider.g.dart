// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(vendorCommerceRepository)
final vendorCommerceRepositoryProvider = VendorCommerceRepositoryProvider._();

final class VendorCommerceRepositoryProvider
    extends
        $FunctionalProvider<
          VendorCommerceRepository,
          VendorCommerceRepository,
          VendorCommerceRepository
        >
    with $Provider<VendorCommerceRepository> {
  VendorCommerceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorCommerceRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorCommerceRepositoryHash();

  @$internal
  @override
  $ProviderElement<VendorCommerceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VendorCommerceRepository create(Ref ref) {
    return vendorCommerceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VendorCommerceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VendorCommerceRepository>(value),
    );
  }
}

String _$vendorCommerceRepositoryHash() =>
    r'27674bffe6587852421ccff8b751f3397b817261';

@ProviderFor(VendorDashboardState)
final vendorDashboardStateProvider = VendorDashboardStateProvider._();

final class VendorDashboardStateProvider
    extends $AsyncNotifierProvider<VendorDashboardState, VendorDashboard?> {
  VendorDashboardStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorDashboardStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorDashboardStateHash();

  @$internal
  @override
  VendorDashboardState create() => VendorDashboardState();
}

String _$vendorDashboardStateHash() =>
    r'a3c87e01ef0b47a9a7ab88b8a5b4fd309485ead3';

abstract class _$VendorDashboardState extends $AsyncNotifier<VendorDashboard?> {
  FutureOr<VendorDashboard?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<VendorDashboard?>, VendorDashboard?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<VendorDashboard?>, VendorDashboard?>,
              AsyncValue<VendorDashboard?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
