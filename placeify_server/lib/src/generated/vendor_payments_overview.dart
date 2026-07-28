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
import 'vendor_payout_summary.dart' as _i2;
import 'payment_update_summary.dart' as _i3;
import 'package:placeify_server/src/generated/protocol.dart' as _i4;

/// Aggregated vendor payment balances for the payments dashboard.
abstract class VendorPaymentsOverview
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  VendorPaymentsOverview._({
    required this.payouts,
    required this.pendingBalance,
    required this.totalEarned,
    required this.pendingPaymentCount,
    required this.paymentHistory,
    double? todayRevenue,
    double? monthlyRevenue,
    double? refundAmount,
    int? refundCount,
    int? successfulPaymentCount,
    int? codPaymentCount,
    int? esewaPaymentCount,
    double? averageOrderValue,
    int? pendingRefundCount,
  }) : todayRevenue = todayRevenue ?? 0.0,
       monthlyRevenue = monthlyRevenue ?? 0.0,
       refundAmount = refundAmount ?? 0.0,
       refundCount = refundCount ?? 0,
       successfulPaymentCount = successfulPaymentCount ?? 0,
       codPaymentCount = codPaymentCount ?? 0,
       esewaPaymentCount = esewaPaymentCount ?? 0,
       averageOrderValue = averageOrderValue ?? 0.0,
       pendingRefundCount = pendingRefundCount ?? 0;

  factory VendorPaymentsOverview({
    required List<_i2.VendorPayoutSummary> payouts,
    required double pendingBalance,
    required double totalEarned,
    required int pendingPaymentCount,
    required List<_i3.PaymentUpdateSummary> paymentHistory,
    double? todayRevenue,
    double? monthlyRevenue,
    double? refundAmount,
    int? refundCount,
    int? successfulPaymentCount,
    int? codPaymentCount,
    int? esewaPaymentCount,
    double? averageOrderValue,
    int? pendingRefundCount,
  }) = _VendorPaymentsOverviewImpl;

  factory VendorPaymentsOverview.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return VendorPaymentsOverview(
      payouts: _i4.Protocol().deserialize<List<_i2.VendorPayoutSummary>>(
        jsonSerialization['payouts'],
      ),
      pendingBalance: (jsonSerialization['pendingBalance'] as num).toDouble(),
      totalEarned: (jsonSerialization['totalEarned'] as num).toDouble(),
      pendingPaymentCount: jsonSerialization['pendingPaymentCount'] as int,
      paymentHistory: _i4.Protocol()
          .deserialize<List<_i3.PaymentUpdateSummary>>(
            jsonSerialization['paymentHistory'],
          ),
      todayRevenue: (jsonSerialization['todayRevenue'] as num?)?.toDouble(),
      monthlyRevenue: (jsonSerialization['monthlyRevenue'] as num?)?.toDouble(),
      refundAmount: (jsonSerialization['refundAmount'] as num?)?.toDouble(),
      refundCount: jsonSerialization['refundCount'] as int?,
      successfulPaymentCount:
          jsonSerialization['successfulPaymentCount'] as int?,
      codPaymentCount: jsonSerialization['codPaymentCount'] as int?,
      esewaPaymentCount: jsonSerialization['esewaPaymentCount'] as int?,
      averageOrderValue: (jsonSerialization['averageOrderValue'] as num?)
          ?.toDouble(),
      pendingRefundCount: jsonSerialization['pendingRefundCount'] as int?,
    );
  }

  List<_i2.VendorPayoutSummary> payouts;

  double pendingBalance;

  double totalEarned;

  /// Count of OrderVendorPayment rows still pending for this vendor.
  int pendingPaymentCount;

  /// Customer payments (COD + eSewa) for this vendor shop.
  List<_i3.PaymentUpdateSummary> paymentHistory;

  /// Analytics (PostgreSQL aggregates).
  double todayRevenue;

  double monthlyRevenue;

  double refundAmount;

  int refundCount;

  int successfulPaymentCount;

  int codPaymentCount;

  int esewaPaymentCount;

  double averageOrderValue;

  int pendingRefundCount;

  /// Returns a shallow copy of this [VendorPaymentsOverview]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorPaymentsOverview copyWith({
    List<_i2.VendorPayoutSummary>? payouts,
    double? pendingBalance,
    double? totalEarned,
    int? pendingPaymentCount,
    List<_i3.PaymentUpdateSummary>? paymentHistory,
    double? todayRevenue,
    double? monthlyRevenue,
    double? refundAmount,
    int? refundCount,
    int? successfulPaymentCount,
    int? codPaymentCount,
    int? esewaPaymentCount,
    double? averageOrderValue,
    int? pendingRefundCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorPaymentsOverview',
      'payouts': payouts.toJson(valueToJson: (v) => v.toJson()),
      'pendingBalance': pendingBalance,
      'totalEarned': totalEarned,
      'pendingPaymentCount': pendingPaymentCount,
      'paymentHistory': paymentHistory.toJson(valueToJson: (v) => v.toJson()),
      'todayRevenue': todayRevenue,
      'monthlyRevenue': monthlyRevenue,
      'refundAmount': refundAmount,
      'refundCount': refundCount,
      'successfulPaymentCount': successfulPaymentCount,
      'codPaymentCount': codPaymentCount,
      'esewaPaymentCount': esewaPaymentCount,
      'averageOrderValue': averageOrderValue,
      'pendingRefundCount': pendingRefundCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VendorPaymentsOverview',
      'payouts': payouts.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'pendingBalance': pendingBalance,
      'totalEarned': totalEarned,
      'pendingPaymentCount': pendingPaymentCount,
      'paymentHistory': paymentHistory.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'todayRevenue': todayRevenue,
      'monthlyRevenue': monthlyRevenue,
      'refundAmount': refundAmount,
      'refundCount': refundCount,
      'successfulPaymentCount': successfulPaymentCount,
      'codPaymentCount': codPaymentCount,
      'esewaPaymentCount': esewaPaymentCount,
      'averageOrderValue': averageOrderValue,
      'pendingRefundCount': pendingRefundCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _VendorPaymentsOverviewImpl extends VendorPaymentsOverview {
  _VendorPaymentsOverviewImpl({
    required List<_i2.VendorPayoutSummary> payouts,
    required double pendingBalance,
    required double totalEarned,
    required int pendingPaymentCount,
    required List<_i3.PaymentUpdateSummary> paymentHistory,
    double? todayRevenue,
    double? monthlyRevenue,
    double? refundAmount,
    int? refundCount,
    int? successfulPaymentCount,
    int? codPaymentCount,
    int? esewaPaymentCount,
    double? averageOrderValue,
    int? pendingRefundCount,
  }) : super._(
         payouts: payouts,
         pendingBalance: pendingBalance,
         totalEarned: totalEarned,
         pendingPaymentCount: pendingPaymentCount,
         paymentHistory: paymentHistory,
         todayRevenue: todayRevenue,
         monthlyRevenue: monthlyRevenue,
         refundAmount: refundAmount,
         refundCount: refundCount,
         successfulPaymentCount: successfulPaymentCount,
         codPaymentCount: codPaymentCount,
         esewaPaymentCount: esewaPaymentCount,
         averageOrderValue: averageOrderValue,
         pendingRefundCount: pendingRefundCount,
       );

  /// Returns a shallow copy of this [VendorPaymentsOverview]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorPaymentsOverview copyWith({
    List<_i2.VendorPayoutSummary>? payouts,
    double? pendingBalance,
    double? totalEarned,
    int? pendingPaymentCount,
    List<_i3.PaymentUpdateSummary>? paymentHistory,
    double? todayRevenue,
    double? monthlyRevenue,
    double? refundAmount,
    int? refundCount,
    int? successfulPaymentCount,
    int? codPaymentCount,
    int? esewaPaymentCount,
    double? averageOrderValue,
    int? pendingRefundCount,
  }) {
    return VendorPaymentsOverview(
      payouts: payouts ?? this.payouts.map((e0) => e0.copyWith()).toList(),
      pendingBalance: pendingBalance ?? this.pendingBalance,
      totalEarned: totalEarned ?? this.totalEarned,
      pendingPaymentCount: pendingPaymentCount ?? this.pendingPaymentCount,
      paymentHistory:
          paymentHistory ??
          this.paymentHistory.map((e0) => e0.copyWith()).toList(),
      todayRevenue: todayRevenue ?? this.todayRevenue,
      monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
      refundAmount: refundAmount ?? this.refundAmount,
      refundCount: refundCount ?? this.refundCount,
      successfulPaymentCount:
          successfulPaymentCount ?? this.successfulPaymentCount,
      codPaymentCount: codPaymentCount ?? this.codPaymentCount,
      esewaPaymentCount: esewaPaymentCount ?? this.esewaPaymentCount,
      averageOrderValue: averageOrderValue ?? this.averageOrderValue,
      pendingRefundCount: pendingRefundCount ?? this.pendingRefundCount,
    );
  }
}
