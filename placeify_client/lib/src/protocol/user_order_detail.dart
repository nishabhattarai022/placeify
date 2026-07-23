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
import 'delivery_stage.dart' as _i3;
import 'user_order_line_item.dart' as _i4;
import 'user_order_delivery_event.dart' as _i5;
import 'order_payment_status.dart' as _i6;
import 'user_order_payment_summary.dart' as _i7;
import 'user_order_payment_event.dart' as _i8;
import 'package:placeify_client/src/protocol/protocol.dart' as _i9;

/// Full customer order with line items and delivery timeline.
abstract class UserOrderDetail implements _i1.SerializableModel {
  UserOrderDetail._({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    required this.placedAt,
    required this.shippingAddress,
    required this.itemCount,
    this.primaryProductName,
    this.customerName,
    this.customerPhone,
    this.latestDeliveryStage,
    this.latestDeliveryNote,
    required this.items,
    required this.deliveryUpdates,
    required this.orderPaymentStatus,
    required this.payment,
    required this.paymentUpdates,
  });

  factory UserOrderDetail({
    required int id,
    required String orderNumber,
    required _i2.OrderStatus status,
    required double totalAmount,
    required DateTime placedAt,
    required String shippingAddress,
    required int itemCount,
    String? primaryProductName,
    String? customerName,
    String? customerPhone,
    _i3.DeliveryStage? latestDeliveryStage,
    String? latestDeliveryNote,
    required List<_i4.UserOrderLineItem> items,
    required List<_i5.UserOrderDeliveryEvent> deliveryUpdates,
    required _i6.OrderPaymentStatus orderPaymentStatus,
    required _i7.UserOrderPaymentSummary payment,
    required List<_i8.UserOrderPaymentEvent> paymentUpdates,
  }) = _UserOrderDetailImpl;

  factory UserOrderDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserOrderDetail(
      id: jsonSerialization['id'] as int,
      orderNumber: jsonSerialization['orderNumber'] as String,
      status: _i2.OrderStatus.fromJson((jsonSerialization['status'] as String)),
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
      placedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['placedAt'],
      ),
      shippingAddress: jsonSerialization['shippingAddress'] as String,
      itemCount: jsonSerialization['itemCount'] as int,
      primaryProductName: jsonSerialization['primaryProductName'] as String?,
      customerName: jsonSerialization['customerName'] as String?,
      customerPhone: jsonSerialization['customerPhone'] as String?,
      latestDeliveryStage: jsonSerialization['latestDeliveryStage'] == null
          ? null
          : _i3.DeliveryStage.fromJson(
              (jsonSerialization['latestDeliveryStage'] as String),
            ),
      latestDeliveryNote: jsonSerialization['latestDeliveryNote'] as String?,
      items: _i9.Protocol().deserialize<List<_i4.UserOrderLineItem>>(
        jsonSerialization['items'],
      ),
      deliveryUpdates: _i9.Protocol()
          .deserialize<List<_i5.UserOrderDeliveryEvent>>(
            jsonSerialization['deliveryUpdates'],
          ),
      orderPaymentStatus: _i6.OrderPaymentStatus.fromJson(
        (jsonSerialization['orderPaymentStatus'] as String),
      ),
      payment: _i9.Protocol().deserialize<_i7.UserOrderPaymentSummary>(
        jsonSerialization['payment'],
      ),
      paymentUpdates: _i9.Protocol()
          .deserialize<List<_i8.UserOrderPaymentEvent>>(
            jsonSerialization['paymentUpdates'],
          ),
    );
  }

  int id;

  String orderNumber;

  _i2.OrderStatus status;

  double totalAmount;

  DateTime placedAt;

  String shippingAddress;

  int itemCount;

  String? primaryProductName;

  /// Snapshot contact fields from the ordering user at read time.
  String? customerName;

  String? customerPhone;

  _i3.DeliveryStage? latestDeliveryStage;

  String? latestDeliveryNote;

  List<_i4.UserOrderLineItem> items;

  List<_i5.UserOrderDeliveryEvent> deliveryUpdates;

  _i6.OrderPaymentStatus orderPaymentStatus;

  _i7.UserOrderPaymentSummary payment;

  List<_i8.UserOrderPaymentEvent> paymentUpdates;

  /// Returns a shallow copy of this [UserOrderDetail]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserOrderDetail copyWith({
    int? id,
    String? orderNumber,
    _i2.OrderStatus? status,
    double? totalAmount,
    DateTime? placedAt,
    String? shippingAddress,
    int? itemCount,
    String? primaryProductName,
    String? customerName,
    String? customerPhone,
    _i3.DeliveryStage? latestDeliveryStage,
    String? latestDeliveryNote,
    List<_i4.UserOrderLineItem>? items,
    List<_i5.UserOrderDeliveryEvent>? deliveryUpdates,
    _i6.OrderPaymentStatus? orderPaymentStatus,
    _i7.UserOrderPaymentSummary? payment,
    List<_i8.UserOrderPaymentEvent>? paymentUpdates,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserOrderDetail',
      'id': id,
      'orderNumber': orderNumber,
      'status': status.toJson(),
      'totalAmount': totalAmount,
      'placedAt': placedAt.toJson(),
      'shippingAddress': shippingAddress,
      'itemCount': itemCount,
      if (primaryProductName != null) 'primaryProductName': primaryProductName,
      if (customerName != null) 'customerName': customerName,
      if (customerPhone != null) 'customerPhone': customerPhone,
      if (latestDeliveryStage != null)
        'latestDeliveryStage': latestDeliveryStage?.toJson(),
      if (latestDeliveryNote != null) 'latestDeliveryNote': latestDeliveryNote,
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'deliveryUpdates': deliveryUpdates.toJson(valueToJson: (v) => v.toJson()),
      'orderPaymentStatus': orderPaymentStatus.toJson(),
      'payment': payment.toJson(),
      'paymentUpdates': paymentUpdates.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserOrderDetailImpl extends UserOrderDetail {
  _UserOrderDetailImpl({
    required int id,
    required String orderNumber,
    required _i2.OrderStatus status,
    required double totalAmount,
    required DateTime placedAt,
    required String shippingAddress,
    required int itemCount,
    String? primaryProductName,
    String? customerName,
    String? customerPhone,
    _i3.DeliveryStage? latestDeliveryStage,
    String? latestDeliveryNote,
    required List<_i4.UserOrderLineItem> items,
    required List<_i5.UserOrderDeliveryEvent> deliveryUpdates,
    required _i6.OrderPaymentStatus orderPaymentStatus,
    required _i7.UserOrderPaymentSummary payment,
    required List<_i8.UserOrderPaymentEvent> paymentUpdates,
  }) : super._(
         id: id,
         orderNumber: orderNumber,
         status: status,
         totalAmount: totalAmount,
         placedAt: placedAt,
         shippingAddress: shippingAddress,
         itemCount: itemCount,
         primaryProductName: primaryProductName,
         customerName: customerName,
         customerPhone: customerPhone,
         latestDeliveryStage: latestDeliveryStage,
         latestDeliveryNote: latestDeliveryNote,
         items: items,
         deliveryUpdates: deliveryUpdates,
         orderPaymentStatus: orderPaymentStatus,
         payment: payment,
         paymentUpdates: paymentUpdates,
       );

  /// Returns a shallow copy of this [UserOrderDetail]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserOrderDetail copyWith({
    int? id,
    String? orderNumber,
    _i2.OrderStatus? status,
    double? totalAmount,
    DateTime? placedAt,
    String? shippingAddress,
    int? itemCount,
    Object? primaryProductName = _Undefined,
    Object? customerName = _Undefined,
    Object? customerPhone = _Undefined,
    Object? latestDeliveryStage = _Undefined,
    Object? latestDeliveryNote = _Undefined,
    List<_i4.UserOrderLineItem>? items,
    List<_i5.UserOrderDeliveryEvent>? deliveryUpdates,
    _i6.OrderPaymentStatus? orderPaymentStatus,
    _i7.UserOrderPaymentSummary? payment,
    List<_i8.UserOrderPaymentEvent>? paymentUpdates,
  }) {
    return UserOrderDetail(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      placedAt: placedAt ?? this.placedAt,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      itemCount: itemCount ?? this.itemCount,
      primaryProductName: primaryProductName is String?
          ? primaryProductName
          : this.primaryProductName,
      customerName: customerName is String? ? customerName : this.customerName,
      customerPhone: customerPhone is String?
          ? customerPhone
          : this.customerPhone,
      latestDeliveryStage: latestDeliveryStage is _i3.DeliveryStage?
          ? latestDeliveryStage
          : this.latestDeliveryStage,
      latestDeliveryNote: latestDeliveryNote is String?
          ? latestDeliveryNote
          : this.latestDeliveryNote,
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      deliveryUpdates:
          deliveryUpdates ??
          this.deliveryUpdates.map((e0) => e0.copyWith()).toList(),
      orderPaymentStatus: orderPaymentStatus ?? this.orderPaymentStatus,
      payment: payment ?? this.payment.copyWith(),
      paymentUpdates:
          paymentUpdates ??
          this.paymentUpdates.map((e0) => e0.copyWith()).toList(),
    );
  }
}
