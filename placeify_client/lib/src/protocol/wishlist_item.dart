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
import 'user.dart' as _i2;
import 'product.dart' as _i3;
import 'package:placeify_client/src/protocol/protocol.dart' as _i4;

/// Saved product in a customer's wishlist.
abstract class WishlistItem implements _i1.SerializableModel {
  WishlistItem._({
    this.id,
    required this.userId,
    this.user,
    required this.productId,
    this.product,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory WishlistItem({
    int? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required int productId,
    _i3.Product? product,
    DateTime? createdAt,
  }) = _WishlistItemImpl;

  factory WishlistItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return WishlistItem(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
      productId: jsonSerialization['productId'] as int,
      product: jsonSerialization['product'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.Product>(
              jsonSerialization['product'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue userId;

  _i2.User? user;

  int productId;

  _i3.Product? product;

  DateTime createdAt;

  /// Returns a shallow copy of this [WishlistItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WishlistItem copyWith({
    int? id,
    _i1.UuidValue? userId,
    _i2.User? user,
    int? productId,
    _i3.Product? product,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WishlistItem',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      'productId': productId,
      if (product != null) 'product': product?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WishlistItemImpl extends WishlistItem {
  _WishlistItemImpl({
    int? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required int productId,
    _i3.Product? product,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         productId: productId,
         product: product,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [WishlistItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WishlistItem copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    int? productId,
    Object? product = _Undefined,
    DateTime? createdAt,
  }) {
    return WishlistItem(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      productId: productId ?? this.productId,
      product: product is _i3.Product? ? product : this.product?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
