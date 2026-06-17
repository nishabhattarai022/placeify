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
import 'vendor.dart' as _i3;
import 'delivery_stage.dart' as _i4;
import 'package:placeify_client/src/protocol/protocol.dart' as _i5;

/// Vendor-posted delivery milestone for a customer order.
abstract class OrderDeliveryUpdate implements _i1.SerializableModel {
  OrderDeliveryUpdate._({
    this.id,
    required this.orderId,
    this.order,
    required this.vendorId,
    this.vendor,
    required this.stage,
    this.note,
    this.photoUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory OrderDeliveryUpdate({
    int? id,
    required int orderId,
    _i2.Order? order,
    required _i1.UuidValue vendorId,
    _i3.Vendor? vendor,
    required _i4.DeliveryStage stage,
    String? note,
    String? photoUrl,
    DateTime? createdAt,
  }) = _OrderDeliveryUpdateImpl;

  factory OrderDeliveryUpdate.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderDeliveryUpdate(
      id: jsonSerialization['id'] as int?,
      orderId: jsonSerialization['orderId'] as int,
      order: jsonSerialization['order'] == null
          ? null
          : _i5.Protocol().deserialize<_i2.Order>(jsonSerialization['order']),
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      vendor: jsonSerialization['vendor'] == null
          ? null
          : _i5.Protocol().deserialize<_i3.Vendor>(jsonSerialization['vendor']),
      stage: _i4.DeliveryStage.fromJson((jsonSerialization['stage'] as String)),
      note: jsonSerialization['note'] as String?,
      photoUrl: jsonSerialization['photoUrl'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int orderId;

  _i2.Order? order;

  _i1.UuidValue vendorId;

  _i3.Vendor? vendor;

  _i4.DeliveryStage stage;

  String? note;

  String? photoUrl;

  DateTime createdAt;

  /// Returns a shallow copy of this [OrderDeliveryUpdate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderDeliveryUpdate copyWith({
    int? id,
    int? orderId,
    _i2.Order? order,
    _i1.UuidValue? vendorId,
    _i3.Vendor? vendor,
    _i4.DeliveryStage? stage,
    String? note,
    String? photoUrl,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderDeliveryUpdate',
      if (id != null) 'id': id,
      'orderId': orderId,
      if (order != null) 'order': order?.toJson(),
      'vendorId': vendorId.toJson(),
      if (vendor != null) 'vendor': vendor?.toJson(),
      'stage': stage.toJson(),
      if (note != null) 'note': note,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderDeliveryUpdateImpl extends OrderDeliveryUpdate {
  _OrderDeliveryUpdateImpl({
    int? id,
    required int orderId,
    _i2.Order? order,
    required _i1.UuidValue vendorId,
    _i3.Vendor? vendor,
    required _i4.DeliveryStage stage,
    String? note,
    String? photoUrl,
    DateTime? createdAt,
  }) : super._(
         id: id,
         orderId: orderId,
         order: order,
         vendorId: vendorId,
         vendor: vendor,
         stage: stage,
         note: note,
         photoUrl: photoUrl,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [OrderDeliveryUpdate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderDeliveryUpdate copyWith({
    Object? id = _Undefined,
    int? orderId,
    Object? order = _Undefined,
    _i1.UuidValue? vendorId,
    Object? vendor = _Undefined,
    _i4.DeliveryStage? stage,
    Object? note = _Undefined,
    Object? photoUrl = _Undefined,
    DateTime? createdAt,
  }) {
    return OrderDeliveryUpdate(
      id: id is int? ? id : this.id,
      orderId: orderId ?? this.orderId,
      order: order is _i2.Order? ? order : this.order?.copyWith(),
      vendorId: vendorId ?? this.vendorId,
      vendor: vendor is _i3.Vendor? ? vendor : this.vendor?.copyWith(),
      stage: stage ?? this.stage,
      note: note is String? ? note : this.note,
      photoUrl: photoUrl is String? ? photoUrl : this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
