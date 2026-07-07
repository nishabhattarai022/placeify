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
import 'admin_audit_log_summary.dart' as _i2;
import 'vendor_application_summary.dart' as _i3;
import 'package:placeify_server/src/generated/protocol.dart' as _i4;

/// Aggregated platform metrics for the admin dashboard.
abstract class AdminPlatformStats
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AdminPlatformStats._({
    required this.totalVendors,
    required this.totalCustomers,
    required this.pendingCount,
    required this.totalUsers,
    required this.platformGmv,
    required this.approvedCount,
    required this.declinedCount,
    required this.suspendedCount,
    required this.recentActivity,
    required this.signupSeries,
    required this.recentApplications,
  });

  factory AdminPlatformStats({
    required int totalVendors,
    required int totalCustomers,
    required int pendingCount,
    required int totalUsers,
    required double platformGmv,
    required int approvedCount,
    required int declinedCount,
    required int suspendedCount,
    required List<_i2.AdminAuditLogSummary> recentActivity,
    required List<double> signupSeries,
    required List<_i3.VendorApplicationSummary> recentApplications,
  }) = _AdminPlatformStatsImpl;

  factory AdminPlatformStats.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminPlatformStats(
      totalVendors: jsonSerialization['totalVendors'] as int,
      totalCustomers: jsonSerialization['totalCustomers'] as int,
      pendingCount: jsonSerialization['pendingCount'] as int,
      totalUsers: jsonSerialization['totalUsers'] as int,
      platformGmv: (jsonSerialization['platformGmv'] as num).toDouble(),
      approvedCount: jsonSerialization['approvedCount'] as int,
      declinedCount: jsonSerialization['declinedCount'] as int,
      suspendedCount: jsonSerialization['suspendedCount'] as int,
      recentActivity: _i4.Protocol()
          .deserialize<List<_i2.AdminAuditLogSummary>>(
            jsonSerialization['recentActivity'],
          ),
      signupSeries: _i4.Protocol().deserialize<List<double>>(
        jsonSerialization['signupSeries'],
      ),
      recentApplications: _i4.Protocol()
          .deserialize<List<_i3.VendorApplicationSummary>>(
            jsonSerialization['recentApplications'],
          ),
    );
  }

  int totalVendors;

  int totalCustomers;

  int pendingCount;

  int totalUsers;

  double platformGmv;

  int approvedCount;

  int declinedCount;

  int suspendedCount;

  List<_i2.AdminAuditLogSummary> recentActivity;

  List<double> signupSeries;

  List<_i3.VendorApplicationSummary> recentApplications;

  /// Returns a shallow copy of this [AdminPlatformStats]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminPlatformStats copyWith({
    int? totalVendors,
    int? totalCustomers,
    int? pendingCount,
    int? totalUsers,
    double? platformGmv,
    int? approvedCount,
    int? declinedCount,
    int? suspendedCount,
    List<_i2.AdminAuditLogSummary>? recentActivity,
    List<double>? signupSeries,
    List<_i3.VendorApplicationSummary>? recentApplications,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminPlatformStats',
      'totalVendors': totalVendors,
      'totalCustomers': totalCustomers,
      'pendingCount': pendingCount,
      'totalUsers': totalUsers,
      'platformGmv': platformGmv,
      'approvedCount': approvedCount,
      'declinedCount': declinedCount,
      'suspendedCount': suspendedCount,
      'recentActivity': recentActivity.toJson(valueToJson: (v) => v.toJson()),
      'signupSeries': signupSeries.toJson(),
      'recentApplications': recentApplications.toJson(
        valueToJson: (v) => v.toJson(),
      ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminPlatformStats',
      'totalVendors': totalVendors,
      'totalCustomers': totalCustomers,
      'pendingCount': pendingCount,
      'totalUsers': totalUsers,
      'platformGmv': platformGmv,
      'approvedCount': approvedCount,
      'declinedCount': declinedCount,
      'suspendedCount': suspendedCount,
      'recentActivity': recentActivity.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'signupSeries': signupSeries.toJson(),
      'recentApplications': recentApplications.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AdminPlatformStatsImpl extends AdminPlatformStats {
  _AdminPlatformStatsImpl({
    required int totalVendors,
    required int totalCustomers,
    required int pendingCount,
    required int totalUsers,
    required double platformGmv,
    required int approvedCount,
    required int declinedCount,
    required int suspendedCount,
    required List<_i2.AdminAuditLogSummary> recentActivity,
    required List<double> signupSeries,
    required List<_i3.VendorApplicationSummary> recentApplications,
  }) : super._(
         totalVendors: totalVendors,
         totalCustomers: totalCustomers,
         pendingCount: pendingCount,
         totalUsers: totalUsers,
         platformGmv: platformGmv,
         approvedCount: approvedCount,
         declinedCount: declinedCount,
         suspendedCount: suspendedCount,
         recentActivity: recentActivity,
         signupSeries: signupSeries,
         recentApplications: recentApplications,
       );

  /// Returns a shallow copy of this [AdminPlatformStats]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminPlatformStats copyWith({
    int? totalVendors,
    int? totalCustomers,
    int? pendingCount,
    int? totalUsers,
    double? platformGmv,
    int? approvedCount,
    int? declinedCount,
    int? suspendedCount,
    List<_i2.AdminAuditLogSummary>? recentActivity,
    List<double>? signupSeries,
    List<_i3.VendorApplicationSummary>? recentApplications,
  }) {
    return AdminPlatformStats(
      totalVendors: totalVendors ?? this.totalVendors,
      totalCustomers: totalCustomers ?? this.totalCustomers,
      pendingCount: pendingCount ?? this.pendingCount,
      totalUsers: totalUsers ?? this.totalUsers,
      platformGmv: platformGmv ?? this.platformGmv,
      approvedCount: approvedCount ?? this.approvedCount,
      declinedCount: declinedCount ?? this.declinedCount,
      suspendedCount: suspendedCount ?? this.suspendedCount,
      recentActivity:
          recentActivity ??
          this.recentActivity.map((e0) => e0.copyWith()).toList(),
      signupSeries: signupSeries ?? this.signupSeries.map((e0) => e0).toList(),
      recentApplications:
          recentApplications ??
          this.recentApplications.map((e0) => e0.copyWith()).toList(),
    );
  }
}
