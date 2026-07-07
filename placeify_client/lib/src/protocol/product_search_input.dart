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
import 'pagination_input.dart' as _i2;
import 'package:placeify_client/src/protocol/protocol.dart' as _i3;

/// Search and filter parameters for product browsing.
abstract class ProductSearchInput implements _i1.SerializableModel {
  ProductSearchInput._({
    this.query,
    this.categoryName,
    this.vendorId,
    this.minPrice,
    this.maxPrice,
    bool? featuredOnly,
    bool? offersOnly,
    this.pagination,
  }) : featuredOnly = featuredOnly ?? false,
       offersOnly = offersOnly ?? false;

  factory ProductSearchInput({
    String? query,
    String? categoryName,
    _i1.UuidValue? vendorId,
    double? minPrice,
    double? maxPrice,
    bool? featuredOnly,
    bool? offersOnly,
    _i2.PaginationInput? pagination,
  }) = _ProductSearchInputImpl;

  factory ProductSearchInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductSearchInput(
      query: jsonSerialization['query'] as String?,
      categoryName: jsonSerialization['categoryName'] as String?,
      vendorId: jsonSerialization['vendorId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['vendorId']),
      minPrice: (jsonSerialization['minPrice'] as num?)?.toDouble(),
      maxPrice: (jsonSerialization['maxPrice'] as num?)?.toDouble(),
      featuredOnly: jsonSerialization['featuredOnly'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['featuredOnly']),
      offersOnly: jsonSerialization['offersOnly'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['offersOnly']),
      pagination: jsonSerialization['pagination'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.PaginationInput>(
              jsonSerialization['pagination'],
            ),
    );
  }

  String? query;

  String? categoryName;

  _i1.UuidValue? vendorId;

  double? minPrice;

  double? maxPrice;

  /// When true, only products flagged [Product.featured] by the vendor.
  bool featuredOnly;

  /// When true, only products with an active offer ([Product.isOffer]).
  bool offersOnly;

  _i2.PaginationInput? pagination;

  /// Returns a shallow copy of this [ProductSearchInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProductSearchInput copyWith({
    String? query,
    String? categoryName,
    _i1.UuidValue? vendorId,
    double? minPrice,
    double? maxPrice,
    bool? featuredOnly,
    bool? offersOnly,
    _i2.PaginationInput? pagination,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductSearchInput',
      if (query != null) 'query': query,
      if (categoryName != null) 'categoryName': categoryName,
      if (vendorId != null) 'vendorId': vendorId?.toJson(),
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
      'featuredOnly': featuredOnly,
      'offersOnly': offersOnly,
      if (pagination != null) 'pagination': pagination?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductSearchInputImpl extends ProductSearchInput {
  _ProductSearchInputImpl({
    String? query,
    String? categoryName,
    _i1.UuidValue? vendorId,
    double? minPrice,
    double? maxPrice,
    bool? featuredOnly,
    bool? offersOnly,
    _i2.PaginationInput? pagination,
  }) : super._(
         query: query,
         categoryName: categoryName,
         vendorId: vendorId,
         minPrice: minPrice,
         maxPrice: maxPrice,
         featuredOnly: featuredOnly,
         offersOnly: offersOnly,
         pagination: pagination,
       );

  /// Returns a shallow copy of this [ProductSearchInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProductSearchInput copyWith({
    Object? query = _Undefined,
    Object? categoryName = _Undefined,
    Object? vendorId = _Undefined,
    Object? minPrice = _Undefined,
    Object? maxPrice = _Undefined,
    bool? featuredOnly,
    bool? offersOnly,
    Object? pagination = _Undefined,
  }) {
    return ProductSearchInput(
      query: query is String? ? query : this.query,
      categoryName: categoryName is String? ? categoryName : this.categoryName,
      vendorId: vendorId is _i1.UuidValue? ? vendorId : this.vendorId,
      minPrice: minPrice is double? ? minPrice : this.minPrice,
      maxPrice: maxPrice is double? ? maxPrice : this.maxPrice,
      featuredOnly: featuredOnly ?? this.featuredOnly,
      offersOnly: offersOnly ?? this.offersOnly,
      pagination: pagination is _i2.PaginationInput?
          ? pagination
          : this.pagination?.copyWith(),
    );
  }
}
