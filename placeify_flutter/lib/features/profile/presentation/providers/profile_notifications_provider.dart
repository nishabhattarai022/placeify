import 'package:placeify_client/placeify_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/config/placeify_server_client.dart';
import '../../data/serverpod_notification_repository.dart';

part 'profile_notifications_provider.g.dart';

@riverpod
class ProfileNotifications extends _$ProfileNotifications {
  static final _repository = ServerpodNotificationRepository();

  @override
  Future<NotificationPreference> build() async {
    if (!client.auth.isAuthenticated) {
      throw NotificationRepositoryException('Sign in to manage notifications.');
    }
    return _repository.getPreferences();
  }

  Future<String?> save(NotificationPreference updated) async {
    try {
      final saved = await _repository.updatePreferences(
        orderUpdates: updated.orderUpdates,
        refundStatus: updated.refundStatus,
        arReminders: updated.arReminders,
        priceDropAlerts: updated.priceDropAlerts,
        vendorMessages: updated.vendorMessages,
        promotions: updated.promotions,
      );
      state = AsyncData(saved);
      return null;
    } on NotificationRepositoryException catch (error) {
      return error.message;
    } catch (_) {
      return 'Could not save notification preferences.';
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
