import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/notification_type.dart';

part 'vendor_notification.freezed.dart';
part 'vendor_notification.g.dart';

@freezed
abstract class VendorNotification with _$VendorNotification {
  const factory VendorNotification({
    required String id,
    required NotificationType type,
    required String title,
    required String body,
    @Default(false) bool isRead,
    required DateTime createdAt,
    String? relatedId,
  }) = _VendorNotification;

  factory VendorNotification.fromJson(Map<String, dynamic> json) =>
      _$VendorNotificationFromJson(json);
}
