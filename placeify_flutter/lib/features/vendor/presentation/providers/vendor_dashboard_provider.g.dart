// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(vendorRepository)
final vendorRepositoryProvider = VendorRepositoryProvider._();

final class VendorRepositoryProvider
    extends
        $FunctionalProvider<
          VendorRepository,
          VendorRepository,
          VendorRepository
        >
    with $Provider<VendorRepository> {
  VendorRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorRepositoryHash();

  @$internal
  @override
  $ProviderElement<VendorRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VendorRepository create(Ref ref) {
    return vendorRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VendorRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VendorRepository>(value),
    );
  }
}

String _$vendorRepositoryHash() => r'3acdf015012ffce0c9a58b0c8fe72d042fa119f4';

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
    r'8ef8903e1a615813c33e83edc03300e9c3f691bb';

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
