/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'in_app_notification_type.dart' as _i2;

/// In-app notification row for API responses.
abstract class InAppNotificationSummary implements _i1.SerializableModel {
  InAppNotificationSummary._({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.referenceId,
    this.referenceKey,
    required this.isRead,
    required this.createdAt,
  });

  factory InAppNotificationSummary({
    required int id,
    required String title,
    required String message,
    required _i2.InAppNotificationType type,
    int? referenceId,
    String? referenceKey,
    required bool isRead,
    required DateTime createdAt,
  }) = _InAppNotificationSummaryImpl;

  factory InAppNotificationSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return InAppNotificationSummary(
      id: jsonSerialization['id'] as int,
      title: jsonSerialization['title'] as String,
      message: jsonSerialization['message'] as String,
      type: _i2.InAppNotificationType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      referenceId: jsonSerialization['referenceId'] as int?,
      referenceKey: jsonSerialization['referenceKey'] as String?,
      isRead: _i1.BoolJsonExtension.fromJson(jsonSerialization['isRead']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  String title;

  String message;

  _i2.InAppNotificationType type;

  int? referenceId;

  String? referenceKey;

  bool isRead;

  DateTime createdAt;

  /// Returns a shallow copy of this [InAppNotificationSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  InAppNotificationSummary copyWith({
    int? id,
    String? title,
    String? message,
    _i2.InAppNotificationType? type,
    int? referenceId,
    String? referenceKey,
    bool? isRead,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InAppNotificationSummary',
      'id': id,
      'title': title,
      'message': message,
      'type': type.toJson(),
      if (referenceId != null) 'referenceId': referenceId,
      if (referenceKey != null) 'referenceKey': referenceKey,
      'isRead': isRead,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InAppNotificationSummaryImpl extends InAppNotificationSummary {
  _InAppNotificationSummaryImpl({
    required int id,
    required String title,
    required String message,
    required _i2.InAppNotificationType type,
    int? referenceId,
    String? referenceKey,
    required bool isRead,
    required DateTime createdAt,
  }) : super._(
         id: id,
         title: title,
         message: message,
         type: type,
         referenceId: referenceId,
         referenceKey: referenceKey,
         isRead: isRead,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [InAppNotificationSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  InAppNotificationSummary copyWith({
    int? id,
    String? title,
    String? message,
    _i2.InAppNotificationType? type,
    Object? referenceId = _Undefined,
    Object? referenceKey = _Undefined,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return InAppNotificationSummary(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      referenceId: referenceId is int? ? referenceId : this.referenceId,
      referenceKey: referenceKey is String? ? referenceKey : this.referenceKey,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
