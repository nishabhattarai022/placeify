import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:placeify/features/admin/domain/models/vendor_application.dart';

part 'admin_stats.freezed.dart';
part 'admin_stats.g.dart';

/// Aggregated platform metrics for the admin dashboard overview.
@freezed
abstract class AdminStats with _$AdminStats {
  const factory AdminStats({
    required int pendingCount,
    required int approvedCount,
    required int suspendedCount,
    required int totalUsers,
    @Default(<VendorApplication>[]) List<VendorApplication> recentApplications,
  }) = _AdminStats;

  factory AdminStats.fromJson(Map<String, dynamic> json) =>
      _$AdminStatsFromJson(json);
}
