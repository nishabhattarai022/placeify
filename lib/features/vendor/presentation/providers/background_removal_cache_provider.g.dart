// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'background_removal_cache_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Caches processed image paths by source image id to avoid re-processing on rebuild.

@ProviderFor(BackgroundRemovalCache)
final backgroundRemovalCacheProvider = BackgroundRemovalCacheProvider._();

/// Caches processed image paths by source image id to avoid re-processing on rebuild.
final class BackgroundRemovalCacheProvider
    extends $NotifierProvider<BackgroundRemovalCache, Map<String, String>> {
  /// Caches processed image paths by source image id to avoid re-processing on rebuild.
  BackgroundRemovalCacheProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'backgroundRemovalCacheProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$backgroundRemovalCacheHash();

  @$internal
  @override
  BackgroundRemovalCache create() => BackgroundRemovalCache();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, String>>(value),
    );
  }
}

String _$backgroundRemovalCacheHash() =>
    r'4c23f594de3b2706537eaab5e081c0ef5baf7138';

/// Caches processed image paths by source image id to avoid re-processing on rebuild.

abstract class _$BackgroundRemovalCache extends $Notifier<Map<String, String>> {
  Map<String, String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<String, String>, Map<String, String>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Map<String, String>, Map<String, String>>,
        Map<String, String>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
