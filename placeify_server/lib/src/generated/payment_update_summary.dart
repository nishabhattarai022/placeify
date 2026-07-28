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

/// Payment status update for a vendor order audit trail / payment ledger row.
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
    this.customerEmail,
    this.orderNumber,
    this.orderStatus,
    this.transactionId,
    this.providerTransactionId,
    this.deliveryFee,
    this.discount,
    this.vendorEarnings,
    this.refundStatus,
    this.refundDate,
    this.createdAt,
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
    String? customerEmail,
    String? orderNumber,
    String? orderStatus,
    String? transactionId,
    String? providerTransactionId,
    double? deliveryFee,
    double? discount,
    double? vendorEarnings,
    String? refundStatus,
    DateTime? refundDate,
    DateTime? createdAt,
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
      customerEmail: jsonSerialization['customerEmail'] as String?,
      orderNumber: jsonSerialization['orderNumber'] as String?,
      orderStatus: jsonSerialization['orderStatus'] as String?,
      transactionId: jsonSerialization['transactionId'] as String?,
      providerTransactionId:
          jsonSerialization['providerTransactionId'] as String?,
      deliveryFee: (jsonSerialization['deliveryFee'] as num?)?.toDouble(),
      discount: (jsonSerialization['discount'] as num?)?.toDouble(),
      vendorEarnings: (jsonSerialization['vendorEarnings'] as num?)?.toDouble(),
      refundStatus: jsonSerialization['refundStatus'] as String?,
      refundDate: jsonSerialization['refundDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['refundDate']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
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

  String? customerEmail;

  String? orderNumber;

  String? orderStatus;

  String? transactionId;

  String? providerTransactionId;

  double? deliveryFee;

  double? discount;

  double? vendorEarnings;

  String? refundStatus;

  DateTime? refundDate;

  DateTime? createdAt;

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
    String? customerEmail,
    String? orderNumber,
    String? orderStatus,
    String? transactionId,
    String? providerTransactionId,
    double? deliveryFee,
    double? discount,
    double? vendorEarnings,
    String? refundStatus,
    DateTime? refundDate,
    DateTime? createdAt,
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
      if (customerEmail != null) 'customerEmail': customerEmail,
      if (orderNumber != null) 'orderNumber': orderNumber,
      if (orderStatus != null) 'orderStatus': orderStatus,
      if (transactionId != null) 'transactionId': transactionId,
      if (providerTransactionId != null)
        'providerTransactionId': providerTransactionId,
      if (deliveryFee != null) 'deliveryFee': deliveryFee,
      if (discount != null) 'discount': discount,
      if (vendorEarnings != null) 'vendorEarnings': vendorEarnings,
      if (refundStatus != null) 'refundStatus': refundStatus,
      if (refundDate != null) 'refundDate': refundDate?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
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
      if (customerEmail != null) 'customerEmail': customerEmail,
      if (orderNumber != null) 'orderNumber': orderNumber,
      if (orderStatus != null) 'orderStatus': orderStatus,
      if (transactionId != null) 'transactionId': transactionId,
      if (providerTransactionId != null)
        'providerTransactionId': providerTransactionId,
      if (deliveryFee != null) 'deliveryFee': deliveryFee,
      if (discount != null) 'discount': discount,
      if (vendorEarnings != null) 'vendorEarnings': vendorEarnings,
      if (refundStatus != null) 'refundStatus': refundStatus,
      if (refundDate != null) 'refundDate': refundDate?.toJson(),
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
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
    String? customerEmail,
    String? orderNumber,
    String? orderStatus,
    String? transactionId,
    String? providerTransactionId,
    double? deliveryFee,
    double? discount,
    double? vendorEarnings,
    String? refundStatus,
    DateTime? refundDate,
    DateTime? createdAt,
  }) : super._(
         id: id,
         orderId: orderId,
         amount: amount,
         status: status,
         note: note,
         updatedAt: updatedAt,
         paymentMethod: paymentMethod,
         customerName: customerName,
         customerEmail: customerEmail,
         orderNumber: orderNumber,
         orderStatus: orderStatus,
         transactionId: transactionId,
         providerTransactionId: providerTransactionId,
         deliveryFee: deliveryFee,
         discount: discount,
         vendorEarnings: vendorEarnings,
         refundStatus: refundStatus,
         refundDate: refundDate,
         createdAt: createdAt,
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
    Object? customerEmail = _Undefined,
    Object? orderNumber = _Undefined,
    Object? orderStatus = _Undefined,
    Object? transactionId = _Undefined,
    Object? providerTransactionId = _Undefined,
    Object? deliveryFee = _Undefined,
    Object? discount = _Undefined,
    Object? vendorEarnings = _Undefined,
    Object? refundStatus = _Undefined,
    Object? refundDate = _Undefined,
    Object? createdAt = _Undefined,
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
      customerEmail: customerEmail is String?
          ? customerEmail
          : this.customerEmail,
      orderNumber: orderNumber is String? ? orderNumber : this.orderNumber,
      orderStatus: orderStatus is String? ? orderStatus : this.orderStatus,
      transactionId: transactionId is String?
          ? transactionId
          : this.transactionId,
      providerTransactionId: providerTransactionId is String?
          ? providerTransactionId
          : this.providerTransactionId,
      deliveryFee: deliveryFee is double? ? deliveryFee : this.deliveryFee,
      discount: discount is double? ? discount : this.discount,
      vendorEarnings: vendorEarnings is double?
          ? vendorEarnings
          : this.vendorEarnings,
      refundStatus: refundStatus is String? ? refundStatus : this.refundStatus,
      refundDate: refundDate is DateTime? ? refundDate : this.refundDate,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
    );
  }
}
