import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor_stats.freezed.dart';
part 'vendor_stats.g.dart';

@freezed
abstract class VendorStats with _$VendorStats {
  const factory VendorStats({
    required double revenue,
    required int orderCount,
    required int productCount,
    required int viewCount,
    required double conversionRate,
    required String periodLabel,
  }) = _VendorStats;

  factory VendorStats.fromJson(Map<String, dynamic> json) =>
      _$VendorStatsFromJson(json);
}
