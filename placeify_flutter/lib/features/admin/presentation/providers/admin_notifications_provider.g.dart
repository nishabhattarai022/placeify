// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminNotifications)
final adminNotificationsProvider = AdminNotificationsProvider._();

final class AdminNotificationsProvider
    extends
        $AsyncNotifierProvider<AdminNotifications, List<AdminNotification>> {
  AdminNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminNotificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminNotificationsHash();

  @$internal
  @override
  AdminNotifications create() => AdminNotifications();
}

String _$adminNotificationsHash() =>
    r'1727b1f993f7052f10efa3ee8c449de2b5c8a58e';

abstract class _$AdminNotifications
    extends $AsyncNotifier<List<AdminNotification>> {
  FutureOr<List<AdminNotification>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<AdminNotification>>,
              List<AdminNotification>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AdminNotification>>,
                List<AdminNotification>
              >,
              AsyncValue<List<AdminNotification>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
