// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_notification_badge_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(vendorNotificationBadgeCount)
final vendorNotificationBadgeCountProvider =
    VendorNotificationBadgeCountProvider._();

final class VendorNotificationBadgeCountProvider
    extends $FunctionalProvider<int, int, int> with $Provider<int> {
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
