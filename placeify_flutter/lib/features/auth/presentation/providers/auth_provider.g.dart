// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider extends $FunctionalProvider<
        AsyncValue<AuthRepository>, AuthRepository, FutureOr<AuthRepository>>
    with $FutureModifier<AuthRepository>, $FutureProvider<AuthRepository> {
  AuthRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<AuthRepository> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AuthRepository> create(Ref ref) {
    return authRepository(ref);
  }
}

String _$authRepositoryHash() => r'e156dabc1692dc8953b4b0cfa8ce8d121f9418dc';

@ProviderFor(CurrentUser)
final currentUserProvider = CurrentUserProvider._();

final class CurrentUserProvider
    extends $AsyncNotifierProvider<CurrentUser, AppUser?> {
  CurrentUserProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'currentUserProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  CurrentUser create() => CurrentUser();
}

String _$currentUserHash() => r'9e9bc6d4ba7f9bcf900c794321453f4c84d87d89';

abstract class _$CurrentUser extends $AsyncNotifier<AppUser?> {
  FutureOr<AppUser?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppUser?>, AppUser?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<AppUser?>, AppUser?>,
        AsyncValue<AppUser?>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
