// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(profileRepository)
final profileRepositoryProvider = ProfileRepositoryProvider._();

final class ProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileRepository,
          ProfileRepository,
          ProfileRepository
        >
    with $Provider<ProfileRepository> {
  ProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRepository create(Ref ref) {
    return profileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRepository>(value),
    );
  }
}

String _$profileRepositoryHash() => r'99c6968648bd7f0b614acbe124606a9c79bf831a';

@ProviderFor(ProfileDashboard)
final profileDashboardProvider = ProfileDashboardProvider._();

final class ProfileDashboardProvider
    extends $AsyncNotifierProvider<ProfileDashboard, UserDashboard?> {
  ProfileDashboardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileDashboardProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileDashboardHash();

  @$internal
  @override
  ProfileDashboard create() => ProfileDashboard();
}

String _$profileDashboardHash() => r'c174bc662c4977e8404f904f744e76f81ca18069';

abstract class _$ProfileDashboard extends $AsyncNotifier<UserDashboard?> {
  FutureOr<UserDashboard?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserDashboard?>, UserDashboard?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserDashboard?>, UserDashboard?>,
              AsyncValue<UserDashboard?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ProfileOrders)
final profileOrdersProvider = ProfileOrdersProvider._();

final class ProfileOrdersProvider
    extends $AsyncNotifierProvider<ProfileOrders, List<UserOrderSummary>> {
  ProfileOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileOrdersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileOrdersHash();

  @$internal
  @override
  ProfileOrders create() => ProfileOrders();
}

String _$profileOrdersHash() => r'9abd1cf446d8982522e61b0fe04fd0c61a9313ea';

abstract class _$ProfileOrders extends $AsyncNotifier<List<UserOrderSummary>> {
  FutureOr<List<UserOrderSummary>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<UserOrderSummary>>, List<UserOrderSummary>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<UserOrderSummary>>,
                List<UserOrderSummary>
              >,
              AsyncValue<List<UserOrderSummary>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ProfileArSessions)
final profileArSessionsProvider = ProfileArSessionsProvider._();

final class ProfileArSessionsProvider
    extends
        $AsyncNotifierProvider<ProfileArSessions, List<UserArSessionSummary>> {
  ProfileArSessionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileArSessionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileArSessionsHash();

  @$internal
  @override
  ProfileArSessions create() => ProfileArSessions();
}

String _$profileArSessionsHash() => r'1adc07f33b9a063fdf0751fd6722da9328e82927';

abstract class _$ProfileArSessions
    extends $AsyncNotifier<List<UserArSessionSummary>> {
  FutureOr<List<UserArSessionSummary>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<UserArSessionSummary>>,
              List<UserArSessionSummary>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<UserArSessionSummary>>,
                List<UserArSessionSummary>
              >,
              AsyncValue<List<UserArSessionSummary>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
