// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VendorSettings)
final vendorSettingsProvider = VendorSettingsProvider._();

final class VendorSettingsProvider
    extends $NotifierProvider<VendorSettings, VendorSettingsState> {
  VendorSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorSettingsHash();

  @$internal
  @override
  VendorSettings create() => VendorSettings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VendorSettingsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VendorSettingsState>(value),
    );
  }
}

String _$vendorSettingsHash() => r'5ab3eb68ddb4b0e4fa5716031482b3a455be79fa';

abstract class _$VendorSettings extends $Notifier<VendorSettingsState> {
  VendorSettingsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<VendorSettingsState, VendorSettingsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VendorSettingsState, VendorSettingsState>,
              VendorSettingsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
