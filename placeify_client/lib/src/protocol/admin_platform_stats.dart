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
import 'admin_audit_log_summary.dart' as _i2;
import 'vendor_application_summary.dart' as _i3;
import 'package:placeify_client/src/protocol/protocol.dart' as _i4;

/// Aggregated platform metrics for the admin dashboard.
abstract class AdminPlatformStats implements _i1.SerializableModel {
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
    int? totalTransactions,
    int? refundCount,
    double? refundValue,
    int? pendingRefundCount,
    int? successfulRefundCount,
    int? codCount,
    int? esewaCount,
    double? paymentSuccessRate,
    double? dailyRevenue,
    double? monthlyRevenue,
  }) : totalTransactions = totalTransactions ?? 0,
       refundCount = refundCount ?? 0,
       refundValue = refundValue ?? 0.0,
       pendingRefundCount = pendingRefundCount ?? 0,
       successfulRefundCount = successfulRefundCount ?? 0,
       codCount = codCount ?? 0,
       esewaCount = esewaCount ?? 0,
       paymentSuccessRate = paymentSuccessRate ?? 0.0,
       dailyRevenue = dailyRevenue ?? 0.0,
       monthlyRevenue = monthlyRevenue ?? 0.0;

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
    int? totalTransactions,
    int? refundCount,
    double? refundValue,
    int? pendingRefundCount,
    int? successfulRefundCount,
    int? codCount,
    int? esewaCount,
    double? paymentSuccessRate,
    double? dailyRevenue,
    double? monthlyRevenue,
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
      totalTransactions: jsonSerialization['totalTransactions'] as int?,
      refundCount: jsonSerialization['refundCount'] as int?,
      refundValue: (jsonSerialization['refundValue'] as num?)?.toDouble(),
      pendingRefundCount: jsonSerialization['pendingRefundCount'] as int?,
      successfulRefundCount: jsonSerialization['successfulRefundCount'] as int?,
      codCount: jsonSerialization['codCount'] as int?,
      esewaCount: jsonSerialization['esewaCount'] as int?,
      paymentSuccessRate: (jsonSerialization['paymentSuccessRate'] as num?)
          ?.toDouble(),
      dailyRevenue: (jsonSerialization['dailyRevenue'] as num?)?.toDouble(),
      monthlyRevenue: (jsonSerialization['monthlyRevenue'] as num?)?.toDouble(),
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

  /// Payment ledger aggregates (PostgreSQL).
  int totalTransactions;

  int refundCount;

  double refundValue;

  int pendingRefundCount;

  int successfulRefundCount;

  int codCount;

  int esewaCount;

  double paymentSuccessRate;

  double dailyRevenue;

  double monthlyRevenue;

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
    int? totalTransactions,
    int? refundCount,
    double? refundValue,
    int? pendingRefundCount,
    int? successfulRefundCount,
    int? codCount,
    int? esewaCount,
    double? paymentSuccessRate,
    double? dailyRevenue,
    double? monthlyRevenue,
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
      'totalTransactions': totalTransactions,
      'refundCount': refundCount,
      'refundValue': refundValue,
      'pendingRefundCount': pendingRefundCount,
      'successfulRefundCount': successfulRefundCount,
      'codCount': codCount,
      'esewaCount': esewaCount,
      'paymentSuccessRate': paymentSuccessRate,
      'dailyRevenue': dailyRevenue,
      'monthlyRevenue': monthlyRevenue,
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
    int? totalTransactions,
    int? refundCount,
    double? refundValue,
    int? pendingRefundCount,
    int? successfulRefundCount,
    int? codCount,
    int? esewaCount,
    double? paymentSuccessRate,
    double? dailyRevenue,
    double? monthlyRevenue,
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
         totalTransactions: totalTransactions,
         refundCount: refundCount,
         refundValue: refundValue,
         pendingRefundCount: pendingRefundCount,
         successfulRefundCount: successfulRefundCount,
         codCount: codCount,
         esewaCount: esewaCount,
         paymentSuccessRate: paymentSuccessRate,
         dailyRevenue: dailyRevenue,
         monthlyRevenue: monthlyRevenue,
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
    int? totalTransactions,
    int? refundCount,
    double? refundValue,
    int? pendingRefundCount,
    int? successfulRefundCount,
    int? codCount,
    int? esewaCount,
    double? paymentSuccessRate,
    double? dailyRevenue,
    double? monthlyRevenue,
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
      totalTransactions: totalTransactions ?? this.totalTransactions,
      refundCount: refundCount ?? this.refundCount,
      refundValue: refundValue ?? this.refundValue,
      pendingRefundCount: pendingRefundCount ?? this.pendingRefundCount,
      successfulRefundCount:
          successfulRefundCount ?? this.successfulRefundCount,
      codCount: codCount ?? this.codCount,
      esewaCount: esewaCount ?? this.esewaCount,
      paymentSuccessRate: paymentSuccessRate ?? this.paymentSuccessRate,
      dailyRevenue: dailyRevenue ?? this.dailyRevenue,
      monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
    );
  }
}
