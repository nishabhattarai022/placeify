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

/// Active special offer row for the home carousel.
abstract class SpecialOfferSummary implements _i1.SerializableModel {
  SpecialOfferSummary._({
    required this.productId,
    required this.productName,
    this.imageUrl,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercent,
    required this.tagline,
    required this.cardColorHex,
  });

  factory SpecialOfferSummary({
    required int productId,
    required String productName,
    String? imageUrl,
    required double originalPrice,
    required double discountedPrice,
    required int discountPercent,
    required String tagline,
    required String cardColorHex,
  }) = _SpecialOfferSummaryImpl;

  factory SpecialOfferSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return SpecialOfferSummary(
      productId: jsonSerialization['productId'] as int,
      productName: jsonSerialization['productName'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      originalPrice: (jsonSerialization['originalPrice'] as num).toDouble(),
      discountedPrice: (jsonSerialization['discountedPrice'] as num).toDouble(),
      discountPercent: jsonSerialization['discountPercent'] as int,
      tagline: jsonSerialization['tagline'] as String,
      cardColorHex: jsonSerialization['cardColorHex'] as String,
    );
  }

  int productId;

  String productName;

  String? imageUrl;

  double originalPrice;

  double discountedPrice;

  int discountPercent;

  String tagline;

  String cardColorHex;

  /// Returns a shallow copy of this [SpecialOfferSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SpecialOfferSummary copyWith({
    int? productId,
    String? productName,
    String? imageUrl,
    double? originalPrice,
    double? discountedPrice,
    int? discountPercent,
    String? tagline,
    String? cardColorHex,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SpecialOfferSummary',
      'productId': productId,
      'productName': productName,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'discountPercent': discountPercent,
      'tagline': tagline,
      'cardColorHex': cardColorHex,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SpecialOfferSummaryImpl extends SpecialOfferSummary {
  _SpecialOfferSummaryImpl({
    required int productId,
    required String productName,
    String? imageUrl,
    required double originalPrice,
    required double discountedPrice,
    required int discountPercent,
    required String tagline,
    required String cardColorHex,
  }) : super._(
         productId: productId,
         productName: productName,
         imageUrl: imageUrl,
         originalPrice: originalPrice,
         discountedPrice: discountedPrice,
         discountPercent: discountPercent,
         tagline: tagline,
         cardColorHex: cardColorHex,
       );

  /// Returns a shallow copy of this [SpecialOfferSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SpecialOfferSummary copyWith({
    int? productId,
    String? productName,
    Object? imageUrl = _Undefined,
    double? originalPrice,
    double? discountedPrice,
    int? discountPercent,
    String? tagline,
    String? cardColorHex,
  }) {
    return SpecialOfferSummary(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      originalPrice: originalPrice ?? this.originalPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      tagline: tagline ?? this.tagline,
      cardColorHex: cardColorHex ?? this.cardColorHex,
    );
  }
}
