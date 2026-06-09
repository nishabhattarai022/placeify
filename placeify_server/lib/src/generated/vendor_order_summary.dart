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

/// Order line item shown on the vendor dashboard.
abstract class VendorOrderSummary
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  VendorOrderSummary._({
    required this.orderItemId,
    required this.orderId,
    required this.orderNumber,
    required this.productName,
    required this.quantity,
    required this.lineTotal,
    required this.status,
    required this.placedAt,
    this.customerName,
    bool? isCustomizationRequest,
    this.requestMeta,
  }) : isCustomizationRequest = isCustomizationRequest ?? false;

  factory VendorOrderSummary({
    required int orderItemId,
    required int orderId,
    required String orderNumber,
    required String productName,
    required int quantity,
    required double lineTotal,
    required _i2.OrderStatus status,
    required DateTime placedAt,
    String? customerName,
    bool? isCustomizationRequest,
    String? requestMeta,
  }) = _VendorOrderSummaryImpl;

  factory VendorOrderSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return VendorOrderSummary(
      orderItemId: jsonSerialization['orderItemId'] as int,
      orderId: jsonSerialization['orderId'] as int,
      orderNumber: jsonSerialization['orderNumber'] as String,
      productName: jsonSerialization['productName'] as String,
      quantity: jsonSerialization['quantity'] as int,
      lineTotal: (jsonSerialization['lineTotal'] as num).toDouble(),
      status: _i2.OrderStatus.fromJson((jsonSerialization['status'] as String)),
      placedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['placedAt'],
      ),
      customerName: jsonSerialization['customerName'] as String?,
      isCustomizationRequest:
          jsonSerialization['isCustomizationRequest'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['isCustomizationRequest'],
            ),
      requestMeta: jsonSerialization['requestMeta'] as String?,
    );
  }

  int orderItemId;

  int orderId;

  String orderNumber;

  String productName;

  int quantity;

  double lineTotal;

  _i2.OrderStatus status;

  DateTime placedAt;

  String? customerName;

  bool isCustomizationRequest;

  String? requestMeta;

  /// Returns a shallow copy of this [VendorOrderSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorOrderSummary copyWith({
    int? orderItemId,
    int? orderId,
    String? orderNumber,
    String? productName,
    int? quantity,
    double? lineTotal,
    _i2.OrderStatus? status,
    DateTime? placedAt,
    String? customerName,
    bool? isCustomizationRequest,
    String? requestMeta,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorOrderSummary',
      'orderItemId': orderItemId,
      'orderId': orderId,
      'orderNumber': orderNumber,
      'productName': productName,
      'quantity': quantity,
      'lineTotal': lineTotal,
      'status': status.toJson(),
      'placedAt': placedAt.toJson(),
      if (customerName != null) 'customerName': customerName,
      'isCustomizationRequest': isCustomizationRequest,
      if (requestMeta != null) 'requestMeta': requestMeta,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VendorOrderSummary',
      'orderItemId': orderItemId,
      'orderId': orderId,
      'orderNumber': orderNumber,
      'productName': productName,
      'quantity': quantity,
      'lineTotal': lineTotal,
      'status': status.toJson(),
      'placedAt': placedAt.toJson(),
      if (customerName != null) 'customerName': customerName,
      'isCustomizationRequest': isCustomizationRequest,
      if (requestMeta != null) 'requestMeta': requestMeta,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorOrderSummaryImpl extends VendorOrderSummary {
  _VendorOrderSummaryImpl({
    required int orderItemId,
    required int orderId,
    required String orderNumber,
    required String productName,
    required int quantity,
    required double lineTotal,
    required _i2.OrderStatus status,
    required DateTime placedAt,
    String? customerName,
    bool? isCustomizationRequest,
    String? requestMeta,
  }) : super._(
         orderItemId: orderItemId,
         orderId: orderId,
         orderNumber: orderNumber,
         productName: productName,
         quantity: quantity,
         lineTotal: lineTotal,
         status: status,
         placedAt: placedAt,
         customerName: customerName,
         isCustomizationRequest: isCustomizationRequest,
         requestMeta: requestMeta,
       );

  /// Returns a shallow copy of this [VendorOrderSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorOrderSummary copyWith({
    int? orderItemId,
    int? orderId,
    String? orderNumber,
    String? productName,
    int? quantity,
    double? lineTotal,
    _i2.OrderStatus? status,
    DateTime? placedAt,
    Object? customerName = _Undefined,
    bool? isCustomizationRequest,
    Object? requestMeta = _Undefined,
  }) {
    return VendorOrderSummary(
      orderItemId: orderItemId ?? this.orderItemId,
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      lineTotal: lineTotal ?? this.lineTotal,
      status: status ?? this.status,
      placedAt: placedAt ?? this.placedAt,
      customerName: customerName is String? ? customerName : this.customerName,
      isCustomizationRequest:
          isCustomizationRequest ?? this.isCustomizationRequest,
      requestMeta: requestMeta is String? ? requestMeta : this.requestMeta,
    );
  }
}
