import 'package:placeify_flutter/features/home/domain/models/product.dart';
import 'package:placeify_flutter/features/shops/domain/models/shop_listing.dart';

abstract class ConsumerShopRepository {
  Future<List<ShopListing>> listShops({String? query});

  Future<ShopListing?> getShop(String vendorId);

  Future<List<Product>> getShopProducts(String vendorId);
}
