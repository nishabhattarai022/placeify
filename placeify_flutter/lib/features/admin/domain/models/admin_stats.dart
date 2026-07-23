import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:placeify_flutter/features/admin/domain/models/admin_audit_log_entry.dart';
import 'package:placeify_flutter/features/admin/domain/models/vendor_application.dart';

part 'admin_stats.freezed.dart';
part 'admin_stats.g.dart';

/// Aggregated platform metrics for the admin dashboard overview.
@freezed
abstract class AdminStats with _$AdminStats {
  const factory AdminStats({
    required int totalVendors,
    required int pendingCount,
    required int totalUsers,
    required double platformGmv,
    required int approvedCount,
    required int declinedCount,
    required int suspendedCount,
    @Default(<AdminAuditLogEntry>[]) List<AdminAuditLogEntry> recentActivity,
    @Default(<VendorApplication>[]) List<VendorApplication> recentApplications,
    @Default(0) int totalTransactions,
    @Default(0) int refundCount,
    @Default(0) double refundValue,
    @Default(0) int pendingRefundCount,
    @Default(0) int successfulRefundCount,
    @Default(0) int codCount,
    @Default(0) int esewaCount,
    @Default(0) double paymentSuccessRate,
    @Default(0) double dailyRevenue,
    @Default(0) double monthlyRevenue,
  }) = _AdminStats;

  factory AdminStats.fromJson(Map<String, dynamic> json) =>
      _$AdminStatsFromJson(json);
}
