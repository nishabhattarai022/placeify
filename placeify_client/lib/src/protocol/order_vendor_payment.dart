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
import 'payment_transaction_status.dart' as _i2;
import 'order.dart' as _i3;
import 'vendor.dart' as _i4;
import 'package:placeify_client/src/protocol/protocol.dart' as _i5;

/// Per-vendor payment allocation for a multi-vendor order.
abstract class OrderVendorPayment implements _i1.SerializableModel {
  OrderVendorPayment._({
    this.id,
    required this.orderId,
    this.order,
    required this.vendorId,
    this.vendor,
    required this.amount,
    _i2.PaymentTransactionStatus? status,
    this.note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? _i2.PaymentTransactionStatus.pending,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory OrderVendorPayment({
    int? id,
    required int orderId,
    _i3.Order? order,
    required _i1.UuidValue vendorId,
    _i4.Vendor? vendor,
    required double amount,
    _i2.PaymentTransactionStatus? status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _OrderVendorPaymentImpl;

  factory OrderVendorPayment.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderVendorPayment(
      id: jsonSerialization['id'] as int?,
      orderId: jsonSerialization['orderId'] as int,
      order: jsonSerialization['order'] == null
          ? null
          : _i5.Protocol().deserialize<_i3.Order>(jsonSerialization['order']),
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      vendor: jsonSerialization['vendor'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.Vendor>(jsonSerialization['vendor']),
      amount: (jsonSerialization['amount'] as num).toDouble(),
      status: jsonSerialization['status'] == null
          ? null
          : _i2.PaymentTransactionStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      note: jsonSerialization['note'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int orderId;

  _i3.Order? order;

  _i1.UuidValue vendorId;

  _i4.Vendor? vendor;

  double amount;

  _i2.PaymentTransactionStatus status;

  String? note;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [OrderVendorPayment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderVendorPayment copyWith({
    int? id,
    int? orderId,
    _i3.Order? order,
    _i1.UuidValue? vendorId,
    _i4.Vendor? vendor,
    double? amount,
    _i2.PaymentTransactionStatus? status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderVendorPayment',
      if (id != null) 'id': id,
      'orderId': orderId,
      if (order != null) 'order': order?.toJson(),
      'vendorId': vendorId.toJson(),
      if (vendor != null) 'vendor': vendor?.toJson(),
      'amount': amount,
      'status': status.toJson(),
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderVendorPaymentImpl extends OrderVendorPayment {
  _OrderVendorPaymentImpl({
    int? id,
    required int orderId,
    _i3.Order? order,
    required _i1.UuidValue vendorId,
    _i4.Vendor? vendor,
    required double amount,
    _i2.PaymentTransactionStatus? status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         orderId: orderId,
         order: order,
         vendorId: vendorId,
         vendor: vendor,
         amount: amount,
         status: status,
         note: note,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [OrderVendorPayment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderVendorPayment copyWith({
    Object? id = _Undefined,
    int? orderId,
    Object? order = _Undefined,
    _i1.UuidValue? vendorId,
    Object? vendor = _Undefined,
    double? amount,
    _i2.PaymentTransactionStatus? status,
    Object? note = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderVendorPayment(
      id: id is int? ? id : this.id,
      orderId: orderId ?? this.orderId,
      order: order is _i3.Order? ? order : this.order?.copyWith(),
      vendorId: vendorId ?? this.vendorId,
      vendor: vendor is _i4.Vendor? ? vendor : this.vendor?.copyWith(),
      amount: amount ?? this.amount,
      status: status ?? this.status,
      note: note is String? ? note : this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
