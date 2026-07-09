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
import 'package:serverpod/serverpod.dart' as _i1;

/// Aggregated order counters for the logged-in customer.
abstract class UserOrderCounts
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  UserOrderCounts._({
    required this.totalOrders,
    required this.activeOrders,
    required this.cancelledOrders,
    required this.deliveredOrders,
    required this.inProgressOrders,
    required this.returnOrders,
  });

  factory UserOrderCounts({
    required int totalOrders,
    required int activeOrders,
    required int cancelledOrders,
    required int deliveredOrders,
    required int inProgressOrders,
    required int returnOrders,
  }) = _UserOrderCountsImpl;

  factory UserOrderCounts.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserOrderCounts(
      totalOrders: jsonSerialization['totalOrders'] as int,
      activeOrders: jsonSerialization['activeOrders'] as int,
      cancelledOrders: jsonSerialization['cancelledOrders'] as int,
      deliveredOrders: jsonSerialization['deliveredOrders'] as int,
      inProgressOrders: jsonSerialization['inProgressOrders'] as int,
      returnOrders: jsonSerialization['returnOrders'] as int,
    );
  }

  /// All orders ever placed (includes cancelled).
  int totalOrders;

  /// Non-terminal orders: excludes cancelled, autoCancelled, and rejected.
  int activeOrders;

  int cancelledOrders;

  int deliveredOrders;

  /// Orders currently in fulfilment (not delivered or terminal).
  int inProgressOrders;

  int returnOrders;

  /// Returns a shallow copy of this [UserOrderCounts]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserOrderCounts copyWith({
    int? totalOrders,
    int? activeOrders,
    int? cancelledOrders,
    int? deliveredOrders,
    int? inProgressOrders,
    int? returnOrders,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserOrderCounts',
      'totalOrders': totalOrders,
      'activeOrders': activeOrders,
      'cancelledOrders': cancelledOrders,
      'deliveredOrders': deliveredOrders,
      'inProgressOrders': inProgressOrders,
      'returnOrders': returnOrders,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserOrderCounts',
      'totalOrders': totalOrders,
      'activeOrders': activeOrders,
      'cancelledOrders': cancelledOrders,
      'deliveredOrders': deliveredOrders,
      'inProgressOrders': inProgressOrders,
      'returnOrders': returnOrders,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _UserOrderCountsImpl extends UserOrderCounts {
  _UserOrderCountsImpl({
    required int totalOrders,
    required int activeOrders,
    required int cancelledOrders,
    required int deliveredOrders,
    required int inProgressOrders,
    required int returnOrders,
  }) : super._(
         totalOrders: totalOrders,
         activeOrders: activeOrders,
         cancelledOrders: cancelledOrders,
         deliveredOrders: deliveredOrders,
         inProgressOrders: inProgressOrders,
         returnOrders: returnOrders,
       );

  /// Returns a shallow copy of this [UserOrderCounts]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserOrderCounts copyWith({
    int? totalOrders,
    int? activeOrders,
    int? cancelledOrders,
    int? deliveredOrders,
    int? inProgressOrders,
    int? returnOrders,
  }) {
    return UserOrderCounts(
      totalOrders: totalOrders ?? this.totalOrders,
      activeOrders: activeOrders ?? this.activeOrders,
      cancelledOrders: cancelledOrders ?? this.cancelledOrders,
      deliveredOrders: deliveredOrders ?? this.deliveredOrders,
      inProgressOrders: inProgressOrders ?? this.inProgressOrders,
      returnOrders: returnOrders ?? this.returnOrders,
    );
  }
}
