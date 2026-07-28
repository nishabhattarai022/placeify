// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ar_saved_products_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Product id → time saved (newest first when listed).

@ProviderFor(ArSavedProducts)
final arSavedProductsProvider = ArSavedProductsProvider._();

/// Product id → time saved (newest first when listed).
final class ArSavedProductsProvider
    extends $NotifierProvider<ArSavedProducts, Map<String, DateTime>> {
  /// Product id → time saved (newest first when listed).
  ArSavedProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'arSavedProductsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$arSavedProductsHash();

  @$internal
  @override
  ArSavedProducts create() => ArSavedProducts();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, DateTime> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, DateTime>>(value),
    );
  }
}

String _$arSavedProductsHash() => r'20fbf1c98f20c8c598e77baab367d4004e79f51b';

/// Product id → time saved (newest first when listed).

abstract class _$ArSavedProducts extends $Notifier<Map<String, DateTime>> {
  Map<String, DateTime> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<String, DateTime>, Map<String, DateTime>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, DateTime>, Map<String, DateTime>>,
              Map<String, DateTime>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
