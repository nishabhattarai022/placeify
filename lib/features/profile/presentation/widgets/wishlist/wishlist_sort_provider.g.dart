// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_sort_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WishlistSortNotifier)
final wishlistSortNotifierProvider = WishlistSortNotifierProvider._();

final class WishlistSortNotifierProvider
    extends $NotifierProvider<WishlistSortNotifier, WishlistSort> {
  WishlistSortNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'wishlistSortNotifierProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$wishlistSortNotifierHash();

  @$internal
  @override
  WishlistSortNotifier create() => WishlistSortNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WishlistSort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WishlistSort>(value),
    );
  }
}

String _$wishlistSortNotifierHash() => r'b7e3d9a41c02f8e6wishlistSortNotifier';

abstract class _$WishlistSortNotifier extends $Notifier<WishlistSort> {
  WishlistSort build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<WishlistSort, WishlistSort>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<WishlistSort, WishlistSort>,
        WishlistSort,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
