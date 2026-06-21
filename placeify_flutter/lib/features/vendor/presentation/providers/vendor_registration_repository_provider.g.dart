// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_registration_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(vendorRegistrationRepository)
final vendorRegistrationRepositoryProvider =
    VendorRegistrationRepositoryProvider._();

final class VendorRegistrationRepositoryProvider
    extends
        $FunctionalProvider<
          VendorRegistrationRepository,
          VendorRegistrationRepository,
          VendorRegistrationRepository
        >
    with $Provider<VendorRegistrationRepository> {
  VendorRegistrationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorRegistrationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorRegistrationRepositoryHash();

  @$internal
  @override
  $ProviderElement<VendorRegistrationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VendorRegistrationRepository create(Ref ref) {
    return vendorRegistrationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VendorRegistrationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VendorRegistrationRepository>(value),
    );
  }
}

String _$vendorRegistrationRepositoryHash() =>
    r'445a68bc9bd30e062d5371e774e531db3bf2a621';
