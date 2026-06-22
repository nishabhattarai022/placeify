import 'package:placeify_client/placeify_client.dart' as api;

import '../domain/enums/notification_type.dart';
import '../domain/models/vendor_notification.dart';

abstract final class VendorNotificationMapper {
  static VendorNotification fromSummary(api.VendorNotificationSummary summary) {
    return VendorNotification(
      id: summary.id,
      type: mapType(summary.type),
      title: summary.title,
      body: summary.body,
      isRead: summary.isRead,
      createdAt: summary.createdAt,
      relatedId: summary.relatedId,
    );
  }

  static NotificationType mapType(api.VendorNotificationType type) {
    return switch (type) {
      api.VendorNotificationType.order => NotificationType.order,
      api.VendorNotificationType.payment => NotificationType.payment,
      api.VendorNotificationType.product => NotificationType.product,
      api.VendorNotificationType.system => NotificationType.system,
    };
  }
}
