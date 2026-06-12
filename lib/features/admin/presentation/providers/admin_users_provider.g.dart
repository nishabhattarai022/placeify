// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_users_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminUsersList)
final adminUsersListProvider = AdminUsersListFamily._();

final class AdminUsersListProvider
    extends $AsyncNotifierProvider<AdminUsersList, List<PlatformUser>> {
  AdminUsersListProvider._(
      {required AdminUsersListFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'adminUsersListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$adminUsersListHash();

  @override
  String toString() {
    return r'adminUsersListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AdminUsersList create() => AdminUsersList();

  @override
  bool operator ==(Object other) {
    return other is AdminUsersListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminUsersListHash() => r'12ad7683f25f83a773916f97c662018e2d8c99a2';

final class AdminUsersListFamily extends $Family
    with
        $ClassFamilyOverride<AdminUsersList, AsyncValue<List<PlatformUser>>,
            List<PlatformUser>, FutureOr<List<PlatformUser>>, String> {
  AdminUsersListFamily._()
      : super(
          retry: null,
          name: r'adminUsersListProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  AdminUsersListProvider call(
    String query,
  ) =>
      AdminUsersListProvider._(argument: query, from: this);

  @override
  String toString() => r'adminUsersListProvider';
}

abstract class _$AdminUsersList extends $AsyncNotifier<List<PlatformUser>> {
  late final _$args = ref.$arg as String;
  String get query => _$args;

  FutureOr<List<PlatformUser>> build(
    String query,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<PlatformUser>>, List<PlatformUser>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<PlatformUser>>, List<PlatformUser>>,
        AsyncValue<List<PlatformUser>>,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
