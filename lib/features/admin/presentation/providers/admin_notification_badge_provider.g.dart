// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_notification_badge_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminNotificationBadgeCount)
final adminNotificationBadgeCountProvider =
    AdminNotificationBadgeCountProvider._();

final class AdminNotificationBadgeCountProvider
    extends $FunctionalProvider<int, int, int> with $Provider<int> {
  AdminNotificationBadgeCountProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'adminNotificationBadgeCountProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$adminNotificationBadgeCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return adminNotificationBadgeCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$adminNotificationBadgeCountHash() =>
    r'2b60154da60c1ee6b203f053336e60f854e6e5a3';
