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
import 'order_status.dart' as _i2;
import 'user.dart' as _i3;
import 'package:placeify_client/src/protocol/protocol.dart' as _i4;

/// Order placed by a customer.
abstract class Order implements _i1.SerializableModel {
  Order._({
    this.id,
    required this.userId,
    this.user,
    _i2.OrderStatus? status,
    required this.totalAmount,
    required this.shippingAddress,
    DateTime? placedAt,
    DateTime? updatedAt,
  }) : status = status ?? _i2.OrderStatus.pending,
       placedAt = placedAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Order({
    int? id,
    required _i1.UuidValue userId,
    _i3.User? user,
    _i2.OrderStatus? status,
    required double totalAmount,
    required String shippingAddress,
    DateTime? placedAt,
    DateTime? updatedAt,
  }) = _OrderImpl;

  factory Order.fromJson(Map<String, dynamic> jsonSerialization) {
    return Order(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.User>(jsonSerialization['user']),
      status: jsonSerialization['status'] == null
          ? null
          : _i2.OrderStatus.fromJson((jsonSerialization['status'] as String)),
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
      shippingAddress: jsonSerialization['shippingAddress'] as String,
      placedAt: jsonSerialization['placedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['placedAt']),
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

  _i2.OrderStatus status;

  double totalAmount;

  String shippingAddress;

  DateTime placedAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Order]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Order copyWith({
    int? id,
    _i1.UuidValue? userId,
    _i3.User? user,
    _i2.OrderStatus? status,
    double? totalAmount,
    String? shippingAddress,
    DateTime? placedAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Order',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      'status': status.toJson(),
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      'placedAt': placedAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderImpl extends Order {
  _OrderImpl({
    int? id,
    required _i1.UuidValue userId,
    _i3.User? user,
    _i2.OrderStatus? status,
    required double totalAmount,
    required String shippingAddress,
    DateTime? placedAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         status: status,
         totalAmount: totalAmount,
         shippingAddress: shippingAddress,
         placedAt: placedAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Order]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Order copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    _i2.OrderStatus? status,
    double? totalAmount,
    String? shippingAddress,
    DateTime? placedAt,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i3.User? ? user : this.user?.copyWith(),
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      placedAt: placedAt ?? this.placedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
