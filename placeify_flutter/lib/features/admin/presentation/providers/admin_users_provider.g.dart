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
  AdminUsersListProvider._({
    required AdminUsersListFamily super.from,
    required (String, UserRole?) super.argument,
  }) : super(
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
        '$argument';
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

String _$adminUsersListHash() => r'cf13671507625368845c04086171e47aa3631530';

final class AdminUsersListFamily extends $Family
    with
        $ClassFamilyOverride<
          AdminUsersList,
          AsyncValue<List<PlatformUser>>,
          List<PlatformUser>,
          FutureOr<List<PlatformUser>>,
          (String, UserRole?)
        > {
  AdminUsersListFamily._()
    : super(
        retry: null,
        name: r'adminUsersListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AdminUsersListProvider call(String query, UserRole? role) =>
      AdminUsersListProvider._(argument: (query, role), from: this);

  @override
  String toString() => r'adminUsersListProvider';
}

abstract class _$AdminUsersList extends $AsyncNotifier<List<PlatformUser>> {
  late final _$args = ref.$arg as (String, UserRole?);
  String get query => _$args.$1;
  UserRole? get role => _$args.$2;

  FutureOr<List<PlatformUser>> build(String query, UserRole? role);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<PlatformUser>>, List<PlatformUser>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PlatformUser>>, List<PlatformUser>>,
              AsyncValue<List<PlatformUser>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}

@ProviderFor(adminUserDetail)
final adminUserDetailProvider = AdminUserDetailFamily._();

final class AdminUserDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<PlatformUser?>,
          PlatformUser?,
          FutureOr<PlatformUser?>
        >
    with $FutureModifier<PlatformUser?>, $FutureProvider<PlatformUser?> {
  AdminUserDetailProvider._({
    required AdminUserDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'adminUserDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminUserDetailHash();

  @override
  String toString() {
    return r'adminUserDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PlatformUser?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PlatformUser?> create(Ref ref) {
    final argument = this.argument as String;
    return adminUserDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminUserDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminUserDetailHash() => r'50000c693bdfe2d6e9c4659063c38563d805d7b4';

final class AdminUserDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PlatformUser?>, String> {
  AdminUserDetailFamily._()
    : super(
        retry: null,
        name: r'adminUserDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AdminUserDetailProvider call(String userId) =>
      AdminUserDetailProvider._(argument: userId, from: this);

  @override
  String toString() => r'adminUserDetailProvider';
}
