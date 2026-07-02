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
import 'product.dart' as _i2;
import 'package:placeify_client/src/protocol/protocol.dart' as _i3;

/// Vendor special offer linked to a single catalog product.
abstract class SpecialOffer implements _i1.SerializableModel {
  SpecialOffer._({
    this.id,
    required this.productId,
    this.product,
    required this.originalPrice,
    required this.discountedPrice,
    required this.tagline,
    String? cardColorHex,
    bool? isActive,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : cardColorHex = cardColorHex ?? '#A8B5A0',
       isActive = isActive ?? true,
       displayOrder = displayOrder ?? 0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory SpecialOffer({
    int? id,
    required int productId,
    _i2.Product? product,
    required double originalPrice,
    required double discountedPrice,
    required String tagline,
    String? cardColorHex,
    bool? isActive,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SpecialOfferImpl;

  factory SpecialOffer.fromJson(Map<String, dynamic> jsonSerialization) {
    return SpecialOffer(
      id: jsonSerialization['id'] as int?,
      productId: jsonSerialization['productId'] as int,
      product: jsonSerialization['product'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Product>(
              jsonSerialization['product'],
            ),
      originalPrice: (jsonSerialization['originalPrice'] as num).toDouble(),
      discountedPrice: (jsonSerialization['discountedPrice'] as num).toDouble(),
      tagline: jsonSerialization['tagline'] as String,
      cardColorHex: jsonSerialization['cardColorHex'] as String?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      displayOrder: jsonSerialization['displayOrder'] as int?,
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

  int productId;

  _i2.Product? product;

  double originalPrice;

  double discountedPrice;

  String tagline;

  String cardColorHex;

  bool isActive;

  int displayOrder;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [SpecialOffer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SpecialOffer copyWith({
    int? id,
    int? productId,
    _i2.Product? product,
    double? originalPrice,
    double? discountedPrice,
    String? tagline,
    String? cardColorHex,
    bool? isActive,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SpecialOffer',
      if (id != null) 'id': id,
      'productId': productId,
      if (product != null) 'product': product?.toJson(),
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'tagline': tagline,
      'cardColorHex': cardColorHex,
      'isActive': isActive,
      'displayOrder': displayOrder,
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

class _SpecialOfferImpl extends SpecialOffer {
  _SpecialOfferImpl({
    int? id,
    required int productId,
    _i2.Product? product,
    required double originalPrice,
    required double discountedPrice,
    required String tagline,
    String? cardColorHex,
    bool? isActive,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         productId: productId,
         product: product,
         originalPrice: originalPrice,
         discountedPrice: discountedPrice,
         tagline: tagline,
         cardColorHex: cardColorHex,
         isActive: isActive,
         displayOrder: displayOrder,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [SpecialOffer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SpecialOffer copyWith({
    Object? id = _Undefined,
    int? productId,
    Object? product = _Undefined,
    double? originalPrice,
    double? discountedPrice,
    String? tagline,
    String? cardColorHex,
    bool? isActive,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SpecialOffer(
      id: id is int? ? id : this.id,
      productId: productId ?? this.productId,
      product: product is _i2.Product? ? product : this.product?.copyWith(),
      originalPrice: originalPrice ?? this.originalPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      tagline: tagline ?? this.tagline,
      cardColorHex: cardColorHex ?? this.cardColorHex,
      isActive: isActive ?? this.isActive,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
