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
import 'payment_transaction_status.dart' as _i2;
import 'order.dart' as _i3;
import 'user.dart' as _i4;
import 'package:placeify_client/src/protocol/protocol.dart' as _i5;

/// Customer payment record for a placed order.
abstract class PaymentTransaction implements _i1.SerializableModel {
  PaymentTransaction._({
    this.id,
    required this.orderId,
    this.order,
    required this.userId,
    this.user,
    required this.provider,
    required this.providerTransactionId,
    required this.amount,
    String? currency,
    _i2.PaymentTransactionStatus? status,
    this.note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : currency = currency ?? 'NPR',
       status = status ?? _i2.PaymentTransactionStatus.pending,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory PaymentTransaction({
    int? id,
    required int orderId,
    _i3.Order? order,
    required _i1.UuidValue userId,
    _i4.User? user,
    required String provider,
    required String providerTransactionId,
    required double amount,
    String? currency,
    _i2.PaymentTransactionStatus? status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PaymentTransactionImpl;

  factory PaymentTransaction.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentTransaction(
      id: jsonSerialization['id'] as int?,
      orderId: jsonSerialization['orderId'] as int,
      order: jsonSerialization['order'] == null
          ? null
          : _i5.Protocol().deserialize<_i3.Order>(jsonSerialization['order']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.User>(jsonSerialization['user']),
      provider: jsonSerialization['provider'] as String,
      providerTransactionId:
          jsonSerialization['providerTransactionId'] as String,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      currency: jsonSerialization['currency'] as String?,
      status: jsonSerialization['status'] == null
          ? null
          : _i2.PaymentTransactionStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      note: jsonSerialization['note'] as String?,
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

  int orderId;

  _i3.Order? order;

  _i1.UuidValue userId;

  _i4.User? user;

  String provider;

  String providerTransactionId;

  double amount;

  String currency;

  _i2.PaymentTransactionStatus status;

  String? note;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [PaymentTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaymentTransaction copyWith({
    int? id,
    int? orderId,
    _i3.Order? order,
    _i1.UuidValue? userId,
    _i4.User? user,
    String? provider,
    String? providerTransactionId,
    double? amount,
    String? currency,
    _i2.PaymentTransactionStatus? status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentTransaction',
      if (id != null) 'id': id,
      'orderId': orderId,
      if (order != null) 'order': order?.toJson(),
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      'provider': provider,
      'providerTransactionId': providerTransactionId,
      'amount': amount,
      'currency': currency,
      'status': status.toJson(),
      if (note != null) 'note': note,
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

class _PaymentTransactionImpl extends PaymentTransaction {
  _PaymentTransactionImpl({
    int? id,
    required int orderId,
    _i3.Order? order,
    required _i1.UuidValue userId,
    _i4.User? user,
    required String provider,
    required String providerTransactionId,
    required double amount,
    String? currency,
    _i2.PaymentTransactionStatus? status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         orderId: orderId,
         order: order,
         userId: userId,
         user: user,
         provider: provider,
         providerTransactionId: providerTransactionId,
         amount: amount,
         currency: currency,
         status: status,
         note: note,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PaymentTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaymentTransaction copyWith({
    Object? id = _Undefined,
    int? orderId,
    Object? order = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    String? provider,
    String? providerTransactionId,
    double? amount,
    String? currency,
    _i2.PaymentTransactionStatus? status,
    Object? note = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentTransaction(
      id: id is int? ? id : this.id,
      orderId: orderId ?? this.orderId,
      order: order is _i3.Order? ? order : this.order?.copyWith(),
      userId: userId ?? this.userId,
      user: user is _i4.User? ? user : this.user?.copyWith(),
      provider: provider ?? this.provider,
      providerTransactionId:
          providerTransactionId ?? this.providerTransactionId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      note: note is String? ? note : this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
