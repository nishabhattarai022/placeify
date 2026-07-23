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
  totalTransactions: (json['totalTransactions'] as num?)?.toInt() ?? 0,
  refundCount: (json['refundCount'] as num?)?.toInt() ?? 0,
  refundValue: (json['refundValue'] as num?)?.toDouble() ?? 0,
  pendingRefundCount: (json['pendingRefundCount'] as num?)?.toInt() ?? 0,
  successfulRefundCount: (json['successfulRefundCount'] as num?)?.toInt() ?? 0,
  codCount: (json['codCount'] as num?)?.toInt() ?? 0,
  esewaCount: (json['esewaCount'] as num?)?.toInt() ?? 0,
  paymentSuccessRate: (json['paymentSuccessRate'] as num?)?.toDouble() ?? 0,
  dailyRevenue: (json['dailyRevenue'] as num?)?.toDouble() ?? 0,
  monthlyRevenue: (json['monthlyRevenue'] as num?)?.toDouble() ?? 0,
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
      'totalTransactions': instance.totalTransactions,
      'refundCount': instance.refundCount,
      'refundValue': instance.refundValue,
      'pendingRefundCount': instance.pendingRefundCount,
      'successfulRefundCount': instance.successfulRefundCount,
      'codCount': instance.codCount,
      'esewaCount': instance.esewaCount,
      'paymentSuccessRate': instance.paymentSuccessRate,
      'dailyRevenue': instance.dailyRevenue,
      'monthlyRevenue': instance.monthlyRevenue,
    };
