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
import 'request_status.dart' as _i2;
import 'payment_method.dart' as _i3;
import 'payment_transaction_status.dart' as _i4;

/// Refund row for the customer profile refund list.
abstract class RefundRequestSummary
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  RefundRequestSummary._({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.refundAmount,
    required this.reason,
    required this.createdAt,
    this.rejectionReason,
    this.paymentMethod,
    this.paymentStatus,
    this.destinationLabel,
    this.referenceNumber,
    this.gatewayStatus,
    this.gatewayReference,
    this.refundCompletedAt,
    this.settlementMode,
  });

  factory RefundRequestSummary({
    required int id,
    required int orderId,
    required String orderNumber,
    required _i2.RequestStatus status,
    required double refundAmount,
    required String reason,
    required DateTime createdAt,
    String? rejectionReason,
    _i3.PaymentMethod? paymentMethod,
    _i4.PaymentTransactionStatus? paymentStatus,
    String? destinationLabel,
    String? referenceNumber,
    String? gatewayStatus,
    String? gatewayReference,
    DateTime? refundCompletedAt,
    String? settlementMode,
  }) = _RefundRequestSummaryImpl;

  factory RefundRequestSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RefundRequestSummary(
      id: jsonSerialization['id'] as int,
      orderId: jsonSerialization['orderId'] as int,
      orderNumber: jsonSerialization['orderNumber'] as String,
      status: _i2.RequestStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      refundAmount: (jsonSerialization['refundAmount'] as num).toDouble(),
      reason: jsonSerialization['reason'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      rejectionReason: jsonSerialization['rejectionReason'] as String?,
      paymentMethod: jsonSerialization['paymentMethod'] == null
          ? null
          : _i3.PaymentMethod.fromJson(
              (jsonSerialization['paymentMethod'] as String),
            ),
      paymentStatus: jsonSerialization['paymentStatus'] == null
          ? null
          : _i4.PaymentTransactionStatus.fromJson(
              (jsonSerialization['paymentStatus'] as String),
            ),
      destinationLabel: jsonSerialization['destinationLabel'] as String?,
      referenceNumber: jsonSerialization['referenceNumber'] as String?,
      gatewayStatus: jsonSerialization['gatewayStatus'] as String?,
      gatewayReference: jsonSerialization['gatewayReference'] as String?,
      refundCompletedAt: jsonSerialization['refundCompletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['refundCompletedAt'],
            ),
      settlementMode: jsonSerialization['settlementMode'] as String?,
    );
  }

  int id;

  int orderId;

  String orderNumber;

  _i2.RequestStatus status;

  double refundAmount;

  String reason;

  DateTime createdAt;

  String? rejectionReason;

  _i3.PaymentMethod? paymentMethod;

  _i4.PaymentTransactionStatus? paymentStatus;

  String? destinationLabel;

  String? referenceNumber;

  String? gatewayStatus;

  String? gatewayReference;

  DateTime? refundCompletedAt;

  String? settlementMode;

  /// Returns a shallow copy of this [RefundRequestSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RefundRequestSummary copyWith({
    int? id,
    int? orderId,
    String? orderNumber,
    _i2.RequestStatus? status,
    double? refundAmount,
    String? reason,
    DateTime? createdAt,
    String? rejectionReason,
    _i3.PaymentMethod? paymentMethod,
    _i4.PaymentTransactionStatus? paymentStatus,
    String? destinationLabel,
    String? referenceNumber,
    String? gatewayStatus,
    String? gatewayReference,
    DateTime? refundCompletedAt,
    String? settlementMode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RefundRequestSummary',
      'id': id,
      'orderId': orderId,
      'orderNumber': orderNumber,
      'status': status.toJson(),
      'refundAmount': refundAmount,
      'reason': reason,
      'createdAt': createdAt.toJson(),
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
      if (paymentMethod != null) 'paymentMethod': paymentMethod?.toJson(),
      if (paymentStatus != null) 'paymentStatus': paymentStatus?.toJson(),
      if (destinationLabel != null) 'destinationLabel': destinationLabel,
      if (referenceNumber != null) 'referenceNumber': referenceNumber,
      if (gatewayStatus != null) 'gatewayStatus': gatewayStatus,
      if (gatewayReference != null) 'gatewayReference': gatewayReference,
      if (refundCompletedAt != null)
        'refundCompletedAt': refundCompletedAt?.toJson(),
      if (settlementMode != null) 'settlementMode': settlementMode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RefundRequestSummary',
      'id': id,
      'orderId': orderId,
      'orderNumber': orderNumber,
      'status': status.toJson(),
      'refundAmount': refundAmount,
      'reason': reason,
      'createdAt': createdAt.toJson(),
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
      if (paymentMethod != null) 'paymentMethod': paymentMethod?.toJson(),
      if (paymentStatus != null) 'paymentStatus': paymentStatus?.toJson(),
      if (destinationLabel != null) 'destinationLabel': destinationLabel,
      if (referenceNumber != null) 'referenceNumber': referenceNumber,
      if (gatewayStatus != null) 'gatewayStatus': gatewayStatus,
      if (gatewayReference != null) 'gatewayReference': gatewayReference,
      if (refundCompletedAt != null)
        'refundCompletedAt': refundCompletedAt?.toJson(),
      if (settlementMode != null) 'settlementMode': settlementMode,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RefundRequestSummaryImpl extends RefundRequestSummary {
  _RefundRequestSummaryImpl({
    required int id,
    required int orderId,
    required String orderNumber,
    required _i2.RequestStatus status,
    required double refundAmount,
    required String reason,
    required DateTime createdAt,
    String? rejectionReason,
    _i3.PaymentMethod? paymentMethod,
    _i4.PaymentTransactionStatus? paymentStatus,
    String? destinationLabel,
    String? referenceNumber,
    String? gatewayStatus,
    String? gatewayReference,
    DateTime? refundCompletedAt,
    String? settlementMode,
  }) : super._(
         id: id,
         orderId: orderId,
         orderNumber: orderNumber,
         status: status,
         refundAmount: refundAmount,
         reason: reason,
         createdAt: createdAt,
         rejectionReason: rejectionReason,
         paymentMethod: paymentMethod,
         paymentStatus: paymentStatus,
         destinationLabel: destinationLabel,
         referenceNumber: referenceNumber,
         gatewayStatus: gatewayStatus,
         gatewayReference: gatewayReference,
         refundCompletedAt: refundCompletedAt,
         settlementMode: settlementMode,
       );

  /// Returns a shallow copy of this [RefundRequestSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RefundRequestSummary copyWith({
    int? id,
    int? orderId,
    String? orderNumber,
    _i2.RequestStatus? status,
    double? refundAmount,
    String? reason,
    DateTime? createdAt,
    Object? rejectionReason = _Undefined,
    Object? paymentMethod = _Undefined,
    Object? paymentStatus = _Undefined,
    Object? destinationLabel = _Undefined,
    Object? referenceNumber = _Undefined,
    Object? gatewayStatus = _Undefined,
    Object? gatewayReference = _Undefined,
    Object? refundCompletedAt = _Undefined,
    Object? settlementMode = _Undefined,
  }) {
    return RefundRequestSummary(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      refundAmount: refundAmount ?? this.refundAmount,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      rejectionReason: rejectionReason is String?
          ? rejectionReason
          : this.rejectionReason,
      paymentMethod: paymentMethod is _i3.PaymentMethod?
          ? paymentMethod
          : this.paymentMethod,
      paymentStatus: paymentStatus is _i4.PaymentTransactionStatus?
          ? paymentStatus
          : this.paymentStatus,
      destinationLabel: destinationLabel is String?
          ? destinationLabel
          : this.destinationLabel,
      referenceNumber: referenceNumber is String?
          ? referenceNumber
          : this.referenceNumber,
      gatewayStatus: gatewayStatus is String?
          ? gatewayStatus
          : this.gatewayStatus,
      gatewayReference: gatewayReference is String?
          ? gatewayReference
          : this.gatewayReference,
      refundCompletedAt: refundCompletedAt is DateTime?
          ? refundCompletedAt
          : this.refundCompletedAt,
      settlementMode: settlementMode is String?
          ? settlementMode
          : this.settlementMode,
    );
  }
}
