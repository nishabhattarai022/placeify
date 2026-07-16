// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_model_3d_generation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VendorModel3dGeneration)
final vendorModel3dGenerationProvider = VendorModel3dGenerationProvider._();

final class VendorModel3dGenerationProvider
    extends $NotifierProvider<VendorModel3dGeneration, Set<String>> {
  VendorModel3dGenerationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorModel3dGenerationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorModel3dGenerationHash();

  @$internal
  @override
  VendorModel3dGeneration create() => VendorModel3dGeneration();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$vendorModel3dGenerationHash() =>
    r'a1b2c3d4e5f60718293a4b5c6d7e8f9012345678';

abstract class _$VendorModel3dGeneration extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
