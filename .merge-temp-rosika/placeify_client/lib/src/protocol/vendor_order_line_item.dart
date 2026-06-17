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

/// Product line in a customer order for one vendor shop.
abstract class VendorOrderLineItem implements _i1.SerializableModel {
  VendorOrderLineItem._({
    required this.orderItemId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    this.thumbnailUrl,
  });

  factory VendorOrderLineItem({
    required int orderItemId,
    required int productId,
    required String productName,
    required int quantity,
    required double unitPrice,
    required double lineTotal,
    String? thumbnailUrl,
  }) = _VendorOrderLineItemImpl;

  factory VendorOrderLineItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return VendorOrderLineItem(
      orderItemId: jsonSerialization['orderItemId'] as int,
      productId: jsonSerialization['productId'] as int,
      productName: jsonSerialization['productName'] as String,
      quantity: jsonSerialization['quantity'] as int,
      unitPrice: (jsonSerialization['unitPrice'] as num).toDouble(),
      lineTotal: (jsonSerialization['lineTotal'] as num).toDouble(),
      thumbnailUrl: jsonSerialization['thumbnailUrl'] as String?,
    );
  }

  int orderItemId;

  int productId;

  String productName;

  int quantity;

  double unitPrice;

  double lineTotal;

  String? thumbnailUrl;

  /// Returns a shallow copy of this [VendorOrderLineItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorOrderLineItem copyWith({
    int? orderItemId,
    int? productId,
    String? productName,
    int? quantity,
    double? unitPrice,
    double? lineTotal,
    String? thumbnailUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorOrderLineItem',
      'orderItemId': orderItemId,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'lineTotal': lineTotal,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorOrderLineItemImpl extends VendorOrderLineItem {
  _VendorOrderLineItemImpl({
    required int orderItemId,
    required int productId,
    required String productName,
    required int quantity,
    required double unitPrice,
    required double lineTotal,
    String? thumbnailUrl,
  }) : super._(
         orderItemId: orderItemId,
         productId: productId,
         productName: productName,
         quantity: quantity,
         unitPrice: unitPrice,
         lineTotal: lineTotal,
         thumbnailUrl: thumbnailUrl,
       );

  /// Returns a shallow copy of this [VendorOrderLineItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorOrderLineItem copyWith({
    int? orderItemId,
    int? productId,
    String? productName,
    int? quantity,
    double? unitPrice,
    double? lineTotal,
    Object? thumbnailUrl = _Undefined,
  }) {
    return VendorOrderLineItem(
      orderItemId: orderItemId ?? this.orderItemId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      lineTotal: lineTotal ?? this.lineTotal,
      thumbnailUrl: thumbnailUrl is String? ? thumbnailUrl : this.thumbnailUrl,
    );
  }
}
