// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_in_app_notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Customer in-app notifications backed by Serverpod streaming.

@ProviderFor(CustomerInAppNotifications)
final customerInAppNotificationsProvider =
    CustomerInAppNotificationsProvider._();

/// Customer in-app notifications backed by Serverpod streaming.
final class CustomerInAppNotificationsProvider
    extends
        $AsyncNotifierProvider<
          CustomerInAppNotifications,
          CustomerInAppNotificationsState
        > {
  /// Customer in-app notifications backed by Serverpod streaming.
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
    r'b99b654c296ba22c56178a1988e07081856bd68e';

/// Customer in-app notifications backed by Serverpod streaming.

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
