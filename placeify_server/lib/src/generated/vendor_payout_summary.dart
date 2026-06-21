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

/// Vendor payout row for the payments screen.
abstract class VendorPayoutSummary
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  VendorPayoutSummary._({
    required this.id,
    required this.amount,
    required this.status,
    this.paidAt,
    required this.reference,
    required this.createdAt,
  });

  factory VendorPayoutSummary({
    required int id,
    required double amount,
    required _i2.VendorPayoutStatus status,
    DateTime? paidAt,
    required String reference,
    required DateTime createdAt,
  }) = _VendorPayoutSummaryImpl;

  factory VendorPayoutSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return VendorPayoutSummary(
      id: jsonSerialization['id'] as int,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      status: _i2.VendorPayoutStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      paidAt: jsonSerialization['paidAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['paidAt']),
      reference: jsonSerialization['reference'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  double amount;

  _i2.VendorPayoutStatus status;

  DateTime? paidAt;

  String reference;

  DateTime createdAt;

  /// Returns a shallow copy of this [VendorPayoutSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorPayoutSummary copyWith({
    int? id,
    double? amount,
    _i2.VendorPayoutStatus? status,
    DateTime? paidAt,
    String? reference,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorPayoutSummary',
      'id': id,
      'amount': amount,
      'status': status.toJson(),
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
      'reference': reference,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VendorPayoutSummary',
      'id': id,
      'amount': amount,
      'status': status.toJson(),
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
      'reference': reference,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorPayoutSummaryImpl extends VendorPayoutSummary {
  _VendorPayoutSummaryImpl({
    required int id,
    required double amount,
    required _i2.VendorPayoutStatus status,
    DateTime? paidAt,
    required String reference,
    required DateTime createdAt,
  }) : super._(
         id: id,
         amount: amount,
         status: status,
         paidAt: paidAt,
         reference: reference,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [VendorPayoutSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorPayoutSummary copyWith({
    int? id,
    double? amount,
    _i2.VendorPayoutStatus? status,
    Object? paidAt = _Undefined,
    String? reference,
    DateTime? createdAt,
  }) {
    return VendorPayoutSummary(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      paidAt: paidAt is DateTime? ? paidAt : this.paidAt,
      reference: reference ?? this.reference,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
