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
import 'package:placeify_server/src/generated/protocol.dart' as _i3;

/// Aggregated vendor payment balances for the payments dashboard.
abstract class VendorPaymentsOverview
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  VendorPaymentsOverview._({
    required this.payouts,
    required this.pendingBalance,
    required this.totalEarned,
  });

  factory VendorPaymentsOverview({
    required List<_i2.VendorPayoutSummary> payouts,
    required double pendingBalance,
    required double totalEarned,
  }) = _VendorPaymentsOverviewImpl;

  factory VendorPaymentsOverview.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return VendorPaymentsOverview(
      payouts: _i3.Protocol().deserialize<List<_i2.VendorPayoutSummary>>(
        jsonSerialization['payouts'],
      ),
      pendingBalance: (jsonSerialization['pendingBalance'] as num).toDouble(),
      totalEarned: (jsonSerialization['totalEarned'] as num).toDouble(),
    );
  }

  List<_i2.VendorPayoutSummary> payouts;

  double pendingBalance;

  double totalEarned;

  /// Returns a shallow copy of this [VendorPaymentsOverview]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorPaymentsOverview copyWith({
    List<_i2.VendorPayoutSummary>? payouts,
    double? pendingBalance,
    double? totalEarned,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorPaymentsOverview',
      'payouts': payouts.toJson(valueToJson: (v) => v.toJson()),
      'pendingBalance': pendingBalance,
      'totalEarned': totalEarned,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VendorPaymentsOverview',
      'payouts': payouts.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'pendingBalance': pendingBalance,
      'totalEarned': totalEarned,
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
  }) : super._(
         payouts: payouts,
         pendingBalance: pendingBalance,
         totalEarned: totalEarned,
       );

  /// Returns a shallow copy of this [VendorPaymentsOverview]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorPaymentsOverview copyWith({
    List<_i2.VendorPayoutSummary>? payouts,
    double? pendingBalance,
    double? totalEarned,
  }) {
    return VendorPaymentsOverview(
      payouts: payouts ?? this.payouts.map((e0) => e0.copyWith()).toList(),
      pendingBalance: pendingBalance ?? this.pendingBalance,
      totalEarned: totalEarned ?? this.totalEarned,
    );
  }
}
