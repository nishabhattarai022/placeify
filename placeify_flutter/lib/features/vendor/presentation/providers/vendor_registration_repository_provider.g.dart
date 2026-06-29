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
          AsyncValue<VendorRegistrationRepository>,
          VendorRegistrationRepository,
          FutureOr<VendorRegistrationRepository>
        >
    with
        $FutureModifier<VendorRegistrationRepository>,
        $FutureProvider<VendorRegistrationRepository> {
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
  $FutureProviderElement<VendorRegistrationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VendorRegistrationRepository> create(Ref ref) {
    return vendorRegistrationRepository(ref);
  }
}

String _$vendorRegistrationRepositoryHash() =>
    r'b28a4d30f6a8238331bcd89a633d04bc86493af7';
