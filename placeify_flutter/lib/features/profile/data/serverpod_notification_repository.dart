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
