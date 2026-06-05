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
import 'cart.dart' as _i2;
import 'product.dart' as _i3;
import 'package:placeify_client/src/protocol/protocol.dart' as _i4;

/// Item in a user's shopping cart.
abstract class CartItem implements _i1.SerializableModel {
  CartItem._({
    this.id,
    required this.cartId,
    this.cart,
    required this.productId,
    this.product,
    int? quantity,
    required this.unitPrice,
  }) : quantity = quantity ?? 1;

  factory CartItem({
    int? id,
    required int cartId,
    _i2.Cart? cart,
    required int productId,
    _i3.Product? product,
    int? quantity,
    required double unitPrice,
  }) = _CartItemImpl;

  factory CartItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return CartItem(
      id: jsonSerialization['id'] as int?,
      cartId: jsonSerialization['cartId'] as int,
      cart: jsonSerialization['cart'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.Cart>(jsonSerialization['cart']),
      productId: jsonSerialization['productId'] as int,
      product: jsonSerialization['product'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.Product>(
              jsonSerialization['product'],
            ),
      quantity: jsonSerialization['quantity'] as int?,
      unitPrice: (jsonSerialization['unitPrice'] as num).toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int cartId;

  _i2.Cart? cart;

  int productId;

  _i3.Product? product;

  int quantity;

  double unitPrice;

  /// Returns a shallow copy of this [CartItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CartItem copyWith({
    int? id,
    int? cartId,
    _i2.Cart? cart,
    int? productId,
    _i3.Product? product,
    int? quantity,
    double? unitPrice,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CartItem',
      if (id != null) 'id': id,
      'cartId': cartId,
      if (cart != null) 'cart': cart?.toJson(),
      'productId': productId,
      if (product != null) 'product': product?.toJson(),
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CartItemImpl extends CartItem {
  _CartItemImpl({
    int? id,
    required int cartId,
    _i2.Cart? cart,
    required int productId,
    _i3.Product? product,
    int? quantity,
    required double unitPrice,
  }) : super._(
         id: id,
         cartId: cartId,
         cart: cart,
         productId: productId,
         product: product,
         quantity: quantity,
         unitPrice: unitPrice,
       );

  /// Returns a shallow copy of this [CartItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CartItem copyWith({
    Object? id = _Undefined,
    int? cartId,
    Object? cart = _Undefined,
    int? productId,
    Object? product = _Undefined,
    int? quantity,
    double? unitPrice,
  }) {
    return CartItem(
      id: id is int? ? id : this.id,
      cartId: cartId ?? this.cartId,
      cart: cart is _i2.Cart? ? cart : this.cart?.copyWith(),
      productId: productId ?? this.productId,
      product: product is _i3.Product? ? product : this.product?.copyWith(),
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}
