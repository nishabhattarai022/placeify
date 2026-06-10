// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_registration_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VendorRegistrationNotifier)
final vendorRegistrationProvider = VendorRegistrationNotifierProvider._();

final class VendorRegistrationNotifierProvider extends $NotifierProvider<
    VendorRegistrationNotifier, VendorRegistrationUiState> {
  VendorRegistrationNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'vendorRegistrationProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$vendorRegistrationNotifierHash();

  @$internal
  @override
  VendorRegistrationNotifier create() => VendorRegistrationNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VendorRegistrationUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VendorRegistrationUiState>(value),
    );
  }
}

String _$vendorRegistrationNotifierHash() =>
    r'eb710342582e62cbc4a2fb51591f22bfeb56389e';

abstract class _$VendorRegistrationNotifier
    extends $Notifier<VendorRegistrationUiState> {
  VendorRegistrationUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<VendorRegistrationUiState, VendorRegistrationUiState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<VendorRegistrationUiState, VendorRegistrationUiState>,
        VendorRegistrationUiState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
