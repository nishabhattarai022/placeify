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
import 'vendor.dart' as _i2;
import 'vendor_order_summary.dart' as _i3;
import 'vendor_product_stat.dart' as _i4;
import 'package:placeify_server/src/generated/protocol.dart' as _i5;

/// Aggregated vendor dashboard data for the logged-in seller.
abstract class VendorDashboard
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  VendorDashboard._({
    required this.shop,
    required this.productCount,
    required this.activeProductCount,
    required this.orderCount,
    required this.revenue,
    int? pendingRefundCount,
    required this.recentOrders,
    required this.topProducts,
  }) : pendingRefundCount = pendingRefundCount ?? 0;

  factory VendorDashboard({
    required _i2.Vendor shop,
    required int productCount,
    required int activeProductCount,
    required int orderCount,
    required double revenue,
    int? pendingRefundCount,
    required List<_i3.VendorOrderSummary> recentOrders,
    required List<_i4.VendorProductStat> topProducts,
  }) = _VendorDashboardImpl;

  factory VendorDashboard.fromJson(Map<String, dynamic> jsonSerialization) {
    return VendorDashboard(
      shop: _i5.Protocol().deserialize<_i2.Vendor>(jsonSerialization['shop']),
      productCount: jsonSerialization['productCount'] as int,
      activeProductCount: jsonSerialization['activeProductCount'] as int,
      orderCount: jsonSerialization['orderCount'] as int,
      revenue: (jsonSerialization['revenue'] as num).toDouble(),
      pendingRefundCount: jsonSerialization['pendingRefundCount'] as int?,
      recentOrders: _i5.Protocol().deserialize<List<_i3.VendorOrderSummary>>(
        jsonSerialization['recentOrders'],
      ),
      topProducts: _i5.Protocol().deserialize<List<_i4.VendorProductStat>>(
        jsonSerialization['topProducts'],
      ),
    );
  }

  _i2.Vendor shop;

  int productCount;

  int activeProductCount;

  int orderCount;

  double revenue;

  int pendingRefundCount;

  List<_i3.VendorOrderSummary> recentOrders;

  List<_i4.VendorProductStat> topProducts;

  /// Returns a shallow copy of this [VendorDashboard]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorDashboard copyWith({
    _i2.Vendor? shop,
    int? productCount,
    int? activeProductCount,
    int? orderCount,
    double? revenue,
    int? pendingRefundCount,
    List<_i3.VendorOrderSummary>? recentOrders,
    List<_i4.VendorProductStat>? topProducts,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorDashboard',
      'shop': shop.toJson(),
      'productCount': productCount,
      'activeProductCount': activeProductCount,
      'orderCount': orderCount,
      'revenue': revenue,
      'pendingRefundCount': pendingRefundCount,
      'recentOrders': recentOrders.toJson(valueToJson: (v) => v.toJson()),
      'topProducts': topProducts.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VendorDashboard',
      'shop': shop.toJsonForProtocol(),
      'productCount': productCount,
      'activeProductCount': activeProductCount,
      'orderCount': orderCount,
      'revenue': revenue,
      'pendingRefundCount': pendingRefundCount,
      'recentOrders': recentOrders.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'topProducts': topProducts.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _VendorDashboardImpl extends VendorDashboard {
  _VendorDashboardImpl({
    required _i2.Vendor shop,
    required int productCount,
    required int activeProductCount,
    required int orderCount,
    required double revenue,
    int? pendingRefundCount,
    required List<_i3.VendorOrderSummary> recentOrders,
    required List<_i4.VendorProductStat> topProducts,
  }) : super._(
         shop: shop,
         productCount: productCount,
         activeProductCount: activeProductCount,
         orderCount: orderCount,
         revenue: revenue,
         pendingRefundCount: pendingRefundCount,
         recentOrders: recentOrders,
         topProducts: topProducts,
       );

  /// Returns a shallow copy of this [VendorDashboard]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorDashboard copyWith({
    _i2.Vendor? shop,
    int? productCount,
    int? activeProductCount,
    int? orderCount,
    double? revenue,
    int? pendingRefundCount,
    List<_i3.VendorOrderSummary>? recentOrders,
    List<_i4.VendorProductStat>? topProducts,
  }) {
    return VendorDashboard(
      shop: shop ?? this.shop.copyWith(),
      productCount: productCount ?? this.productCount,
      activeProductCount: activeProductCount ?? this.activeProductCount,
      orderCount: orderCount ?? this.orderCount,
      revenue: revenue ?? this.revenue,
      pendingRefundCount: pendingRefundCount ?? this.pendingRefundCount,
      recentOrders:
          recentOrders ?? this.recentOrders.map((e0) => e0.copyWith()).toList(),
      topProducts:
          topProducts ?? this.topProducts.map((e0) => e0.copyWith()).toList(),
    );
  }
}
