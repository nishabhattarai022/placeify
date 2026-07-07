import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/config/placeify_server_client.dart';

class NotificationRepositoryException implements Exception {
  NotificationRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Live notification preferences via [client.notification].
class ServerpodNotificationRepository {
  const ServerpodNotificationRepository();

  Future<NotificationPreference> getPreferences() async {
    _requireAuthenticated();
    try {
      return await client.notification.getPreferences();
    } catch (error) {
      throw NotificationRepositoryException(_mapError(error));
    }
  }

  Future<NotificationPreference> updatePreferences({
    bool? orderUpdates,
    bool? refundStatus,
    bool? arReminders,
    bool? priceDropAlerts,
    bool? vendorMessages,
    bool? promotions,
  }) async {
    _requireAuthenticated();
    try {
      return await client.notification.updatePreferences(
        orderUpdates: orderUpdates,
        refundStatus: refundStatus,
        arReminders: arReminders,
        priceDropAlerts: priceDropAlerts,
        vendorMessages: vendorMessages,
        promotions: promotions,
      );
    } catch (error) {
      throw NotificationRepositoryException(_mapError(error));
    }
  }

  Future<List<InAppNotificationSummary>> listInAppNotifications({
    int limit = 50,
    int offset = 0,
  }) async {
    _requireAuthenticated();
    try {
      return await client.notification.listInAppNotifications(
        limit: limit,
        offset: offset,
      );
    } catch (error) {
      throw NotificationRepositoryException(_mapError(error));
    }
  }

  Future<int> unreadInAppNotificationCount() async {
    _requireAuthenticated();
    try {
      return await client.notification.unreadInAppNotificationCount();
    } catch (error) {
      throw NotificationRepositoryException(_mapError(error));
    }
  }

  Future<void> markInAppNotificationRead(int notificationId) async {
    _requireAuthenticated();
    try {
      await client.notification.markInAppNotificationRead(notificationId);
    } catch (error) {
      throw NotificationRepositoryException(_mapError(error));
    }
  }

  Future<void> markAllInAppNotificationsRead() async {
    _requireAuthenticated();
    try {
      await client.notification.markAllInAppNotificationsRead();
    } catch (error) {
      throw NotificationRepositoryException(_mapError(error));
    }
  }

  void _requireAuthenticated() {
    if (!client.auth.isAuthenticated) {
      throw NotificationRepositoryException('Sign in to manage notifications.');
    }
  }

  String _mapError(Object error) {
    if (error is NotificationRepositoryException) return error.message;
    if (error is PlaceifyException) return error.message;
    return error.toString();
  }
}
