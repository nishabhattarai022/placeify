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
import 'request_status.dart' as _i2;
import 'payment_method.dart' as _i3;
import 'payment_transaction_status.dart' as _i4;

/// Admin view of a customer refund request.
abstract class AdminRefundRequestSummary implements _i1.SerializableModel {
  AdminRefundRequestSummary._({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.reason,
    required this.refundAmount,
    required this.status,
    required this.createdAt,
    this.paymentMethod,
    this.paymentStatus,
    this.destinationLabel,
    this.gatewayStatus,
    this.gatewayReference,
    this.gatewayResponse,
    this.refundCompletedAt,
    this.lastGatewayCheckAt,
    this.settlementMode,
    required this.automaticInitiateConfigured,
  });

  factory AdminRefundRequestSummary({
    required int id,
    required int orderId,
    required _i1.UuidValue userId,
    required String customerName,
    required String customerEmail,
    required String reason,
    required double refundAmount,
    required _i2.RequestStatus status,
    required DateTime createdAt,
    _i3.PaymentMethod? paymentMethod,
    _i4.PaymentTransactionStatus? paymentStatus,
    String? destinationLabel,
    String? gatewayStatus,
    String? gatewayReference,
    String? gatewayResponse,
    DateTime? refundCompletedAt,
    DateTime? lastGatewayCheckAt,
    String? settlementMode,
    required bool automaticInitiateConfigured,
  }) = _AdminRefundRequestSummaryImpl;

  factory AdminRefundRequestSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminRefundRequestSummary(
      id: jsonSerialization['id'] as int,
      orderId: jsonSerialization['orderId'] as int,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      customerName: jsonSerialization['customerName'] as String,
      customerEmail: jsonSerialization['customerEmail'] as String,
      reason: jsonSerialization['reason'] as String,
      refundAmount: (jsonSerialization['refundAmount'] as num).toDouble(),
      status: _i2.RequestStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
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
      gatewayStatus: jsonSerialization['gatewayStatus'] as String?,
      gatewayReference: jsonSerialization['gatewayReference'] as String?,
      gatewayResponse: jsonSerialization['gatewayResponse'] as String?,
      refundCompletedAt: jsonSerialization['refundCompletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['refundCompletedAt'],
            ),
      lastGatewayCheckAt: jsonSerialization['lastGatewayCheckAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastGatewayCheckAt'],
            ),
      settlementMode: jsonSerialization['settlementMode'] as String?,
      automaticInitiateConfigured: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['automaticInitiateConfigured'],
      ),
    );
  }

  int id;

  int orderId;

  _i1.UuidValue userId;

  String customerName;

  String customerEmail;

  String reason;

  double refundAmount;

  _i2.RequestStatus status;

  DateTime createdAt;

  _i3.PaymentMethod? paymentMethod;

  _i4.PaymentTransactionStatus? paymentStatus;

  String? destinationLabel;

  String? gatewayStatus;

  String? gatewayReference;

  String? gatewayResponse;

  DateTime? refundCompletedAt;

  DateTime? lastGatewayCheckAt;

  String? settlementMode;

  bool automaticInitiateConfigured;

  /// Returns a shallow copy of this [AdminRefundRequestSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminRefundRequestSummary copyWith({
    int? id,
    int? orderId,
    _i1.UuidValue? userId,
    String? customerName,
    String? customerEmail,
    String? reason,
    double? refundAmount,
    _i2.RequestStatus? status,
    DateTime? createdAt,
    _i3.PaymentMethod? paymentMethod,
    _i4.PaymentTransactionStatus? paymentStatus,
    String? destinationLabel,
    String? gatewayStatus,
    String? gatewayReference,
    String? gatewayResponse,
    DateTime? refundCompletedAt,
    DateTime? lastGatewayCheckAt,
    String? settlementMode,
    bool? automaticInitiateConfigured,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminRefundRequestSummary',
      'id': id,
      'orderId': orderId,
      'userId': userId.toJson(),
      'customerName': customerName,
      'customerEmail': customerEmail,
      'reason': reason,
      'refundAmount': refundAmount,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
      if (paymentMethod != null) 'paymentMethod': paymentMethod?.toJson(),
      if (paymentStatus != null) 'paymentStatus': paymentStatus?.toJson(),
      if (destinationLabel != null) 'destinationLabel': destinationLabel,
      if (gatewayStatus != null) 'gatewayStatus': gatewayStatus,
      if (gatewayReference != null) 'gatewayReference': gatewayReference,
      if (gatewayResponse != null) 'gatewayResponse': gatewayResponse,
      if (refundCompletedAt != null)
        'refundCompletedAt': refundCompletedAt?.toJson(),
      if (lastGatewayCheckAt != null)
        'lastGatewayCheckAt': lastGatewayCheckAt?.toJson(),
      if (settlementMode != null) 'settlementMode': settlementMode,
      'automaticInitiateConfigured': automaticInitiateConfigured,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminRefundRequestSummaryImpl extends AdminRefundRequestSummary {
  _AdminRefundRequestSummaryImpl({
    required int id,
    required int orderId,
    required _i1.UuidValue userId,
    required String customerName,
    required String customerEmail,
    required String reason,
    required double refundAmount,
    required _i2.RequestStatus status,
    required DateTime createdAt,
    _i3.PaymentMethod? paymentMethod,
    _i4.PaymentTransactionStatus? paymentStatus,
    String? destinationLabel,
    String? gatewayStatus,
    String? gatewayReference,
    String? gatewayResponse,
    DateTime? refundCompletedAt,
    DateTime? lastGatewayCheckAt,
    String? settlementMode,
    required bool automaticInitiateConfigured,
  }) : super._(
         id: id,
         orderId: orderId,
         userId: userId,
         customerName: customerName,
         customerEmail: customerEmail,
         reason: reason,
         refundAmount: refundAmount,
         status: status,
         createdAt: createdAt,
         paymentMethod: paymentMethod,
         paymentStatus: paymentStatus,
         destinationLabel: destinationLabel,
         gatewayStatus: gatewayStatus,
         gatewayReference: gatewayReference,
         gatewayResponse: gatewayResponse,
         refundCompletedAt: refundCompletedAt,
         lastGatewayCheckAt: lastGatewayCheckAt,
         settlementMode: settlementMode,
         automaticInitiateConfigured: automaticInitiateConfigured,
       );

  /// Returns a shallow copy of this [AdminRefundRequestSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminRefundRequestSummary copyWith({
    int? id,
    int? orderId,
    _i1.UuidValue? userId,
    String? customerName,
    String? customerEmail,
    String? reason,
    double? refundAmount,
    _i2.RequestStatus? status,
    DateTime? createdAt,
    Object? paymentMethod = _Undefined,
    Object? paymentStatus = _Undefined,
    Object? destinationLabel = _Undefined,
    Object? gatewayStatus = _Undefined,
    Object? gatewayReference = _Undefined,
    Object? gatewayResponse = _Undefined,
    Object? refundCompletedAt = _Undefined,
    Object? lastGatewayCheckAt = _Undefined,
    Object? settlementMode = _Undefined,
    bool? automaticInitiateConfigured,
  }) {
    return AdminRefundRequestSummary(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      reason: reason ?? this.reason,
      refundAmount: refundAmount ?? this.refundAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      paymentMethod: paymentMethod is _i3.PaymentMethod?
          ? paymentMethod
          : this.paymentMethod,
      paymentStatus: paymentStatus is _i4.PaymentTransactionStatus?
          ? paymentStatus
          : this.paymentStatus,
      destinationLabel: destinationLabel is String?
          ? destinationLabel
          : this.destinationLabel,
      gatewayStatus: gatewayStatus is String?
          ? gatewayStatus
          : this.gatewayStatus,
      gatewayReference: gatewayReference is String?
          ? gatewayReference
          : this.gatewayReference,
      gatewayResponse: gatewayResponse is String?
          ? gatewayResponse
          : this.gatewayResponse,
      refundCompletedAt: refundCompletedAt is DateTime?
          ? refundCompletedAt
          : this.refundCompletedAt,
      lastGatewayCheckAt: lastGatewayCheckAt is DateTime?
          ? lastGatewayCheckAt
          : this.lastGatewayCheckAt,
      settlementMode: settlementMode is String?
          ? settlementMode
          : this.settlementMode,
      automaticInitiateConfigured:
          automaticInitiateConfigured ?? this.automaticInitiateConfigured,
    );
  }
}
