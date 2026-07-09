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
import 'order_payment_status.dart' as _i4;

/// Order row for the customer profile orders list.
abstract class UserOrderSummary implements _i1.SerializableModel {
  UserOrderSummary._({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    required this.placedAt,
    required this.itemCount,
    this.primaryProductName,
    this.latestDeliveryStage,
    this.latestDeliveryNote,
    required this.orderPaymentStatus,
  });

  factory UserOrderSummary({
    required int id,
    required String orderNumber,
    required _i2.OrderStatus status,
    required double totalAmount,
    required DateTime placedAt,
    required int itemCount,
    String? primaryProductName,
    _i3.DeliveryStage? latestDeliveryStage,
    String? latestDeliveryNote,
    required _i4.OrderPaymentStatus orderPaymentStatus,
  }) = _UserOrderSummaryImpl;

  factory UserOrderSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserOrderSummary(
      id: jsonSerialization['id'] as int,
      orderNumber: jsonSerialization['orderNumber'] as String,
      status: _i2.OrderStatus.fromJson((jsonSerialization['status'] as String)),
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
      placedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['placedAt'],
      ),
      itemCount: jsonSerialization['itemCount'] as int,
      primaryProductName: jsonSerialization['primaryProductName'] as String?,
      latestDeliveryStage: jsonSerialization['latestDeliveryStage'] == null
          ? null
          : _i3.DeliveryStage.fromJson(
              (jsonSerialization['latestDeliveryStage'] as String),
            ),
      latestDeliveryNote: jsonSerialization['latestDeliveryNote'] as String?,
      orderPaymentStatus: _i4.OrderPaymentStatus.fromJson(
        (jsonSerialization['orderPaymentStatus'] as String),
      ),
    );
  }

  int id;

  String orderNumber;

  _i2.OrderStatus status;

  double totalAmount;

  DateTime placedAt;

  int itemCount;

  String? primaryProductName;

  _i3.DeliveryStage? latestDeliveryStage;

  String? latestDeliveryNote;

  _i4.OrderPaymentStatus orderPaymentStatus;

  /// Returns a shallow copy of this [UserOrderSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserOrderSummary copyWith({
    int? id,
    String? orderNumber,
    _i2.OrderStatus? status,
    double? totalAmount,
    DateTime? placedAt,
    int? itemCount,
    String? primaryProductName,
    _i3.DeliveryStage? latestDeliveryStage,
    String? latestDeliveryNote,
    _i4.OrderPaymentStatus? orderPaymentStatus,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserOrderSummary',
      'id': id,
      'orderNumber': orderNumber,
      'status': status.toJson(),
      'totalAmount': totalAmount,
      'placedAt': placedAt.toJson(),
      'itemCount': itemCount,
      if (primaryProductName != null) 'primaryProductName': primaryProductName,
      if (latestDeliveryStage != null)
        'latestDeliveryStage': latestDeliveryStage?.toJson(),
      if (latestDeliveryNote != null) 'latestDeliveryNote': latestDeliveryNote,
      'orderPaymentStatus': orderPaymentStatus.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserOrderSummaryImpl extends UserOrderSummary {
  _UserOrderSummaryImpl({
    required int id,
    required String orderNumber,
    required _i2.OrderStatus status,
    required double totalAmount,
    required DateTime placedAt,
    required int itemCount,
    String? primaryProductName,
    _i3.DeliveryStage? latestDeliveryStage,
    String? latestDeliveryNote,
    required _i4.OrderPaymentStatus orderPaymentStatus,
  }) : super._(
         id: id,
         orderNumber: orderNumber,
         status: status,
         totalAmount: totalAmount,
         placedAt: placedAt,
         itemCount: itemCount,
         primaryProductName: primaryProductName,
         latestDeliveryStage: latestDeliveryStage,
         latestDeliveryNote: latestDeliveryNote,
         orderPaymentStatus: orderPaymentStatus,
       );

  /// Returns a shallow copy of this [UserOrderSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserOrderSummary copyWith({
    int? id,
    String? orderNumber,
    _i2.OrderStatus? status,
    double? totalAmount,
    DateTime? placedAt,
    int? itemCount,
    Object? primaryProductName = _Undefined,
    Object? latestDeliveryStage = _Undefined,
    Object? latestDeliveryNote = _Undefined,
    _i4.OrderPaymentStatus? orderPaymentStatus,
  }) {
    return UserOrderSummary(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      placedAt: placedAt ?? this.placedAt,
      itemCount: itemCount ?? this.itemCount,
      primaryProductName: primaryProductName is String?
          ? primaryProductName
          : this.primaryProductName,
      latestDeliveryStage: latestDeliveryStage is _i3.DeliveryStage?
          ? latestDeliveryStage
          : this.latestDeliveryStage,
      latestDeliveryNote: latestDeliveryNote is String?
          ? latestDeliveryNote
          : this.latestDeliveryNote,
      orderPaymentStatus: orderPaymentStatus ?? this.orderPaymentStatus,
    );
  }
}
