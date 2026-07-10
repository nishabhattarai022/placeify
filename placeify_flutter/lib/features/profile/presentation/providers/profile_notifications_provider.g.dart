// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileNotifications)
final profileNotificationsProvider = ProfileNotificationsProvider._();

final class ProfileNotificationsProvider
    extends
        $AsyncNotifierProvider<ProfileNotifications, NotificationPreference> {
  ProfileNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileNotificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileNotificationsHash();

  @$internal
  @override
  ProfileNotifications create() => ProfileNotifications();
}

String _$profileNotificationsHash() =>
    r'835dae987addfdebe6fb456a5c34824cb35ea1f6';

abstract class _$ProfileNotifications
    extends $AsyncNotifier<NotificationPreference> {
  FutureOr<NotificationPreference> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<NotificationPreference>, NotificationPreference>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<NotificationPreference>,
                NotificationPreference
              >,
              AsyncValue<NotificationPreference>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
