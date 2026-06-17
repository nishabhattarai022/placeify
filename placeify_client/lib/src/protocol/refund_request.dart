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
import 'user.dart' as _i3;
import 'order.dart' as _i4;
import 'package:placeify_client/src/protocol/protocol.dart' as _i5;

/// Customer refund or return request linked to an order.
abstract class RefundRequest implements _i1.SerializableModel {
  RefundRequest._({
    this.id,
    required this.userId,
    this.user,
    required this.orderId,
    this.order,
    required this.reason,
    _i2.RequestStatus? status,
    required this.refundAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? _i2.RequestStatus.pending,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory RefundRequest({
    int? id,
    required _i1.UuidValue userId,
    _i3.User? user,
    required int orderId,
    _i4.Order? order,
    required String reason,
    _i2.RequestStatus? status,
    required double refundAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RefundRequestImpl;

  factory RefundRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return RefundRequest(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i5.Protocol().deserialize<_i3.User>(jsonSerialization['user']),
      orderId: jsonSerialization['orderId'] as int,
      order: jsonSerialization['order'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.Order>(jsonSerialization['order']),
      reason: jsonSerialization['reason'] as String,
      status: jsonSerialization['status'] == null
          ? null
          : _i2.RequestStatus.fromJson((jsonSerialization['status'] as String)),
      refundAmount: (jsonSerialization['refundAmount'] as num).toDouble(),
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

  _i1.UuidValue userId;

  _i3.User? user;

  int orderId;

  _i4.Order? order;

  String reason;

  _i2.RequestStatus status;

  double refundAmount;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [RefundRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RefundRequest copyWith({
    int? id,
    _i1.UuidValue? userId,
    _i3.User? user,
    int? orderId,
    _i4.Order? order,
    String? reason,
    _i2.RequestStatus? status,
    double? refundAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RefundRequest',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      'orderId': orderId,
      if (order != null) 'order': order?.toJson(),
      'reason': reason,
      'status': status.toJson(),
      'refundAmount': refundAmount,
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

class _RefundRequestImpl extends RefundRequest {
  _RefundRequestImpl({
    int? id,
    required _i1.UuidValue userId,
    _i3.User? user,
    required int orderId,
    _i4.Order? order,
    required String reason,
    _i2.RequestStatus? status,
    required double refundAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         orderId: orderId,
         order: order,
         reason: reason,
         status: status,
         refundAmount: refundAmount,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RefundRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RefundRequest copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    int? orderId,
    Object? order = _Undefined,
    String? reason,
    _i2.RequestStatus? status,
    double? refundAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RefundRequest(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i3.User? ? user : this.user?.copyWith(),
      orderId: orderId ?? this.orderId,
      order: order is _i4.Order? ? order : this.order?.copyWith(),
      reason: reason ?? this.reason,
      status: status ?? this.status,
      refundAmount: refundAmount ?? this.refundAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
