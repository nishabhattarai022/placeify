// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_document_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(vendorDocumentRepository)
final vendorDocumentRepositoryProvider = VendorDocumentRepositoryProvider._();

final class VendorDocumentRepositoryProvider
    extends
        $FunctionalProvider<
          ServerpodVendorDocumentRepository,
          ServerpodVendorDocumentRepository,
          ServerpodVendorDocumentRepository
        >
    with $Provider<ServerpodVendorDocumentRepository> {
  VendorDocumentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorDocumentRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorDocumentRepositoryHash();

  @$internal
  @override
  $ProviderElement<ServerpodVendorDocumentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServerpodVendorDocumentRepository create(Ref ref) {
    return vendorDocumentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerpodVendorDocumentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerpodVendorDocumentRepository>(
        value,
      ),
    );
  }
}

String _$vendorDocumentRepositoryHash() =>
    r'2759282a21b709b0e19ad2c986380b349fcf346c';
