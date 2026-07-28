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

/// Product line in a customer order detail view.
abstract class UserOrderLineItem
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  UserOrderLineItem._({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    this.thumbnailUrl,
    this.vendorId,
    this.vendorName,
    this.listUnitPrice,
  });

  factory UserOrderLineItem({
    required int productId,
    required String productName,
    required int quantity,
    required double unitPrice,
    required double lineTotal,
    String? thumbnailUrl,
    _i1.UuidValue? vendorId,
    String? vendorName,
    double? listUnitPrice,
  }) = _UserOrderLineItemImpl;

  factory UserOrderLineItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserOrderLineItem(
      productId: jsonSerialization['productId'] as int,
      productName: jsonSerialization['productName'] as String,
      quantity: jsonSerialization['quantity'] as int,
      unitPrice: (jsonSerialization['unitPrice'] as num).toDouble(),
      lineTotal: (jsonSerialization['lineTotal'] as num).toDouble(),
      thumbnailUrl: jsonSerialization['thumbnailUrl'] as String?,
      vendorId: jsonSerialization['vendorId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['vendorId']),
      vendorName: jsonSerialization['vendorName'] as String?,
      listUnitPrice: (jsonSerialization['listUnitPrice'] as num?)?.toDouble(),
    );
  }

  int productId;

  String productName;

  int quantity;

  double unitPrice;

  double lineTotal;

  String? thumbnailUrl;

  _i1.UuidValue? vendorId;

  String? vendorName;

  /// Catalog list price at read time (for discount display when higher than unitPrice).
  double? listUnitPrice;

  /// Returns a shallow copy of this [UserOrderLineItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserOrderLineItem copyWith({
    int? productId,
    String? productName,
    int? quantity,
    double? unitPrice,
    double? lineTotal,
    String? thumbnailUrl,
    _i1.UuidValue? vendorId,
    String? vendorName,
    double? listUnitPrice,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserOrderLineItem',
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'lineTotal': lineTotal,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      if (vendorId != null) 'vendorId': vendorId?.toJson(),
      if (vendorName != null) 'vendorName': vendorName,
      if (listUnitPrice != null) 'listUnitPrice': listUnitPrice,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserOrderLineItem',
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'lineTotal': lineTotal,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      if (vendorId != null) 'vendorId': vendorId?.toJson(),
      if (vendorName != null) 'vendorName': vendorName,
      if (listUnitPrice != null) 'listUnitPrice': listUnitPrice,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserOrderLineItemImpl extends UserOrderLineItem {
  _UserOrderLineItemImpl({
    required int productId,
    required String productName,
    required int quantity,
    required double unitPrice,
    required double lineTotal,
    String? thumbnailUrl,
    _i1.UuidValue? vendorId,
    String? vendorName,
    double? listUnitPrice,
  }) : super._(
         productId: productId,
         productName: productName,
         quantity: quantity,
         unitPrice: unitPrice,
         lineTotal: lineTotal,
         thumbnailUrl: thumbnailUrl,
         vendorId: vendorId,
         vendorName: vendorName,
         listUnitPrice: listUnitPrice,
       );

  /// Returns a shallow copy of this [UserOrderLineItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserOrderLineItem copyWith({
    int? productId,
    String? productName,
    int? quantity,
    double? unitPrice,
    double? lineTotal,
    Object? thumbnailUrl = _Undefined,
    Object? vendorId = _Undefined,
    Object? vendorName = _Undefined,
    Object? listUnitPrice = _Undefined,
  }) {
    return UserOrderLineItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      lineTotal: lineTotal ?? this.lineTotal,
      thumbnailUrl: thumbnailUrl is String? ? thumbnailUrl : this.thumbnailUrl,
      vendorId: vendorId is _i1.UuidValue? ? vendorId : this.vendorId,
      vendorName: vendorName is String? ? vendorName : this.vendorName,
      listUnitPrice: listUnitPrice is double?
          ? listUnitPrice
          : this.listUnitPrice,
    );
  }
}
