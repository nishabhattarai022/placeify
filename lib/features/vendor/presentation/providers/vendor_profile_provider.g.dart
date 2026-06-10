// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(vendorRepository)
final vendorRepositoryProvider = VendorRepositoryProvider._();

final class VendorRepositoryProvider extends $FunctionalProvider<
    VendorRepository,
    VendorRepository,
    VendorRepository> with $Provider<VendorRepository> {
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
  $ProviderElement<VendorRepository> $createElement(
          $ProviderPointer pointer) =>
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

String _$vendorRepositoryHash() => r'b2c3d4e5f6789012345678vendorRepository';

@ProviderFor(VendorProfile)
final vendorProfileProvider = VendorProfileProvider._();

final class VendorProfileProvider extends $AsyncNotifierProvider<VendorProfile,
    models.VendorProfile?> {
  VendorProfileProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'vendorProfileProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$vendorProfileHash();

  @$internal
  @override
  VendorProfile create() => VendorProfile();
}

String _$vendorProfileHash() => r'c3d4e5f6789012345678vendorProfile';

abstract class _$VendorProfile extends $AsyncNotifier<models.VendorProfile?> {
  FutureOr<models.VendorProfile?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<models.VendorProfile?>,
        models.VendorProfile?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<models.VendorProfile?>, models.VendorProfile?>,
        AsyncValue<models.VendorProfile?>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
