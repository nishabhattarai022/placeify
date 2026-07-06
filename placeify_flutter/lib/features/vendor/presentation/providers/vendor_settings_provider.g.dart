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
    extends $AsyncNotifierProvider<VendorSettings, VendorSettingsState> {
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
}

String _$vendorSettingsHash() => r'020b8948831ebfae095181881fd89b4ef3cd2dda';

abstract class _$VendorSettings extends $AsyncNotifier<VendorSettingsState> {
  FutureOr<VendorSettingsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<VendorSettingsState>, VendorSettingsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<VendorSettingsState>, VendorSettingsState>,
              AsyncValue<VendorSettingsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
