import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_notification_badge_provider.g.dart';

/// Stub unread notification count until Phase 8 wires [VendorNotificationsNotifier].
@riverpod
int vendorNotificationBadgeCount(Ref ref) => 3;
