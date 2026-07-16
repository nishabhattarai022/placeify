// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_in_app_notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileInAppNotifications)
final profileInAppNotificationsProvider = ProfileInAppNotificationsProvider._();

final class ProfileInAppNotificationsProvider
    extends
        $AsyncNotifierProvider<
          ProfileInAppNotifications,
          ProfileInAppNotificationsState
        > {
  ProfileInAppNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileInAppNotificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileInAppNotificationsHash();

  @$internal
  @override
  ProfileInAppNotifications create() => ProfileInAppNotifications();
}

String _$profileInAppNotificationsHash() =>
    r'88ac9dbd5e8eae63b7cd4866666258f373348d44';

abstract class _$ProfileInAppNotifications
    extends $AsyncNotifier<ProfileInAppNotificationsState> {
  FutureOr<ProfileInAppNotificationsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<ProfileInAppNotificationsState>,
              ProfileInAppNotificationsState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ProfileInAppNotificationsState>,
                ProfileInAppNotificationsState
              >,
              AsyncValue<ProfileInAppNotificationsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
