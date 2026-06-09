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

/// Product sales aggregate for the vendor dashboard.
abstract class VendorProductStat implements _i1.SerializableModel {
  VendorProductStat._({
    required this.productId,
    required this.name,
    required this.unitsSold,
    required this.revenue,
  });

  factory VendorProductStat({
    required int productId,
    required String name,
    required int unitsSold,
    required double revenue,
  }) = _VendorProductStatImpl;

  factory VendorProductStat.fromJson(Map<String, dynamic> jsonSerialization) {
    return VendorProductStat(
      productId: jsonSerialization['productId'] as int,
      name: jsonSerialization['name'] as String,
      unitsSold: jsonSerialization['unitsSold'] as int,
      revenue: (jsonSerialization['revenue'] as num).toDouble(),
    );
  }

  int productId;

  String name;

  int unitsSold;

  double revenue;

  /// Returns a shallow copy of this [VendorProductStat]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorProductStat copyWith({
    int? productId,
    String? name,
    int? unitsSold,
    double? revenue,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorProductStat',
      'productId': productId,
      'name': name,
      'unitsSold': unitsSold,
      'revenue': revenue,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _VendorProductStatImpl extends VendorProductStat {
  _VendorProductStatImpl({
    required int productId,
    required String name,
    required int unitsSold,
    required double revenue,
  }) : super._(
         productId: productId,
         name: name,
         unitsSold: unitsSold,
         revenue: revenue,
       );

  /// Returns a shallow copy of this [VendorProductStat]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorProductStat copyWith({
    int? productId,
    String? name,
    int? unitsSold,
    double? revenue,
  }) {
    return VendorProductStat(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      unitsSold: unitsSold ?? this.unitsSold,
      revenue: revenue ?? this.revenue,
    );
  }
}
