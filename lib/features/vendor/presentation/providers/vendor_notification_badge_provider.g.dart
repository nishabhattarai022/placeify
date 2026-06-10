// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_notification_badge_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stub unread notification count until Phase 8 wires [VendorNotificationsNotifier].

@ProviderFor(vendorNotificationBadgeCount)
final vendorNotificationBadgeCountProvider =
    VendorNotificationBadgeCountProvider._();

/// Stub unread notification count until Phase 8 wires [VendorNotificationsNotifier].

final class VendorNotificationBadgeCountProvider
    extends $FunctionalProvider<int, int, int> with $Provider<int> {
  /// Stub unread notification count until Phase 8 wires [VendorNotificationsNotifier].
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
    r'd6cabc80ca7ee4fff5be1061ff5da533872e8c02';
