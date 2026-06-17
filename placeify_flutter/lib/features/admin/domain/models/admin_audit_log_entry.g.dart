// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_audit_log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationAuditAction _$ApplicationAuditActionFromJson(
  Map<String, dynamic> json,
) => ApplicationAuditAction(
  decision: $enumDecode(_$ApplicationDecisionEnumMap, json['decision']),
  $type: json['kind'] as String?,
);

Map<String, dynamic> _$ApplicationAuditActionToJson(
  ApplicationAuditAction instance,
) => <String, dynamic>{
  'decision': _$ApplicationDecisionEnumMap[instance.decision]!,
  'kind': instance.$type,
};

const _$ApplicationDecisionEnumMap = {
  ApplicationDecision.approved: 'approved',
  ApplicationDecision.declined: 'declined',
};

VendorAuditAction _$VendorAuditActionFromJson(Map<String, dynamic> json) =>
    VendorAuditAction(
      action: $enumDecode(_$AuditActionEnumMap, json['action']),
      $type: json['kind'] as String?,
    );

Map<String, dynamic> _$VendorAuditActionToJson(VendorAuditAction instance) =>
    <String, dynamic>{
      'action': _$AuditActionEnumMap[instance.action]!,
      'kind': instance.$type,
    };

const _$AuditActionEnumMap = {
  AuditAction.suspended: 'suspended',
  AuditAction.reinstated: 'reinstated',
};

_AdminAuditLogEntry _$AdminAuditLogEntryFromJson(Map<String, dynamic> json) =>
    _AdminAuditLogEntry(
      id: json['id'] as String,
      action: AdminAuditAction.fromJson(json['action'] as Map<String, dynamic>),
      actorAdminId: json['actorAdminId'] as String,
      targetUserId: json['targetUserId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$AdminAuditLogEntryToJson(_AdminAuditLogEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'actorAdminId': instance.actorAdminId,
      'targetUserId': instance.targetUserId,
      'timestamp': instance.timestamp.toIso8601String(),
      'note': instance.note,
    };
