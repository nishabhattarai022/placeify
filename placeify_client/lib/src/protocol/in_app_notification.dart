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
import 'user.dart' as _i2;
import 'in_app_notification_type.dart' as _i3;
import 'package:placeify_client/src/protocol/protocol.dart' as _i4;

/// Persisted in-app notification for customers and vendors.
abstract class InAppNotification implements _i1.SerializableModel {
  InAppNotification._({
    this.id,
    required this.userId,
    this.user,
    required this.title,
    required this.message,
    required this.type,
    this.referenceId,
    this.referenceKey,
    bool? isRead,
    DateTime? createdAt,
  }) : isRead = isRead ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory InAppNotification({
    int? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required String title,
    required String message,
    required _i3.InAppNotificationType type,
    int? referenceId,
    String? referenceKey,
    bool? isRead,
    DateTime? createdAt,
  }) = _InAppNotificationImpl;

  factory InAppNotification.fromJson(Map<String, dynamic> jsonSerialization) {
    return InAppNotification(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
      title: jsonSerialization['title'] as String,
      message: jsonSerialization['message'] as String,
      type: _i3.InAppNotificationType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      referenceId: jsonSerialization['referenceId'] as int?,
      referenceKey: jsonSerialization['referenceKey'] as String?,
      isRead: jsonSerialization['isRead'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isRead']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue userId;

  _i2.User? user;

  String title;

  String message;

  _i3.InAppNotificationType type;

  int? referenceId;

  String? referenceKey;

  bool isRead;

  DateTime createdAt;

  /// Returns a shallow copy of this [InAppNotification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  InAppNotification copyWith({
    int? id,
    _i1.UuidValue? userId,
    _i2.User? user,
    String? title,
    String? message,
    _i3.InAppNotificationType? type,
    int? referenceId,
    String? referenceKey,
    bool? isRead,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InAppNotification',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
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

class _InAppNotificationImpl extends InAppNotification {
  _InAppNotificationImpl({
    int? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required String title,
    required String message,
    required _i3.InAppNotificationType type,
    int? referenceId,
    String? referenceKey,
    bool? isRead,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         title: title,
         message: message,
         type: type,
         referenceId: referenceId,
         referenceKey: referenceKey,
         isRead: isRead,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [InAppNotification]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  InAppNotification copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    String? title,
    String? message,
    _i3.InAppNotificationType? type,
    Object? referenceId = _Undefined,
    Object? referenceKey = _Undefined,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return InAppNotification(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
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
