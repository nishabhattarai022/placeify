// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_profile_editor_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VendorProfileEditor)
final vendorProfileEditorProvider = VendorProfileEditorProvider._();

final class VendorProfileEditorProvider
    extends $NotifierProvider<VendorProfileEditor, VendorProfileEditorState> {
  VendorProfileEditorProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'vendorProfileEditorProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$vendorProfileEditorHash();

  @$internal
  @override
  VendorProfileEditor create() => VendorProfileEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VendorProfileEditorState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VendorProfileEditorState>(value),
    );
  }
}

String _$vendorProfileEditorHash() =>
    r'215e9cfc2ecd831b93f1ed13ddacc47c08a32e72';

abstract class _$VendorProfileEditor
    extends $Notifier<VendorProfileEditorState> {
  VendorProfileEditorState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<VendorProfileEditorState, VendorProfileEditorState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<VendorProfileEditorState, VendorProfileEditorState>,
        VendorProfileEditorState,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(vendorProfileHasUnsavedChanges)
final vendorProfileHasUnsavedChangesProvider =
    VendorProfileHasUnsavedChangesProvider._();

final class VendorProfileHasUnsavedChangesProvider
    extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  VendorProfileHasUnsavedChangesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'vendorProfileHasUnsavedChangesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$vendorProfileHasUnsavedChangesHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return vendorProfileHasUnsavedChanges(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$vendorProfileHasUnsavedChangesHash() =>
    r'1e40d3844d09143d641836fda71269bf190deb01';
