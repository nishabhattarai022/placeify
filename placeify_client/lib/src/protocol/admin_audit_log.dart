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
import 'admin.dart' as _i2;
import 'admin_action_type.dart' as _i3;
import 'package:placeify_client/src/protocol/protocol.dart' as _i4;

/// Immutable audit record for admin actions.
abstract class AdminAuditLog implements _i1.SerializableModel {
  AdminAuditLog._({
    this.id,
    required this.actorAdminId,
    this.actorAdmin,
    required this.actionType,
    this.targetUserId,
    this.targetVendorId,
    this.targetProductId,
    this.targetComplaintId,
    this.targetPayoutId,
    this.targetRefundId,
    this.previousStatus,
    this.newStatus,
    this.reason,
    this.note,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AdminAuditLog({
    _i1.UuidValue? id,
    required _i1.UuidValue actorAdminId,
    _i2.Admin? actorAdmin,
    required _i3.AdminActionType actionType,
    _i1.UuidValue? targetUserId,
    _i1.UuidValue? targetVendorId,
    int? targetProductId,
    _i1.UuidValue? targetComplaintId,
    int? targetPayoutId,
    int? targetRefundId,
    String? previousStatus,
    String? newStatus,
    String? reason,
    String? note,
    DateTime? createdAt,
  }) = _AdminAuditLogImpl;

  factory AdminAuditLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminAuditLog(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      actorAdminId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['actorAdminId'],
      ),
      actorAdmin: jsonSerialization['actorAdmin'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.Admin>(
              jsonSerialization['actorAdmin'],
            ),
      actionType: _i3.AdminActionType.fromJson(
        (jsonSerialization['actionType'] as String),
      ),
      targetUserId: jsonSerialization['targetUserId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['targetUserId'],
            ),
      targetVendorId: jsonSerialization['targetVendorId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['targetVendorId'],
            ),
      targetProductId: jsonSerialization['targetProductId'] as int?,
      targetComplaintId: jsonSerialization['targetComplaintId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['targetComplaintId'],
            ),
      targetPayoutId: jsonSerialization['targetPayoutId'] as int?,
      targetRefundId: jsonSerialization['targetRefundId'] as int?,
      previousStatus: jsonSerialization['previousStatus'] as String?,
      newStatus: jsonSerialization['newStatus'] as String?,
      reason: jsonSerialization['reason'] as String?,
      note: jsonSerialization['note'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue actorAdminId;

  _i2.Admin? actorAdmin;

  _i3.AdminActionType actionType;

  _i1.UuidValue? targetUserId;

  _i1.UuidValue? targetVendorId;

  int? targetProductId;

  _i1.UuidValue? targetComplaintId;

  int? targetPayoutId;

  int? targetRefundId;

  String? previousStatus;

  String? newStatus;

  String? reason;

  String? note;

  DateTime createdAt;

  /// Returns a shallow copy of this [AdminAuditLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminAuditLog copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? actorAdminId,
    _i2.Admin? actorAdmin,
    _i3.AdminActionType? actionType,
    _i1.UuidValue? targetUserId,
    _i1.UuidValue? targetVendorId,
    int? targetProductId,
    _i1.UuidValue? targetComplaintId,
    int? targetPayoutId,
    int? targetRefundId,
    String? previousStatus,
    String? newStatus,
    String? reason,
    String? note,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminAuditLog',
      if (id != null) 'id': id?.toJson(),
      'actorAdminId': actorAdminId.toJson(),
      if (actorAdmin != null) 'actorAdmin': actorAdmin?.toJson(),
      'actionType': actionType.toJson(),
      if (targetUserId != null) 'targetUserId': targetUserId?.toJson(),
      if (targetVendorId != null) 'targetVendorId': targetVendorId?.toJson(),
      if (targetProductId != null) 'targetProductId': targetProductId,
      if (targetComplaintId != null)
        'targetComplaintId': targetComplaintId?.toJson(),
      if (targetPayoutId != null) 'targetPayoutId': targetPayoutId,
      if (targetRefundId != null) 'targetRefundId': targetRefundId,
      if (previousStatus != null) 'previousStatus': previousStatus,
      if (newStatus != null) 'newStatus': newStatus,
      if (reason != null) 'reason': reason,
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminAuditLogImpl extends AdminAuditLog {
  _AdminAuditLogImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue actorAdminId,
    _i2.Admin? actorAdmin,
    required _i3.AdminActionType actionType,
    _i1.UuidValue? targetUserId,
    _i1.UuidValue? targetVendorId,
    int? targetProductId,
    _i1.UuidValue? targetComplaintId,
    int? targetPayoutId,
    int? targetRefundId,
    String? previousStatus,
    String? newStatus,
    String? reason,
    String? note,
    DateTime? createdAt,
  }) : super._(
         id: id,
         actorAdminId: actorAdminId,
         actorAdmin: actorAdmin,
         actionType: actionType,
         targetUserId: targetUserId,
         targetVendorId: targetVendorId,
         targetProductId: targetProductId,
         targetComplaintId: targetComplaintId,
         targetPayoutId: targetPayoutId,
         targetRefundId: targetRefundId,
         previousStatus: previousStatus,
         newStatus: newStatus,
         reason: reason,
         note: note,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AdminAuditLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminAuditLog copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? actorAdminId,
    Object? actorAdmin = _Undefined,
    _i3.AdminActionType? actionType,
    Object? targetUserId = _Undefined,
    Object? targetVendorId = _Undefined,
    Object? targetProductId = _Undefined,
    Object? targetComplaintId = _Undefined,
    Object? targetPayoutId = _Undefined,
    Object? targetRefundId = _Undefined,
    Object? previousStatus = _Undefined,
    Object? newStatus = _Undefined,
    Object? reason = _Undefined,
    Object? note = _Undefined,
    DateTime? createdAt,
  }) {
    return AdminAuditLog(
      id: id is _i1.UuidValue? ? id : this.id,
      actorAdminId: actorAdminId ?? this.actorAdminId,
      actorAdmin: actorAdmin is _i2.Admin?
          ? actorAdmin
          : this.actorAdmin?.copyWith(),
      actionType: actionType ?? this.actionType,
      targetUserId: targetUserId is _i1.UuidValue?
          ? targetUserId
          : this.targetUserId,
      targetVendorId: targetVendorId is _i1.UuidValue?
          ? targetVendorId
          : this.targetVendorId,
      targetProductId: targetProductId is int?
          ? targetProductId
          : this.targetProductId,
      targetComplaintId: targetComplaintId is _i1.UuidValue?
          ? targetComplaintId
          : this.targetComplaintId,
      targetPayoutId: targetPayoutId is int?
          ? targetPayoutId
          : this.targetPayoutId,
      targetRefundId: targetRefundId is int?
          ? targetRefundId
          : this.targetRefundId,
      previousStatus: previousStatus is String?
          ? previousStatus
          : this.previousStatus,
      newStatus: newStatus is String? ? newStatus : this.newStatus,
      reason: reason is String? ? reason : this.reason,
      note: note is String? ? note : this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
