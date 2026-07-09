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

/// Admin view of a customer refund request.
abstract class AdminRefundRequestSummary
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
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
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
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
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

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
    );
  }
}
