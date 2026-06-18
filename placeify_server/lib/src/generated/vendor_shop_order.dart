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
import 'order_status.dart' as _i2;
import 'vendor_order_line_item.dart' as _i3;
import 'package:placeify_server/src/generated/protocol.dart' as _i4;

/// Customer order containing only items from the logged-in vendor's shop.
abstract class VendorShopOrder
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  VendorShopOrder._({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.placedAt,
    required this.customerName,
    required this.shippingAddress,
    required this.vendorTotal,
    required this.itemCount,
    required this.items,
    this.rejectionReason,
  });

  factory VendorShopOrder({
    required int orderId,
    required String orderNumber,
    required _i2.OrderStatus status,
    required DateTime placedAt,
    required String customerName,
    required String shippingAddress,
    required double vendorTotal,
    required int itemCount,
    required List<_i3.VendorOrderLineItem> items,
    String? rejectionReason,
  }) = _VendorShopOrderImpl;

  factory VendorShopOrder.fromJson(Map<String, dynamic> jsonSerialization) {
    return VendorShopOrder(
      orderId: jsonSerialization['orderId'] as int,
      orderNumber: jsonSerialization['orderNumber'] as String,
      status: _i2.OrderStatus.fromJson((jsonSerialization['status'] as String)),
      placedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['placedAt'],
      ),
      customerName: jsonSerialization['customerName'] as String,
      shippingAddress: jsonSerialization['shippingAddress'] as String,
      vendorTotal: (jsonSerialization['vendorTotal'] as num).toDouble(),
      itemCount: jsonSerialization['itemCount'] as int,
      items: _i4.Protocol().deserialize<List<_i3.VendorOrderLineItem>>(
        jsonSerialization['items'],
      ),
      rejectionReason: jsonSerialization['rejectionReason'] as String?,
    );
  }

  int orderId;

  String orderNumber;

  _i2.OrderStatus status;

  DateTime placedAt;

  String customerName;

  String shippingAddress;

  double vendorTotal;

  int itemCount;

  List<_i3.VendorOrderLineItem> items;

  String? rejectionReason;

  /// Returns a shallow copy of this [VendorShopOrder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorShopOrder copyWith({
    int? orderId,
    String? orderNumber,
    _i2.OrderStatus? status,
    DateTime? placedAt,
    String? customerName,
    String? shippingAddress,
    double? vendorTotal,
    int? itemCount,
    List<_i3.VendorOrderLineItem>? items,
    String? rejectionReason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorShopOrder',
      'orderId': orderId,
      'orderNumber': orderNumber,
      'status': status.toJson(),
      'placedAt': placedAt.toJson(),
      'customerName': customerName,
      'shippingAddress': shippingAddress,
      'vendorTotal': vendorTotal,
      'itemCount': itemCount,
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VendorShopOrder',
      'orderId': orderId,
      'orderNumber': orderNumber,
      'status': status.toJson(),
      'placedAt': placedAt.toJson(),
      'customerName': customerName,
      'shippingAddress': shippingAddress,
      'vendorTotal': vendorTotal,
      'itemCount': itemCount,
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorShopOrderImpl extends VendorShopOrder {
  _VendorShopOrderImpl({
    required int orderId,
    required String orderNumber,
    required _i2.OrderStatus status,
    required DateTime placedAt,
    required String customerName,
    required String shippingAddress,
    required double vendorTotal,
    required int itemCount,
    required List<_i3.VendorOrderLineItem> items,
    String? rejectionReason,
  }) : super._(
         orderId: orderId,
         orderNumber: orderNumber,
         status: status,
         placedAt: placedAt,
         customerName: customerName,
         shippingAddress: shippingAddress,
         vendorTotal: vendorTotal,
         itemCount: itemCount,
         items: items,
         rejectionReason: rejectionReason,
       );

  /// Returns a shallow copy of this [VendorShopOrder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorShopOrder copyWith({
    int? orderId,
    String? orderNumber,
    _i2.OrderStatus? status,
    DateTime? placedAt,
    String? customerName,
    String? shippingAddress,
    double? vendorTotal,
    int? itemCount,
    List<_i3.VendorOrderLineItem>? items,
    Object? rejectionReason = _Undefined,
  }) {
    return VendorShopOrder(
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      placedAt: placedAt ?? this.placedAt,
      customerName: customerName ?? this.customerName,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      vendorTotal: vendorTotal ?? this.vendorTotal,
      itemCount: itemCount ?? this.itemCount,
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      rejectionReason: rejectionReason is String?
          ? rejectionReason
          : this.rejectionReason,
    );
  }
}
