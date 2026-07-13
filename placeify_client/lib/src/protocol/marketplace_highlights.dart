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

/// Curated marketplace product rows for consumer dashboards and home feeds.
abstract class MarketplaceHighlights implements _i1.SerializableModel {
  MarketplaceHighlights._({
    required this.recentProducts,
    required this.featuredProducts,
    required this.offerProducts,
  });

  factory MarketplaceHighlights({
    required List<_i2.Product> recentProducts,
    required List<_i2.Product> featuredProducts,
    required List<_i2.Product> offerProducts,
  }) = _MarketplaceHighlightsImpl;

  factory MarketplaceHighlights.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return MarketplaceHighlights(
      recentProducts: _i3.Protocol().deserialize<List<_i2.Product>>(
        jsonSerialization['recentProducts'],
      ),
      featuredProducts: _i3.Protocol().deserialize<List<_i2.Product>>(
        jsonSerialization['featuredProducts'],
      ),
      offerProducts: _i3.Protocol().deserialize<List<_i2.Product>>(
        jsonSerialization['offerProducts'],
      ),
    );
  }

  List<_i2.Product> recentProducts;

  List<_i2.Product> featuredProducts;

  List<_i2.Product> offerProducts;

  /// Returns a shallow copy of this [MarketplaceHighlights]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MarketplaceHighlights copyWith({
    List<_i2.Product>? recentProducts,
    List<_i2.Product>? featuredProducts,
    List<_i2.Product>? offerProducts,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MarketplaceHighlights',
      'recentProducts': recentProducts.toJson(valueToJson: (v) => v.toJson()),
      'featuredProducts': featuredProducts.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'offerProducts': offerProducts.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _MarketplaceHighlightsImpl extends MarketplaceHighlights {
  _MarketplaceHighlightsImpl({
    required List<_i2.Product> recentProducts,
    required List<_i2.Product> featuredProducts,
    required List<_i2.Product> offerProducts,
  }) : super._(
         recentProducts: recentProducts,
         featuredProducts: featuredProducts,
         offerProducts: offerProducts,
       );

  /// Returns a shallow copy of this [MarketplaceHighlights]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MarketplaceHighlights copyWith({
    List<_i2.Product>? recentProducts,
    List<_i2.Product>? featuredProducts,
    List<_i2.Product>? offerProducts,
  }) {
    return MarketplaceHighlights(
      recentProducts:
          recentProducts ??
          this.recentProducts.map((e0) => e0.copyWith()).toList(),
      featuredProducts:
          featuredProducts ??
          this.featuredProducts.map((e0) => e0.copyWith()).toList(),
      offerProducts:
          offerProducts ??
          this.offerProducts.map((e0) => e0.copyWith()).toList(),
    );
  }
}
