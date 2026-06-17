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
import 'product.dart' as _i3;
import 'vendor.dart' as _i4;
import 'package:placeify_client/src/protocol/protocol.dart' as _i5;

/// Line item within an order.
abstract class OrderItem implements _i1.SerializableModel {
  OrderItem._({
    this.id,
    required this.orderId,
    this.order,
    required this.productId,
    this.product,
    required this.vendorId,
    this.vendor,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderItem({
    int? id,
    required int orderId,
    _i2.Order? order,
    required int productId,
    _i3.Product? product,
    required _i1.UuidValue vendorId,
    _i4.Vendor? vendor,
    required int quantity,
    required double unitPrice,
  }) = _OrderItemImpl;

  factory OrderItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderItem(
      id: jsonSerialization['id'] as int?,
      orderId: jsonSerialization['orderId'] as int,
      order: jsonSerialization['order'] == null
          ? null
          : _i5.Protocol().deserialize<_i2.Order>(jsonSerialization['order']),
      productId: jsonSerialization['productId'] as int,
      product: jsonSerialization['product'] == null
          ? null
          : _i5.Protocol().deserialize<_i3.Product>(
              jsonSerialization['product'],
            ),
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      vendor: jsonSerialization['vendor'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.Vendor>(jsonSerialization['vendor']),
      quantity: jsonSerialization['quantity'] as int,
      unitPrice: (jsonSerialization['unitPrice'] as num).toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int orderId;

  _i2.Order? order;

  int productId;

  _i3.Product? product;

  _i1.UuidValue vendorId;

  _i4.Vendor? vendor;

  int quantity;

  double unitPrice;

  /// Returns a shallow copy of this [OrderItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderItem copyWith({
    int? id,
    int? orderId,
    _i2.Order? order,
    int? productId,
    _i3.Product? product,
    _i1.UuidValue? vendorId,
    _i4.Vendor? vendor,
    int? quantity,
    double? unitPrice,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderItem',
      if (id != null) 'id': id,
      'orderId': orderId,
      if (order != null) 'order': order?.toJson(),
      'productId': productId,
      if (product != null) 'product': product?.toJson(),
      'vendorId': vendorId.toJson(),
      if (vendor != null) 'vendor': vendor?.toJson(),
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderItemImpl extends OrderItem {
  _OrderItemImpl({
    int? id,
    required int orderId,
    _i2.Order? order,
    required int productId,
    _i3.Product? product,
    required _i1.UuidValue vendorId,
    _i4.Vendor? vendor,
    required int quantity,
    required double unitPrice,
  }) : super._(
         id: id,
         orderId: orderId,
         order: order,
         productId: productId,
         product: product,
         vendorId: vendorId,
         vendor: vendor,
         quantity: quantity,
         unitPrice: unitPrice,
       );

  /// Returns a shallow copy of this [OrderItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderItem copyWith({
    Object? id = _Undefined,
    int? orderId,
    Object? order = _Undefined,
    int? productId,
    Object? product = _Undefined,
    _i1.UuidValue? vendorId,
    Object? vendor = _Undefined,
    int? quantity,
    double? unitPrice,
  }) {
    return OrderItem(
      id: id is int? ? id : this.id,
      orderId: orderId ?? this.orderId,
      order: order is _i2.Order? ? order : this.order?.copyWith(),
      productId: productId ?? this.productId,
      product: product is _i3.Product? ? product : this.product?.copyWith(),
      vendorId: vendorId ?? this.vendorId,
      vendor: vendor is _i4.Vendor? ? vendor : this.vendor?.copyWith(),
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}
