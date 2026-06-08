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
import 'order.dart' as _i2;
import 'package:placeify_client/src/protocol/protocol.dart' as _i3;

/// Result returned after a successful checkout.
abstract class CheckoutResult implements _i1.SerializableModel {
  CheckoutResult._({
    required this.order,
    required this.itemCount,
  });

  factory CheckoutResult({
    required _i2.Order order,
    required int itemCount,
  }) = _CheckoutResultImpl;

  factory CheckoutResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return CheckoutResult(
      order: _i3.Protocol().deserialize<_i2.Order>(jsonSerialization['order']),
      itemCount: jsonSerialization['itemCount'] as int,
    );
  }

  _i2.Order order;

  int itemCount;

  /// Returns a shallow copy of this [CheckoutResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CheckoutResult copyWith({
    _i2.Order? order,
    int? itemCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CheckoutResult',
      'order': order.toJson(),
      'itemCount': itemCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CheckoutResultImpl extends CheckoutResult {
  _CheckoutResultImpl({
    required _i2.Order order,
    required int itemCount,
  }) : super._(
         order: order,
         itemCount: itemCount,
       );

  /// Returns a shallow copy of this [CheckoutResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CheckoutResult copyWith({
    _i2.Order? order,
    int? itemCount,
  }) {
    return CheckoutResult(
      order: order ?? this.order.copyWith(),
      itemCount: itemCount ?? this.itemCount,
    );
  }
}
