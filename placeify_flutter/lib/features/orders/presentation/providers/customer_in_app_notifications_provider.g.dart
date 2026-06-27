// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_in_app_notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Customer order notifications backed by the server (30s polling).
/// TODO(production): replace polling with Serverpod streaming or FCM push.

@ProviderFor(CustomerInAppNotifications)
final customerInAppNotificationsProvider =
    CustomerInAppNotificationsProvider._();

/// Customer order notifications backed by the server (30s polling).
/// TODO(production): replace polling with Serverpod streaming or FCM push.
final class CustomerInAppNotificationsProvider
    extends
        $AsyncNotifierProvider<
          CustomerInAppNotifications,
          CustomerInAppNotificationsState
        > {
  /// Customer order notifications backed by the server (30s polling).
  /// TODO(production): replace polling with Serverpod streaming or FCM push.
  CustomerInAppNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerInAppNotificationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerInAppNotificationsHash();

  @$internal
  @override
  CustomerInAppNotifications create() => CustomerInAppNotifications();
}

String _$customerInAppNotificationsHash() =>
    r'e1dc72732263fae8d3f54b9dd35bb73b1b164783';

/// Customer order notifications backed by the server (30s polling).
/// TODO(production): replace polling with Serverpod streaming or FCM push.

abstract class _$CustomerInAppNotifications
    extends $AsyncNotifier<CustomerInAppNotificationsState> {
  FutureOr<CustomerInAppNotificationsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<CustomerInAppNotificationsState>,
              CustomerInAppNotificationsState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<CustomerInAppNotificationsState>,
                CustomerInAppNotificationsState
              >,
              AsyncValue<CustomerInAppNotificationsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
