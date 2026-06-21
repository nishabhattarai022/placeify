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
import 'vendor_payout_status.dart' as _i2;
import 'vendor.dart' as _i3;
import 'package:placeify_client/src/protocol/protocol.dart' as _i4;

/// Vendor settlement payout request.
abstract class VendorPayout implements _i1.SerializableModel {
  VendorPayout._({
    this.id,
    required this.vendorId,
    this.vendor,
    required this.amount,
    _i2.VendorPayoutStatus? status,
    required this.payoutMethod,
    required this.reference,
    this.scheduledAt,
    this.paidAt,
    DateTime? createdAt,
  }) : status = status ?? _i2.VendorPayoutStatus.pending,
       createdAt = createdAt ?? DateTime.now();

  factory VendorPayout({
    int? id,
    required _i1.UuidValue vendorId,
    _i3.Vendor? vendor,
    required double amount,
    _i2.VendorPayoutStatus? status,
    required String payoutMethod,
    required String reference,
    DateTime? scheduledAt,
    DateTime? paidAt,
    DateTime? createdAt,
  }) = _VendorPayoutImpl;

  factory VendorPayout.fromJson(Map<String, dynamic> jsonSerialization) {
    return VendorPayout(
      id: jsonSerialization['id'] as int?,
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      vendor: jsonSerialization['vendor'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.Vendor>(jsonSerialization['vendor']),
      amount: (jsonSerialization['amount'] as num).toDouble(),
      status: jsonSerialization['status'] == null
          ? null
          : _i2.VendorPayoutStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      payoutMethod: jsonSerialization['payoutMethod'] as String,
      reference: jsonSerialization['reference'] as String,
      scheduledAt: jsonSerialization['scheduledAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['scheduledAt'],
            ),
      paidAt: jsonSerialization['paidAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['paidAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue vendorId;

  _i3.Vendor? vendor;

  double amount;

  _i2.VendorPayoutStatus status;

  String payoutMethod;

  String reference;

  DateTime? scheduledAt;

  DateTime? paidAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [VendorPayout]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorPayout copyWith({
    int? id,
    _i1.UuidValue? vendorId,
    _i3.Vendor? vendor,
    double? amount,
    _i2.VendorPayoutStatus? status,
    String? payoutMethod,
    String? reference,
    DateTime? scheduledAt,
    DateTime? paidAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorPayout',
      if (id != null) 'id': id,
      'vendorId': vendorId.toJson(),
      if (vendor != null) 'vendor': vendor?.toJson(),
      'amount': amount,
      'status': status.toJson(),
      'payoutMethod': payoutMethod,
      'reference': reference,
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

class _VendorPayoutImpl extends VendorPayout {
  _VendorPayoutImpl({
    int? id,
    required _i1.UuidValue vendorId,
    _i3.Vendor? vendor,
    required double amount,
    _i2.VendorPayoutStatus? status,
    required String payoutMethod,
    required String reference,
    DateTime? scheduledAt,
    DateTime? paidAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         vendorId: vendorId,
         vendor: vendor,
         amount: amount,
         status: status,
         payoutMethod: payoutMethod,
         reference: reference,
         scheduledAt: scheduledAt,
         paidAt: paidAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [VendorPayout]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorPayout copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? vendorId,
    Object? vendor = _Undefined,
    double? amount,
    _i2.VendorPayoutStatus? status,
    String? payoutMethod,
    String? reference,
    Object? scheduledAt = _Undefined,
    Object? paidAt = _Undefined,
    DateTime? createdAt,
  }) {
    return VendorPayout(
      id: id is int? ? id : this.id,
      vendorId: vendorId ?? this.vendorId,
      vendor: vendor is _i3.Vendor? ? vendor : this.vendor?.copyWith(),
      amount: amount ?? this.amount,
      status: status ?? this.status,
      payoutMethod: payoutMethod ?? this.payoutMethod,
      reference: reference ?? this.reference,
      scheduledAt: scheduledAt is DateTime? ? scheduledAt : this.scheduledAt,
      paidAt: paidAt is DateTime? ? paidAt : this.paidAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
