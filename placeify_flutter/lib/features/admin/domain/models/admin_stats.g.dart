// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminStats _$AdminStatsFromJson(Map<String, dynamic> json) => _AdminStats(
  totalVendors: (json['totalVendors'] as num).toInt(),
  pendingCount: (json['pendingCount'] as num).toInt(),
  totalUsers: (json['totalUsers'] as num).toInt(),
  platformGmv: (json['platformGmv'] as num).toDouble(),
  approvedCount: (json['approvedCount'] as num).toInt(),
  declinedCount: (json['declinedCount'] as num).toInt(),
  suspendedCount: (json['suspendedCount'] as num).toInt(),
  recentActivity:
      (json['recentActivity'] as List<dynamic>?)
          ?.map((e) => AdminAuditLogEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AdminAuditLogEntry>[],
  recentApplications:
      (json['recentApplications'] as List<dynamic>?)
          ?.map((e) => VendorApplication.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <VendorApplication>[],
);

Map<String, dynamic> _$AdminStatsToJson(_AdminStats instance) =>
    <String, dynamic>{
      'totalVendors': instance.totalVendors,
      'pendingCount': instance.pendingCount,
      'totalUsers': instance.totalUsers,
      'platformGmv': instance.platformGmv,
      'approvedCount': instance.approvedCount,
      'declinedCount': instance.declinedCount,
      'suspendedCount': instance.suspendedCount,
      'recentActivity': instance.recentActivity,
      'recentApplications': instance.recentApplications,
    };
