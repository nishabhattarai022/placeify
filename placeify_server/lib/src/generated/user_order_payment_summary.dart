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

/// Payment snapshot for a customer order / payment ledger row.
abstract class UserOrderPaymentSummary
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  UserOrderPaymentSummary._({
    required this.orderId,
    required this.status,
    required this.paymentMethod,
    required this.amount,
    required this.provider,
    this.providerTransactionId,
    this.orderNumber,
    this.vendorName,
    this.deliveryFee,
    this.discount,
    this.refundStatus,
    this.refundAmount,
    this.refundReason,
    this.refundDate,
    this.orderDate,
    this.paymentDate,
    this.primaryThumbnailUrl,
    this.orderStatus,
  });

  factory UserOrderPaymentSummary({
    required int orderId,
    required _i2.PaymentTransactionStatus status,
    required _i3.PaymentMethod paymentMethod,
    required double amount,
    required String provider,
    String? providerTransactionId,
    String? orderNumber,
    String? vendorName,
    double? deliveryFee,
    double? discount,
    String? refundStatus,
    double? refundAmount,
    String? refundReason,
    DateTime? refundDate,
    DateTime? orderDate,
    DateTime? paymentDate,
    String? primaryThumbnailUrl,
    String? orderStatus,
  }) = _UserOrderPaymentSummaryImpl;

  factory UserOrderPaymentSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UserOrderPaymentSummary(
      orderId: jsonSerialization['orderId'] as int,
      status: _i2.PaymentTransactionStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      paymentMethod: _i3.PaymentMethod.fromJson(
        (jsonSerialization['paymentMethod'] as String),
      ),
      amount: (jsonSerialization['amount'] as num).toDouble(),
      provider: jsonSerialization['provider'] as String,
      providerTransactionId:
          jsonSerialization['providerTransactionId'] as String?,
      orderNumber: jsonSerialization['orderNumber'] as String?,
      vendorName: jsonSerialization['vendorName'] as String?,
      deliveryFee: (jsonSerialization['deliveryFee'] as num?)?.toDouble(),
      discount: (jsonSerialization['discount'] as num?)?.toDouble(),
      refundStatus: jsonSerialization['refundStatus'] as String?,
      refundAmount: (jsonSerialization['refundAmount'] as num?)?.toDouble(),
      refundReason: jsonSerialization['refundReason'] as String?,
      refundDate: jsonSerialization['refundDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['refundDate']),
      orderDate: jsonSerialization['orderDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['orderDate']),
      paymentDate: jsonSerialization['paymentDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['paymentDate'],
            ),
      primaryThumbnailUrl: jsonSerialization['primaryThumbnailUrl'] as String?,
      orderStatus: jsonSerialization['orderStatus'] as String?,
    );
  }

  int orderId;

  _i2.PaymentTransactionStatus status;

  _i3.PaymentMethod paymentMethod;

  double amount;

  String provider;

  String? providerTransactionId;

  String? orderNumber;

  String? vendorName;

  double? deliveryFee;

  double? discount;

  String? refundStatus;

  double? refundAmount;

  String? refundReason;

  DateTime? refundDate;

  DateTime? orderDate;

  DateTime? paymentDate;

  String? primaryThumbnailUrl;

  String? orderStatus;

  /// Returns a shallow copy of this [UserOrderPaymentSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserOrderPaymentSummary copyWith({
    int? orderId,
    _i2.PaymentTransactionStatus? status,
    _i3.PaymentMethod? paymentMethod,
    double? amount,
    String? provider,
    String? providerTransactionId,
    String? orderNumber,
    String? vendorName,
    double? deliveryFee,
    double? discount,
    String? refundStatus,
    double? refundAmount,
    String? refundReason,
    DateTime? refundDate,
    DateTime? orderDate,
    DateTime? paymentDate,
    String? primaryThumbnailUrl,
    String? orderStatus,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserOrderPaymentSummary',
      'orderId': orderId,
      'status': status.toJson(),
      'paymentMethod': paymentMethod.toJson(),
      'amount': amount,
      'provider': provider,
      if (providerTransactionId != null)
        'providerTransactionId': providerTransactionId,
      if (orderNumber != null) 'orderNumber': orderNumber,
      if (vendorName != null) 'vendorName': vendorName,
      if (deliveryFee != null) 'deliveryFee': deliveryFee,
      if (discount != null) 'discount': discount,
      if (refundStatus != null) 'refundStatus': refundStatus,
      if (refundAmount != null) 'refundAmount': refundAmount,
      if (refundReason != null) 'refundReason': refundReason,
      if (refundDate != null) 'refundDate': refundDate?.toJson(),
      if (orderDate != null) 'orderDate': orderDate?.toJson(),
      if (paymentDate != null) 'paymentDate': paymentDate?.toJson(),
      if (primaryThumbnailUrl != null)
        'primaryThumbnailUrl': primaryThumbnailUrl,
      if (orderStatus != null) 'orderStatus': orderStatus,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserOrderPaymentSummary',
      'orderId': orderId,
      'status': status.toJson(),
      'paymentMethod': paymentMethod.toJson(),
      'amount': amount,
      'provider': provider,
      if (providerTransactionId != null)
        'providerTransactionId': providerTransactionId,
      if (orderNumber != null) 'orderNumber': orderNumber,
      if (vendorName != null) 'vendorName': vendorName,
      if (deliveryFee != null) 'deliveryFee': deliveryFee,
      if (discount != null) 'discount': discount,
      if (refundStatus != null) 'refundStatus': refundStatus,
      if (refundAmount != null) 'refundAmount': refundAmount,
      if (refundReason != null) 'refundReason': refundReason,
      if (refundDate != null) 'refundDate': refundDate?.toJson(),
      if (orderDate != null) 'orderDate': orderDate?.toJson(),
      if (paymentDate != null) 'paymentDate': paymentDate?.toJson(),
      if (primaryThumbnailUrl != null)
        'primaryThumbnailUrl': primaryThumbnailUrl,
      if (orderStatus != null) 'orderStatus': orderStatus,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserOrderPaymentSummaryImpl extends UserOrderPaymentSummary {
  _UserOrderPaymentSummaryImpl({
    required int orderId,
    required _i2.PaymentTransactionStatus status,
    required _i3.PaymentMethod paymentMethod,
    required double amount,
    required String provider,
    String? providerTransactionId,
    String? orderNumber,
    String? vendorName,
    double? deliveryFee,
    double? discount,
    String? refundStatus,
    double? refundAmount,
    String? refundReason,
    DateTime? refundDate,
    DateTime? orderDate,
    DateTime? paymentDate,
    String? primaryThumbnailUrl,
    String? orderStatus,
  }) : super._(
         orderId: orderId,
         status: status,
         paymentMethod: paymentMethod,
         amount: amount,
         provider: provider,
         providerTransactionId: providerTransactionId,
         orderNumber: orderNumber,
         vendorName: vendorName,
         deliveryFee: deliveryFee,
         discount: discount,
         refundStatus: refundStatus,
         refundAmount: refundAmount,
         refundReason: refundReason,
         refundDate: refundDate,
         orderDate: orderDate,
         paymentDate: paymentDate,
         primaryThumbnailUrl: primaryThumbnailUrl,
         orderStatus: orderStatus,
       );

  /// Returns a shallow copy of this [UserOrderPaymentSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserOrderPaymentSummary copyWith({
    int? orderId,
    _i2.PaymentTransactionStatus? status,
    _i3.PaymentMethod? paymentMethod,
    double? amount,
    String? provider,
    Object? providerTransactionId = _Undefined,
    Object? orderNumber = _Undefined,
    Object? vendorName = _Undefined,
    Object? deliveryFee = _Undefined,
    Object? discount = _Undefined,
    Object? refundStatus = _Undefined,
    Object? refundAmount = _Undefined,
    Object? refundReason = _Undefined,
    Object? refundDate = _Undefined,
    Object? orderDate = _Undefined,
    Object? paymentDate = _Undefined,
    Object? primaryThumbnailUrl = _Undefined,
    Object? orderStatus = _Undefined,
  }) {
    return UserOrderPaymentSummary(
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amount: amount ?? this.amount,
      provider: provider ?? this.provider,
      providerTransactionId: providerTransactionId is String?
          ? providerTransactionId
          : this.providerTransactionId,
      orderNumber: orderNumber is String? ? orderNumber : this.orderNumber,
      vendorName: vendorName is String? ? vendorName : this.vendorName,
      deliveryFee: deliveryFee is double? ? deliveryFee : this.deliveryFee,
      discount: discount is double? ? discount : this.discount,
      refundStatus: refundStatus is String? ? refundStatus : this.refundStatus,
      refundAmount: refundAmount is double? ? refundAmount : this.refundAmount,
      refundReason: refundReason is String? ? refundReason : this.refundReason,
      refundDate: refundDate is DateTime? ? refundDate : this.refundDate,
      orderDate: orderDate is DateTime? ? orderDate : this.orderDate,
      paymentDate: paymentDate is DateTime? ? paymentDate : this.paymentDate,
      primaryThumbnailUrl: primaryThumbnailUrl is String?
          ? primaryThumbnailUrl
          : this.primaryThumbnailUrl,
      orderStatus: orderStatus is String? ? orderStatus : this.orderStatus,
    );
  }
}
