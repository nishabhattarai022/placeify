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
import 'order.dart' as _i2;
import 'order_status_history_type.dart' as _i3;
import 'user.dart' as _i4;
import 'package:placeify_client/src/protocol/protocol.dart' as _i5;

/// Audit log for order, delivery, and payment status changes.
abstract class OrderStatusHistory implements _i1.SerializableModel {
  OrderStatusHistory._({
    this.id,
    required this.orderId,
    this.order,
    this.previousStatus,
    required this.newStatus,
    required this.statusType,
    this.changedById,
    this.changedBy,
    DateTime? changedAt,
    this.note,
  }) : changedAt = changedAt ?? DateTime.now();

  factory OrderStatusHistory({
    int? id,
    required int orderId,
    _i2.Order? order,
    String? previousStatus,
    required String newStatus,
    required _i3.OrderStatusHistoryType statusType,
    _i1.UuidValue? changedById,
    _i4.User? changedBy,
    DateTime? changedAt,
    String? note,
  }) = _OrderStatusHistoryImpl;

  factory OrderStatusHistory.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderStatusHistory(
      id: jsonSerialization['id'] as int?,
      orderId: jsonSerialization['orderId'] as int,
      order: jsonSerialization['order'] == null
          ? null
          : _i5.Protocol().deserialize<_i2.Order>(jsonSerialization['order']),
      previousStatus: jsonSerialization['previousStatus'] as String?,
      newStatus: jsonSerialization['newStatus'] as String,
      statusType: _i3.OrderStatusHistoryType.fromJson(
        (jsonSerialization['statusType'] as String),
      ),
      changedById: jsonSerialization['changedById'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['changedById'],
            ),
      changedBy: jsonSerialization['changedBy'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.User>(
              jsonSerialization['changedBy'],
            ),
      changedAt: jsonSerialization['changedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['changedAt']),
      note: jsonSerialization['note'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int orderId;

  _i2.Order? order;

  String? previousStatus;

  String newStatus;

  _i3.OrderStatusHistoryType statusType;

  _i1.UuidValue? changedById;

  _i4.User? changedBy;

  DateTime changedAt;

  String? note;

  /// Returns a shallow copy of this [OrderStatusHistory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderStatusHistory copyWith({
    int? id,
    int? orderId,
    _i2.Order? order,
    String? previousStatus,
    String? newStatus,
    _i3.OrderStatusHistoryType? statusType,
    _i1.UuidValue? changedById,
    _i4.User? changedBy,
    DateTime? changedAt,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderStatusHistory',
      if (id != null) 'id': id,
      'orderId': orderId,
      if (order != null) 'order': order?.toJson(),
      if (previousStatus != null) 'previousStatus': previousStatus,
      'newStatus': newStatus,
      'statusType': statusType.toJson(),
      if (changedById != null) 'changedById': changedById?.toJson(),
      if (changedBy != null) 'changedBy': changedBy?.toJson(),
      'changedAt': changedAt.toJson(),
      if (note != null) 'note': note,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderStatusHistoryImpl extends OrderStatusHistory {
  _OrderStatusHistoryImpl({
    int? id,
    required int orderId,
    _i2.Order? order,
    String? previousStatus,
    required String newStatus,
    required _i3.OrderStatusHistoryType statusType,
    _i1.UuidValue? changedById,
    _i4.User? changedBy,
    DateTime? changedAt,
    String? note,
  }) : super._(
         id: id,
         orderId: orderId,
         order: order,
         previousStatus: previousStatus,
         newStatus: newStatus,
         statusType: statusType,
         changedById: changedById,
         changedBy: changedBy,
         changedAt: changedAt,
         note: note,
       );

  /// Returns a shallow copy of this [OrderStatusHistory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderStatusHistory copyWith({
    Object? id = _Undefined,
    int? orderId,
    Object? order = _Undefined,
    Object? previousStatus = _Undefined,
    String? newStatus,
    _i3.OrderStatusHistoryType? statusType,
    Object? changedById = _Undefined,
    Object? changedBy = _Undefined,
    DateTime? changedAt,
    Object? note = _Undefined,
  }) {
    return OrderStatusHistory(
      id: id is int? ? id : this.id,
      orderId: orderId ?? this.orderId,
      order: order is _i2.Order? ? order : this.order?.copyWith(),
      previousStatus: previousStatus is String?
          ? previousStatus
          : this.previousStatus,
      newStatus: newStatus ?? this.newStatus,
      statusType: statusType ?? this.statusType,
      changedById: changedById is _i1.UuidValue?
          ? changedById
          : this.changedById,
      changedBy: changedBy is _i4.User?
          ? changedBy
          : this.changedBy?.copyWith(),
      changedAt: changedAt ?? this.changedAt,
      note: note is String? ? note : this.note,
    );
  }
}
