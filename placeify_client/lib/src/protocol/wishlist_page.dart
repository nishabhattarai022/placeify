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
import 'wishlist_item.dart' as _i2;
import 'package:placeify_client/src/protocol/protocol.dart' as _i3;

/// Paginated wishlist response.
abstract class WishlistPage implements _i1.SerializableModel {
  WishlistPage._({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory WishlistPage({
    required List<_i2.WishlistItem> items,
    required int total,
    required int page,
    required int pageSize,
  }) = _WishlistPageImpl;

  factory WishlistPage.fromJson(Map<String, dynamic> jsonSerialization) {
    return WishlistPage(
      items: _i3.Protocol().deserialize<List<_i2.WishlistItem>>(
        jsonSerialization['items'],
      ),
      total: jsonSerialization['total'] as int,
      page: jsonSerialization['page'] as int,
      pageSize: jsonSerialization['pageSize'] as int,
    );
  }

  List<_i2.WishlistItem> items;

  int total;

  int page;

  int pageSize;

  /// Returns a shallow copy of this [WishlistPage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WishlistPage copyWith({
    List<_i2.WishlistItem>? items,
    int? total,
    int? page,
    int? pageSize,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WishlistPage',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'total': total,
      'page': page,
      'pageSize': pageSize,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _WishlistPageImpl extends WishlistPage {
  _WishlistPageImpl({
    required List<_i2.WishlistItem> items,
    required int total,
    required int page,
    required int pageSize,
  }) : super._(
         items: items,
         total: total,
         page: page,
         pageSize: pageSize,
       );

  /// Returns a shallow copy of this [WishlistPage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WishlistPage copyWith({
    List<_i2.WishlistItem>? items,
    int? total,
    int? page,
    int? pageSize,
  }) {
    return WishlistPage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      total: total ?? this.total,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
