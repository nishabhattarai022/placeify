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
import 'admin_product_visibility_filter.dart' as _i2;
import 'pagination_input.dart' as _i3;
import 'package:placeify_client/src/protocol/protocol.dart' as _i4;

/// Filters for admin product listing.
abstract class AdminProductListInput implements _i1.SerializableModel {
  AdminProductListInput._({
    this.query,
    _i2.AdminProductVisibilityFilter? visibility,
    this.categoryId,
    this.vendorId,
    bool? reportedOnly,
    bool? sortNewest,
    this.pagination,
  }) : visibility = visibility ?? _i2.AdminProductVisibilityFilter.all,
       reportedOnly = reportedOnly ?? false,
       sortNewest = sortNewest ?? true;

  factory AdminProductListInput({
    String? query,
    _i2.AdminProductVisibilityFilter? visibility,
    int? categoryId,
    _i1.UuidValue? vendorId,
    bool? reportedOnly,
    bool? sortNewest,
    _i3.PaginationInput? pagination,
  }) = _AdminProductListInputImpl;

  factory AdminProductListInput.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminProductListInput(
      query: jsonSerialization['query'] as String?,
      visibility: jsonSerialization['visibility'] == null
          ? null
          : _i2.AdminProductVisibilityFilter.fromJson(
              (jsonSerialization['visibility'] as String),
            ),
      categoryId: jsonSerialization['categoryId'] as int?,
      vendorId: jsonSerialization['vendorId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['vendorId']),
      reportedOnly: jsonSerialization['reportedOnly'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['reportedOnly']),
      sortNewest: jsonSerialization['sortNewest'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['sortNewest']),
      pagination: jsonSerialization['pagination'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.PaginationInput>(
              jsonSerialization['pagination'],
            ),
    );
  }

  String? query;

  _i2.AdminProductVisibilityFilter visibility;

  int? categoryId;

  _i1.UuidValue? vendorId;

  /// When true, only products with at least one complaint are returned.
  bool reportedOnly;

  bool sortNewest;

  _i3.PaginationInput? pagination;

  /// Returns a shallow copy of this [AdminProductListInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminProductListInput copyWith({
    String? query,
    _i2.AdminProductVisibilityFilter? visibility,
    int? categoryId,
    _i1.UuidValue? vendorId,
    bool? reportedOnly,
    bool? sortNewest,
    _i3.PaginationInput? pagination,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminProductListInput',
      if (query != null) 'query': query,
      'visibility': visibility.toJson(),
      if (categoryId != null) 'categoryId': categoryId,
      if (vendorId != null) 'vendorId': vendorId?.toJson(),
      'reportedOnly': reportedOnly,
      'sortNewest': sortNewest,
      if (pagination != null) 'pagination': pagination?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminProductListInputImpl extends AdminProductListInput {
  _AdminProductListInputImpl({
    String? query,
    _i2.AdminProductVisibilityFilter? visibility,
    int? categoryId,
    _i1.UuidValue? vendorId,
    bool? reportedOnly,
    bool? sortNewest,
    _i3.PaginationInput? pagination,
  }) : super._(
         query: query,
         visibility: visibility,
         categoryId: categoryId,
         vendorId: vendorId,
         reportedOnly: reportedOnly,
         sortNewest: sortNewest,
         pagination: pagination,
       );

  /// Returns a shallow copy of this [AdminProductListInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminProductListInput copyWith({
    Object? query = _Undefined,
    _i2.AdminProductVisibilityFilter? visibility,
    Object? categoryId = _Undefined,
    Object? vendorId = _Undefined,
    bool? reportedOnly,
    bool? sortNewest,
    Object? pagination = _Undefined,
  }) {
    return AdminProductListInput(
      query: query is String? ? query : this.query,
      visibility: visibility ?? this.visibility,
      categoryId: categoryId is int? ? categoryId : this.categoryId,
      vendorId: vendorId is _i1.UuidValue? ? vendorId : this.vendorId,
      reportedOnly: reportedOnly ?? this.reportedOnly,
      sortNewest: sortNewest ?? this.sortNewest,
      pagination: pagination is _i3.PaginationInput?
          ? pagination
          : this.pagination?.copyWith(),
    );
  }
}
