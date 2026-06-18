import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_listing.freezed.dart';

@freezed
abstract class ShopListing with _$ShopListing {
  const factory ShopListing({
    required String vendorId,
    required String businessName,
    required String locality,
    @Default([]) List<String> tags,
    String? logoUrl,
    String? bannerUrl,
    @Default(0) int productCount,
    @Default(0) double averageRating,
  }) = _ShopListing;
}
