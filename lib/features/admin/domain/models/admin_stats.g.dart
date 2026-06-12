// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminStats _$AdminStatsFromJson(Map<String, dynamic> json) => _AdminStats(
      pendingCount: (json['pendingCount'] as num).toInt(),
      approvedCount: (json['approvedCount'] as num).toInt(),
      suspendedCount: (json['suspendedCount'] as num).toInt(),
      totalUsers: (json['totalUsers'] as num).toInt(),
      recentApplications: (json['recentApplications'] as List<dynamic>?)
              ?.map(
                  (e) => VendorApplication.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <VendorApplication>[],
    );

Map<String, dynamic> _$AdminStatsToJson(_AdminStats instance) =>
    <String, dynamic>{
      'pendingCount': instance.pendingCount,
      'approvedCount': instance.approvedCount,
      'suspendedCount': instance.suspendedCount,
      'totalUsers': instance.totalUsers,
      'recentApplications': instance.recentApplications,
    };
