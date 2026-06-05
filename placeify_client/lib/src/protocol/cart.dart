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
import 'package:placeify_client/src/protocol/protocol.dart' as _i3;

/// Shopping cart for a user.
abstract class Cart implements _i1.SerializableModel {
  Cart._({
    this.id,
    required this.userId,
    this.user,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Cart({
    int? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    DateTime? createdAt,
  }) = _CartImpl;

  factory Cart.fromJson(Map<String, dynamic> jsonSerialization) {
    return Cart(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
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

  DateTime createdAt;

  /// Returns a shallow copy of this [Cart]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Cart copyWith({
    int? id,
    _i1.UuidValue? userId,
    _i2.User? user,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Cart',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CartImpl extends Cart {
  _CartImpl({
    int? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Cart]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Cart copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    DateTime? createdAt,
  }) {
    return Cart(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
