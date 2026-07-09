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
  });

  factory RefundRequestSummary({
    required int id,
    required int orderId,
    required String orderNumber,
    required _i2.RequestStatus status,
    required double refundAmount,
    required String reason,
    required DateTime createdAt,
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
    );
  }

  int id;

  int orderId;

  String orderNumber;

  _i2.RequestStatus status;

  double refundAmount;

  String reason;

  DateTime createdAt;

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
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _RefundRequestSummaryImpl extends RefundRequestSummary {
  _RefundRequestSummaryImpl({
    required int id,
    required int orderId,
    required String orderNumber,
    required _i2.RequestStatus status,
    required double refundAmount,
    required String reason,
    required DateTime createdAt,
  }) : super._(
         id: id,
         orderId: orderId,
         orderNumber: orderNumber,
         status: status,
         refundAmount: refundAmount,
         reason: reason,
         createdAt: createdAt,
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
  }) {
    return RefundRequestSummary(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      refundAmount: refundAmount ?? this.refundAmount,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
