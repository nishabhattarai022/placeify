// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Wishlist)
final wishlistProvider = WishlistProvider._();

final class WishlistProvider
    extends $NotifierProvider<Wishlist, WishlistSnapshot> {
  WishlistProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wishlistProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wishlistHash();

  @$internal
  @override
  Wishlist create() => Wishlist();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WishlistSnapshot value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WishlistSnapshot>(value),
    );
  }
}

String _$wishlistHash() => r'0020b58290b51339f0abf2eec3dd210b257631c5';

abstract class _$Wishlist extends $Notifier<WishlistSnapshot> {
  WishlistSnapshot build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<WishlistSnapshot, WishlistSnapshot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WishlistSnapshot, WishlistSnapshot>,
              WishlistSnapshot,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
