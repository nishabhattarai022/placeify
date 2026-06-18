// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_wishlist_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userWishlistRepository)
final userWishlistRepositoryProvider = UserWishlistRepositoryProvider._();

final class UserWishlistRepositoryProvider
    extends
        $FunctionalProvider<
          ServerpodWishlistRepository,
          ServerpodWishlistRepository,
          ServerpodWishlistRepository
        >
    with $Provider<ServerpodWishlistRepository> {
  UserWishlistRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userWishlistRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userWishlistRepositoryHash();

  @$internal
  @override
  $ProviderElement<ServerpodWishlistRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServerpodWishlistRepository create(Ref ref) {
    return userWishlistRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerpodWishlistRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerpodWishlistRepository>(value),
    );
  }
}

String _$userWishlistRepositoryHash() =>
    r'bfc380cc561c53425e1cb794acee6aaa8b726805';

@ProviderFor(UserWishlist)
final userWishlistProvider = UserWishlistProvider._();

final class UserWishlistProvider
    extends $AsyncNotifierProvider<UserWishlist, List<UserWishlistEntry>> {
  UserWishlistProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userWishlistProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userWishlistHash();

  @$internal
  @override
  UserWishlist create() => UserWishlist();
}

String _$userWishlistHash() => r'03dc855e92ec00e25ed49e6d3f7b3f32269f0c29';

abstract class _$UserWishlist extends $AsyncNotifier<List<UserWishlistEntry>> {
  FutureOr<List<UserWishlistEntry>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<UserWishlistEntry>>,
              List<UserWishlistEntry>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<UserWishlistEntry>>,
                List<UserWishlistEntry>
              >,
              AsyncValue<List<UserWishlistEntry>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
