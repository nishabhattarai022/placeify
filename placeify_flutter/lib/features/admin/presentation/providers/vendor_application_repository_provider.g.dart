// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_application_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(vendorApplicationRepository)
final vendorApplicationRepositoryProvider =
    VendorApplicationRepositoryProvider._();

final class VendorApplicationRepositoryProvider
    extends
        $FunctionalProvider<
          VendorApplicationRepository,
          VendorApplicationRepository,
          VendorApplicationRepository
        >
    with $Provider<VendorApplicationRepository> {
  VendorApplicationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorApplicationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorApplicationRepositoryHash();

  @$internal
  @override
  $ProviderElement<VendorApplicationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VendorApplicationRepository create(Ref ref) {
    return vendorApplicationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VendorApplicationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VendorApplicationRepository>(value),
    );
  }
}

String _$vendorApplicationRepositoryHash() =>
    r'3d34b6ad0cedefc2bd6afd81446246b8c9ae4148';
