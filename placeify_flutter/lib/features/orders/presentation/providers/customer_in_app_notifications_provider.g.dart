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
    r'7e7ac3353e1b4841f72c3d9211359c842b8e709b';

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

@ProviderFor(customerNotificationBadgeCount)
final customerNotificationBadgeCountProvider =
    CustomerNotificationBadgeCountProvider._();

final class CustomerNotificationBadgeCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  CustomerNotificationBadgeCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerNotificationBadgeCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerNotificationBadgeCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return customerNotificationBadgeCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$customerNotificationBadgeCountHash() =>
    r'5aebbda89020350f2365c015d292087301d6b7ca';
