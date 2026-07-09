// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorStats _$VendorStatsFromJson(Map<String, dynamic> json) => _VendorStats(
      revenue: (json['revenue'] as num).toDouble(),
      orderCount: (json['orderCount'] as num).toInt(),
      productCount: (json['productCount'] as num).toInt(),
      viewCount: (json['viewCount'] as num).toInt(),
      conversionRate: (json['conversionRate'] as num).toDouble(),
      periodLabel: json['periodLabel'] as String,
      averageRating: (json['averageRating'] as num).toDouble(),
      responseRate: (json['responseRate'] as num).toDouble(),
    );

Map<String, dynamic> _$VendorStatsToJson(_VendorStats instance) =>
    <String, dynamic>{
      'revenue': instance.revenue,
      'orderCount': instance.orderCount,
      'productCount': instance.productCount,
      'viewCount': instance.viewCount,
      'conversionRate': instance.conversionRate,
      'periodLabel': instance.periodLabel,
      'averageRating': instance.averageRating,
      'responseRate': instance.responseRate,
    };
