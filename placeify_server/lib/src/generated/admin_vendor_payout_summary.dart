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
import 'vendor_payout_status.dart' as _i2;

/// Admin view of a vendor payout request.
abstract class AdminVendorPayoutSummary
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AdminVendorPayoutSummary._({
    required this.id,
    required this.vendorId,
    required this.businessName,
    required this.amount,
    required this.status,
    required this.reference,
    required this.payoutMethod,
    this.scheduledAt,
    this.paidAt,
    required this.createdAt,
  });

  factory AdminVendorPayoutSummary({
    required int id,
    required _i1.UuidValue vendorId,
    required String businessName,
    required double amount,
    required _i2.VendorPayoutStatus status,
    required String reference,
    required String payoutMethod,
    DateTime? scheduledAt,
    DateTime? paidAt,
    required DateTime createdAt,
  }) = _AdminVendorPayoutSummaryImpl;

  factory AdminVendorPayoutSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminVendorPayoutSummary(
      id: jsonSerialization['id'] as int,
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      businessName: jsonSerialization['businessName'] as String,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      status: _i2.VendorPayoutStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      reference: jsonSerialization['reference'] as String,
      payoutMethod: jsonSerialization['payoutMethod'] as String,
      scheduledAt: jsonSerialization['scheduledAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['scheduledAt'],
            ),
      paidAt: jsonSerialization['paidAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['paidAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  _i1.UuidValue vendorId;

  String businessName;

  double amount;

  _i2.VendorPayoutStatus status;

  String reference;

  String payoutMethod;

  DateTime? scheduledAt;

  DateTime? paidAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [AdminVendorPayoutSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminVendorPayoutSummary copyWith({
    int? id,
    _i1.UuidValue? vendorId,
    String? businessName,
    double? amount,
    _i2.VendorPayoutStatus? status,
    String? reference,
    String? payoutMethod,
    DateTime? scheduledAt,
    DateTime? paidAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminVendorPayoutSummary',
      'id': id,
      'vendorId': vendorId.toJson(),
      'businessName': businessName,
      'amount': amount,
      'status': status.toJson(),
      'reference': reference,
      'payoutMethod': payoutMethod,
      if (scheduledAt != null) 'scheduledAt': scheduledAt?.toJson(),
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminVendorPayoutSummary',
      'id': id,
      'vendorId': vendorId.toJson(),
      'businessName': businessName,
      'amount': amount,
      'status': status.toJson(),
      'reference': reference,
      'payoutMethod': payoutMethod,
      if (scheduledAt != null) 'scheduledAt': scheduledAt?.toJson(),
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminVendorPayoutSummaryImpl extends AdminVendorPayoutSummary {
  _AdminVendorPayoutSummaryImpl({
    required int id,
    required _i1.UuidValue vendorId,
    required String businessName,
    required double amount,
    required _i2.VendorPayoutStatus status,
    required String reference,
    required String payoutMethod,
    DateTime? scheduledAt,
    DateTime? paidAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         vendorId: vendorId,
         businessName: businessName,
         amount: amount,
         status: status,
         reference: reference,
         payoutMethod: payoutMethod,
         scheduledAt: scheduledAt,
         paidAt: paidAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AdminVendorPayoutSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminVendorPayoutSummary copyWith({
    int? id,
    _i1.UuidValue? vendorId,
    String? businessName,
    double? amount,
    _i2.VendorPayoutStatus? status,
    String? reference,
    String? payoutMethod,
    Object? scheduledAt = _Undefined,
    Object? paidAt = _Undefined,
    DateTime? createdAt,
  }) {
    return AdminVendorPayoutSummary(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      businessName: businessName ?? this.businessName,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      reference: reference ?? this.reference,
      payoutMethod: payoutMethod ?? this.payoutMethod,
      scheduledAt: scheduledAt is DateTime? ? scheduledAt : this.scheduledAt,
      paidAt: paidAt is DateTime? ? paidAt : this.paidAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
