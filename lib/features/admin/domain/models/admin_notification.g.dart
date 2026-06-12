// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminNotification _$AdminNotificationFromJson(Map<String, dynamic> json) =>
    _AdminNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      read: json['read'] as bool? ?? false,
    );

Map<String, dynamic> _$AdminNotificationToJson(_AdminNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'createdAt': instance.createdAt.toIso8601String(),
      'read': instance.read,
    };
