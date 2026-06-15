import 'package:placeify/features/home/domain/models/product.dart';
import 'package:placeify/features/shops/domain/models/shop_listing.dart';

abstract class ConsumerShopRepository {
  Future<List<ShopListing>> listShops({String? query});

  Future<ShopListing?> getShop(String vendorId);

  Future<List<Product>> getShopProducts(String vendorId);
}
