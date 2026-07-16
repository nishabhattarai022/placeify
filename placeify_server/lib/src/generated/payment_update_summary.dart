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
import 'payment_transaction_status.dart' as _i2;
import 'payment_method.dart' as _i3;

/// Payment status update for a vendor order audit trail.
abstract class PaymentUpdateSummary
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PaymentUpdateSummary._({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.status,
    required this.note,
    required this.updatedAt,
    this.paymentMethod,
    this.customerName,
  });

  factory PaymentUpdateSummary({
    required int id,
    required int orderId,
    required double amount,
    required _i2.PaymentTransactionStatus status,
    required String note,
    required DateTime updatedAt,
    _i3.PaymentMethod? paymentMethod,
    String? customerName,
  }) = _PaymentUpdateSummaryImpl;

  factory PaymentUpdateSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PaymentUpdateSummary(
      id: jsonSerialization['id'] as int,
      orderId: jsonSerialization['orderId'] as int,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      status: _i2.PaymentTransactionStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      note: jsonSerialization['note'] as String,
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      paymentMethod: jsonSerialization['paymentMethod'] == null
          ? null
          : _i3.PaymentMethod.fromJson(
              (jsonSerialization['paymentMethod'] as String),
            ),
      customerName: jsonSerialization['customerName'] as String?,
    );
  }

  int id;

  int orderId;

  double amount;

  _i2.PaymentTransactionStatus status;

  String note;

  DateTime updatedAt;

  /// Optional listing fields (vendor payment history).
  _i3.PaymentMethod? paymentMethod;

  String? customerName;

  /// Returns a shallow copy of this [PaymentUpdateSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaymentUpdateSummary copyWith({
    int? id,
    int? orderId,
    double? amount,
    _i2.PaymentTransactionStatus? status,
    String? note,
    DateTime? updatedAt,
    _i3.PaymentMethod? paymentMethod,
    String? customerName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentUpdateSummary',
      'id': id,
      'orderId': orderId,
      'amount': amount,
      'status': status.toJson(),
      'note': note,
      'updatedAt': updatedAt.toJson(),
      if (paymentMethod != null) 'paymentMethod': paymentMethod?.toJson(),
      if (customerName != null) 'customerName': customerName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PaymentUpdateSummary',
      'id': id,
      'orderId': orderId,
      'amount': amount,
      'status': status.toJson(),
      'note': note,
      'updatedAt': updatedAt.toJson(),
      if (paymentMethod != null) 'paymentMethod': paymentMethod?.toJson(),
      if (customerName != null) 'customerName': customerName,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaymentUpdateSummaryImpl extends PaymentUpdateSummary {
  _PaymentUpdateSummaryImpl({
    required int id,
    required int orderId,
    required double amount,
    required _i2.PaymentTransactionStatus status,
    required String note,
    required DateTime updatedAt,
    _i3.PaymentMethod? paymentMethod,
    String? customerName,
  }) : super._(
         id: id,
         orderId: orderId,
         amount: amount,
         status: status,
         note: note,
         updatedAt: updatedAt,
         paymentMethod: paymentMethod,
         customerName: customerName,
       );

  /// Returns a shallow copy of this [PaymentUpdateSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaymentUpdateSummary copyWith({
    int? id,
    int? orderId,
    double? amount,
    _i2.PaymentTransactionStatus? status,
    String? note,
    DateTime? updatedAt,
    Object? paymentMethod = _Undefined,
    Object? customerName = _Undefined,
  }) {
    return PaymentUpdateSummary(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
      paymentMethod: paymentMethod is _i3.PaymentMethod?
          ? paymentMethod
          : this.paymentMethod,
      customerName: customerName is String? ? customerName : this.customerName,
    );
  }
}
