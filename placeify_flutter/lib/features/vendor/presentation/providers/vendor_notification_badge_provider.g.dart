// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_notification_badge_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All unread notifications — used on the dashboard bell.

@ProviderFor(vendorNotificationBadgeCount)
final vendorNotificationBadgeCountProvider =
    VendorNotificationBadgeCountProvider._();

/// All unread notifications — used on the dashboard bell.

final class VendorNotificationBadgeCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// All unread notifications — used on the dashboard bell.
  VendorNotificationBadgeCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorNotificationBadgeCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorNotificationBadgeCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return vendorNotificationBadgeCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$vendorNotificationBadgeCountHash() =>
    r'f4b1145aa284629c2370102dae226703b4ca7e4a';

/// Order-only unread count — used on the Orders bottom-nav tab.

@ProviderFor(vendorOrderNotificationBadgeCount)
final vendorOrderNotificationBadgeCountProvider =
    VendorOrderNotificationBadgeCountProvider._();

/// Order-only unread count — used on the Orders bottom-nav tab.

final class VendorOrderNotificationBadgeCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Order-only unread count — used on the Orders bottom-nav tab.
  VendorOrderNotificationBadgeCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorOrderNotificationBadgeCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$vendorOrderNotificationBadgeCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return vendorOrderNotificationBadgeCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$vendorOrderNotificationBadgeCountHash() =>
    r'bc8855f4cf7d4977e909b1dc953e60589f5a2e73';
