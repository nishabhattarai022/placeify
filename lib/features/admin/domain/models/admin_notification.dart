import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_notification.freezed.dart';
part 'admin_notification.g.dart';

/// Admin-facing notification surfaced on the dashboard bell feed.
@freezed
abstract class AdminNotification with _$AdminNotification {
  const factory AdminNotification({
    required String id,
    required String title,
    required String body,
    required DateTime createdAt,
    @Default(false) bool read,
  }) = _AdminNotification;

  factory AdminNotification.fromJson(Map<String, dynamic> json) =>
      _$AdminNotificationFromJson(json);
}
