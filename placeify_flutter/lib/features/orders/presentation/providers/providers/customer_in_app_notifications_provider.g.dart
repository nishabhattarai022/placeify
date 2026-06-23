// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_in_app_notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Customer order notifications backed by the server (30s polling).

@ProviderFor(CustomerInAppNotifications)
final customerInAppNotificationsProvider =
    CustomerInAppNotificationsProvider._();

/// Customer order notifications backed by the server (30s polling).
final class CustomerInAppNotificationsProvider
    extends
        $AsyncNotifierProvider<
          CustomerInAppNotifications,
          CustomerInAppNotificationsState
        > {
  /// Customer order notifications backed by the server (30s polling).
  CustomerInAppNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerInAppNotificationsProvider',
        isAutoDispose: true,
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
    r'1d1443cac1c6d53b0c5963aef715578216e59df3';

/// Customer order notifications backed by the server (30s polling).

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
