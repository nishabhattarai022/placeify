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

/// Recent admin moderation activity for the dashboard.
abstract class AdminAuditLogSummary
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AdminAuditLogSummary._({
    required this.id,
    required this.actionType,
    required this.actorAdminId,
    required this.targetUserId,
    required this.timestamp,
    this.note,
  });

  factory AdminAuditLogSummary({
    required String id,
    required String actionType,
    required _i1.UuidValue actorAdminId,
    required _i1.UuidValue targetUserId,
    required DateTime timestamp,
    String? note,
  }) = _AdminAuditLogSummaryImpl;

  factory AdminAuditLogSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminAuditLogSummary(
      id: jsonSerialization['id'] as String,
      actionType: jsonSerialization['actionType'] as String,
      actorAdminId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['actorAdminId'],
      ),
      targetUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['targetUserId'],
      ),
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      note: jsonSerialization['note'] as String?,
    );
  }

  String id;

  String actionType;

  _i1.UuidValue actorAdminId;

  _i1.UuidValue targetUserId;

  DateTime timestamp;

  String? note;

  /// Returns a shallow copy of this [AdminAuditLogSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminAuditLogSummary copyWith({
    String? id,
    String? actionType,
    _i1.UuidValue? actorAdminId,
    _i1.UuidValue? targetUserId,
    DateTime? timestamp,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminAuditLogSummary',
      'id': id,
      'actionType': actionType,
      'actorAdminId': actorAdminId.toJson(),
      'targetUserId': targetUserId.toJson(),
      'timestamp': timestamp.toJson(),
      if (note != null) 'note': note,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminAuditLogSummary',
      'id': id,
      'actionType': actionType,
      'actorAdminId': actorAdminId.toJson(),
      'targetUserId': targetUserId.toJson(),
      'timestamp': timestamp.toJson(),
      if (note != null) 'note': note,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminAuditLogSummaryImpl extends AdminAuditLogSummary {
  _AdminAuditLogSummaryImpl({
    required String id,
    required String actionType,
    required _i1.UuidValue actorAdminId,
    required _i1.UuidValue targetUserId,
    required DateTime timestamp,
    String? note,
  }) : super._(
         id: id,
         actionType: actionType,
         actorAdminId: actorAdminId,
         targetUserId: targetUserId,
         timestamp: timestamp,
         note: note,
       );

  /// Returns a shallow copy of this [AdminAuditLogSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminAuditLogSummary copyWith({
    String? id,
    String? actionType,
    _i1.UuidValue? actorAdminId,
    _i1.UuidValue? targetUserId,
    DateTime? timestamp,
    Object? note = _Undefined,
  }) {
    return AdminAuditLogSummary(
      id: id ?? this.id,
      actionType: actionType ?? this.actionType,
      actorAdminId: actorAdminId ?? this.actorAdminId,
      targetUserId: targetUserId ?? this.targetUserId,
      timestamp: timestamp ?? this.timestamp,
      note: note is String? ? note : this.note,
    );
  }
}
