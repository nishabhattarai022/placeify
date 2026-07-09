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
import 'user.dart' as _i2;
import 'user_order_counts.dart' as _i3;
import 'package:placeify_server/src/generated/protocol.dart' as _i4;

/// Aggregated profile dashboard data for the logged-in customer.
abstract class UserDashboard
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  UserDashboard._({
    required this.profile,
    required this.orderCount,
    required this.orderCounts,
    required this.wishlistCount,
    required this.cartItemCount,
    required this.arSessionCount,
    required this.refundCount,
  });

  factory UserDashboard({
    required _i2.User profile,
    required int orderCount,
    required _i3.UserOrderCounts orderCounts,
    required int wishlistCount,
    required int cartItemCount,
    required int arSessionCount,
    required int refundCount,
  }) = _UserDashboardImpl;

  factory UserDashboard.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserDashboard(
      profile: _i4.Protocol().deserialize<_i2.User>(
        jsonSerialization['profile'],
      ),
      orderCount: jsonSerialization['orderCount'] as int,
      orderCounts: _i4.Protocol().deserialize<_i3.UserOrderCounts>(
        jsonSerialization['orderCounts'],
      ),
      wishlistCount: jsonSerialization['wishlistCount'] as int,
      cartItemCount: jsonSerialization['cartItemCount'] as int,
      arSessionCount: jsonSerialization['arSessionCount'] as int,
      refundCount: jsonSerialization['refundCount'] as int,
    );
  }

  _i2.User profile;

  /// Same value as [orderCounts.activeOrders] (kept for backward compatibility).
  int orderCount;

  _i3.UserOrderCounts orderCounts;

  int wishlistCount;

  int cartItemCount;

  int arSessionCount;

  int refundCount;

  /// Returns a shallow copy of this [UserDashboard]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserDashboard copyWith({
    _i2.User? profile,
    int? orderCount,
    _i3.UserOrderCounts? orderCounts,
    int? wishlistCount,
    int? cartItemCount,
    int? arSessionCount,
    int? refundCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserDashboard',
      'profile': profile.toJson(),
      'orderCount': orderCount,
      'orderCounts': orderCounts.toJson(),
      'wishlistCount': wishlistCount,
      'cartItemCount': cartItemCount,
      'arSessionCount': arSessionCount,
      'refundCount': refundCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserDashboard',
      'profile': profile.toJsonForProtocol(),
      'orderCount': orderCount,
      'orderCounts': orderCounts.toJsonForProtocol(),
      'wishlistCount': wishlistCount,
      'cartItemCount': cartItemCount,
      'arSessionCount': arSessionCount,
      'refundCount': refundCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _UserDashboardImpl extends UserDashboard {
  _UserDashboardImpl({
    required _i2.User profile,
    required int orderCount,
    required _i3.UserOrderCounts orderCounts,
    required int wishlistCount,
    required int cartItemCount,
    required int arSessionCount,
    required int refundCount,
  }) : super._(
         profile: profile,
         orderCount: orderCount,
         orderCounts: orderCounts,
         wishlistCount: wishlistCount,
         cartItemCount: cartItemCount,
         arSessionCount: arSessionCount,
         refundCount: refundCount,
       );

  /// Returns a shallow copy of this [UserDashboard]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserDashboard copyWith({
    _i2.User? profile,
    int? orderCount,
    _i3.UserOrderCounts? orderCounts,
    int? wishlistCount,
    int? cartItemCount,
    int? arSessionCount,
    int? refundCount,
  }) {
    return UserDashboard(
      profile: profile ?? this.profile.copyWith(),
      orderCount: orderCount ?? this.orderCount,
      orderCounts: orderCounts ?? this.orderCounts.copyWith(),
      wishlistCount: wishlistCount ?? this.wishlistCount,
      cartItemCount: cartItemCount ?? this.cartItemCount,
      arSessionCount: arSessionCount ?? this.arSessionCount,
      refundCount: refundCount ?? this.refundCount,
    );
  }
}
