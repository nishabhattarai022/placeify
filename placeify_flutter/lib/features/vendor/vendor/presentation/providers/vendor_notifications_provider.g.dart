// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VendorNotifications)
final vendorNotificationsProvider = VendorNotificationsProvider._();

final class VendorNotificationsProvider
    extends
        $AsyncNotifierProvider<VendorNotifications, VendorNotificationsState> {
  VendorNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorNotificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorNotificationsHash();

  @$internal
  @override
  VendorNotifications create() => VendorNotifications();
}

String _$vendorNotificationsHash() =>
    r'5040577c31a0274613c62db77fae4ac8fd8d9db9';

abstract class _$VendorNotifications
    extends $AsyncNotifier<VendorNotificationsState> {
  FutureOr<VendorNotificationsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<VendorNotificationsState>,
              VendorNotificationsState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<VendorNotificationsState>,
                VendorNotificationsState
              >,
              AsyncValue<VendorNotificationsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
