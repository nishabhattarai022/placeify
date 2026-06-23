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
          AsyncValue<VendorApplicationRepository>,
          VendorApplicationRepository,
          FutureOr<VendorApplicationRepository>
        >
    with
        $FutureModifier<VendorApplicationRepository>,
        $FutureProvider<VendorApplicationRepository> {
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
  $FutureProviderElement<VendorApplicationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VendorApplicationRepository> create(Ref ref) {
    return vendorApplicationRepository(ref);
  }
}

String _$vendorApplicationRepositoryHash() =>
    r'0f5e438d242f5e82a2ceb62702f56d5a5fef7287';
