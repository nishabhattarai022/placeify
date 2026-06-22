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
import 'package:serverpod/serverpod.dart' as _i1;
import 'vendor_notification_type.dart' as _i2;

/// Vendor-facing notification shown in the shop inbox.
abstract class VendorNotificationSummary
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  VendorNotificationSummary._({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    bool? isRead,
    required this.createdAt,
    this.relatedId,
  }) : isRead = isRead ?? false;

  factory VendorNotificationSummary({
    required String id,
    required _i2.VendorNotificationType type,
    required String title,
    required String body,
    bool? isRead,
    required DateTime createdAt,
    String? relatedId,
  }) = _VendorNotificationSummaryImpl;

  factory VendorNotificationSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return VendorNotificationSummary(
      id: jsonSerialization['id'] as String,
      type: _i2.VendorNotificationType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      isRead: jsonSerialization['isRead'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isRead']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      relatedId: jsonSerialization['relatedId'] as String?,
    );
  }

  String id;

  _i2.VendorNotificationType type;

  String title;

  String body;

  bool isRead;

  DateTime createdAt;

  String? relatedId;

  /// Returns a shallow copy of this [VendorNotificationSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorNotificationSummary copyWith({
    String? id,
    _i2.VendorNotificationType? type,
    String? title,
    String? body,
    bool? isRead,
    DateTime? createdAt,
    String? relatedId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorNotificationSummary',
      'id': id,
      'type': type.toJson(),
      'title': title,
      'body': body,
      'isRead': isRead,
      'createdAt': createdAt.toJson(),
      if (relatedId != null) 'relatedId': relatedId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VendorNotificationSummary',
      'id': id,
      'type': type.toJson(),
      'title': title,
      'body': body,
      'isRead': isRead,
      'createdAt': createdAt.toJson(),
      if (relatedId != null) 'relatedId': relatedId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorNotificationSummaryImpl extends VendorNotificationSummary {
  _VendorNotificationSummaryImpl({
    required String id,
    required _i2.VendorNotificationType type,
    required String title,
    required String body,
    bool? isRead,
    required DateTime createdAt,
    String? relatedId,
  }) : super._(
         id: id,
         type: type,
         title: title,
         body: body,
         isRead: isRead,
         createdAt: createdAt,
         relatedId: relatedId,
       );

  /// Returns a shallow copy of this [VendorNotificationSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorNotificationSummary copyWith({
    String? id,
    _i2.VendorNotificationType? type,
    String? title,
    String? body,
    bool? isRead,
    DateTime? createdAt,
    Object? relatedId = _Undefined,
  }) {
    return VendorNotificationSummary(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      relatedId: relatedId is String? ? relatedId : this.relatedId,
    );
  }
}
