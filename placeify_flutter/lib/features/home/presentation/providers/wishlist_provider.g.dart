// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Product id → time saved. Backed by Serverpod wishlist endpoints.

@ProviderFor(Wishlist)
final wishlistProvider = WishlistProvider._();

/// Product id → time saved. Backed by Serverpod wishlist endpoints.
final class WishlistProvider
    extends $NotifierProvider<Wishlist, Map<String, DateTime>> {
  /// Product id → time saved. Backed by Serverpod wishlist endpoints.
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
  Override overrideWithValue(Map<String, DateTime> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, DateTime>>(value),
    );
  }
}

String _$wishlistHash() => r'cb78bd7755968e33e76a13407961aeb66161ee85';

/// Product id → time saved. Backed by Serverpod wishlist endpoints.

abstract class _$Wishlist extends $Notifier<Map<String, DateTime>> {
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
