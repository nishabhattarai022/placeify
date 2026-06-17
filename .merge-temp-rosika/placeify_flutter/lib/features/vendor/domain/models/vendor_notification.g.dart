// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorNotification _$VendorNotificationFromJson(Map<String, dynamic> json) =>
    _VendorNotification(
      id: json['id'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      title: json['title'] as String,
      body: json['body'] as String,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      relatedId: json['relatedId'] as String?,
    );

Map<String, dynamic> _$VendorNotificationToJson(_VendorNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'body': instance.body,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt.toIso8601String(),
      'relatedId': instance.relatedId,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.order: 'order',
  NotificationType.payment: 'payment',
  NotificationType.product: 'product',
  NotificationType.system: 'system',
};
