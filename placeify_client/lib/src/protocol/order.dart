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
import 'order_payment_status.dart' as _i3;
import 'user.dart' as _i4;
import 'order_delivery_status.dart' as _i5;
import 'package:placeify_client/src/protocol/protocol.dart' as _i6;

/// Order placed by a customer.
abstract class Order implements _i1.SerializableModel {
  Order._({
    this.id,
    required this.userId,
    this.user,
    _i2.OrderStatus? status,
    this.deliveryStatus,
    _i3.OrderPaymentStatus? paymentStatus,
    required this.totalAmount,
    required this.shippingAddress,
    this.rejectionReason,
    this.autoExpiresAt,
    int? version,
    DateTime? placedAt,
    DateTime? updatedAt,
  }) : status = status ?? _i2.OrderStatus.pending,
       paymentStatus = paymentStatus ?? _i3.OrderPaymentStatus.unpaid,
       version = version ?? 1,
       placedAt = placedAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Order({
    int? id,
    required _i1.UuidValue userId,
    _i4.User? user,
    _i2.OrderStatus? status,
    _i5.OrderDeliveryStatus? deliveryStatus,
    _i3.OrderPaymentStatus? paymentStatus,
    required double totalAmount,
    required String shippingAddress,
    String? rejectionReason,
    DateTime? autoExpiresAt,
    int? version,
    DateTime? placedAt,
    DateTime? updatedAt,
  }) = _OrderImpl;

  factory Order.fromJson(Map<String, dynamic> jsonSerialization) {
    return Order(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i6.Protocol().deserialize<_i4.User>(jsonSerialization['user']),
      status: jsonSerialization['status'] == null
          ? null
          : _i2.OrderStatus.fromJson((jsonSerialization['status'] as String)),
      deliveryStatus: jsonSerialization['deliveryStatus'] == null
          ? null
          : _i5.OrderDeliveryStatus.fromJson(
              (jsonSerialization['deliveryStatus'] as String),
            ),
      paymentStatus: jsonSerialization['paymentStatus'] == null
          ? null
          : _i3.OrderPaymentStatus.fromJson(
              (jsonSerialization['paymentStatus'] as String),
            ),
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
      shippingAddress: jsonSerialization['shippingAddress'] as String,
      rejectionReason: jsonSerialization['rejectionReason'] as String?,
      autoExpiresAt: jsonSerialization['autoExpiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['autoExpiresAt'],
            ),
      version: jsonSerialization['version'] as int?,
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

  _i4.User? user;

  _i2.OrderStatus status;

  _i5.OrderDeliveryStatus? deliveryStatus;

  _i3.OrderPaymentStatus paymentStatus;

  double totalAmount;

  String shippingAddress;

  String? rejectionReason;

  DateTime? autoExpiresAt;

  int version;

  DateTime placedAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Order]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Order copyWith({
    int? id,
    _i1.UuidValue? userId,
    _i4.User? user,
    _i2.OrderStatus? status,
    _i5.OrderDeliveryStatus? deliveryStatus,
    _i3.OrderPaymentStatus? paymentStatus,
    double? totalAmount,
    String? shippingAddress,
    String? rejectionReason,
    DateTime? autoExpiresAt,
    int? version,
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
      if (deliveryStatus != null) 'deliveryStatus': deliveryStatus?.toJson(),
      'paymentStatus': paymentStatus.toJson(),
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
      if (autoExpiresAt != null) 'autoExpiresAt': autoExpiresAt?.toJson(),
      'version': version,
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
    _i4.User? user,
    _i2.OrderStatus? status,
    _i5.OrderDeliveryStatus? deliveryStatus,
    _i3.OrderPaymentStatus? paymentStatus,
    required double totalAmount,
    required String shippingAddress,
    String? rejectionReason,
    DateTime? autoExpiresAt,
    int? version,
    DateTime? placedAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         status: status,
         deliveryStatus: deliveryStatus,
         paymentStatus: paymentStatus,
         totalAmount: totalAmount,
         shippingAddress: shippingAddress,
         rejectionReason: rejectionReason,
         autoExpiresAt: autoExpiresAt,
         version: version,
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
    Object? deliveryStatus = _Undefined,
    _i3.OrderPaymentStatus? paymentStatus,
    double? totalAmount,
    String? shippingAddress,
    Object? rejectionReason = _Undefined,
    Object? autoExpiresAt = _Undefined,
    int? version,
    DateTime? placedAt,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i4.User? ? user : this.user?.copyWith(),
      status: status ?? this.status,
      deliveryStatus: deliveryStatus is _i5.OrderDeliveryStatus?
          ? deliveryStatus
          : this.deliveryStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      totalAmount: totalAmount ?? this.totalAmount,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      rejectionReason: rejectionReason is String?
          ? rejectionReason
          : this.rejectionReason,
      autoExpiresAt: autoExpiresAt is DateTime?
          ? autoExpiresAt
          : this.autoExpiresAt,
      version: version ?? this.version,
      placedAt: placedAt ?? this.placedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
