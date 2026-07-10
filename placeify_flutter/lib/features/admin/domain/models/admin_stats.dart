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
  }) = _AdminStats;

  factory AdminStats.fromJson(Map<String, dynamic> json) =>
      _$AdminStatsFromJson(json);
}
