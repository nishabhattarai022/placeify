import 'package:placeify_client/placeify_client.dart' hide Product;
import 'package:serverpod_client/serverpod_client.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../home/domain/models/product.dart';
import '../../vendor/data/vendor_product_mapper.dart' as vendor_mapper;
import '../../vendor/data/vendor_shop_category_codec.dart';
import '../domain/models/shop_listing.dart';
import '../domain/repositories/consumer_shop_repository.dart';
import 'vendor_product_mapper.dart';

/// Consumer shop discovery backed by approved vendor rows in PostgreSQL.
class ServerpodConsumerShopRepository implements ConsumerShopRepository {
  const ServerpodConsumerShopRepository();

  @override
  Future<List<ShopListing>> listShops({String? query}) async {
    final shops = await client.product.listApprovedShops(query: query);
    return shops.map(_toListing).toList();
  }

  @override
  Future<ShopListing?> getShop(String vendorId) async {
    final profile = await client.product.getShopProfile(
      UuidValue.fromString(vendorId),
    );
    if (profile == null) return null;

    return ShopListing(
      vendorId: profile.id.toString(),
      businessName: profile.businessName,
      locality: profile.city.isNotEmpty ? profile.city : profile.address,
      tags: VendorShopCategoryCodec.decode(profile.category),
      logoUrl: profile.logoUrl,
      bannerUrl: profile.bannerUrl,
      productCount: profile.totalProducts,
      averageRating: 0,
    );
  }

  @override
  Future<List<Product>> getShopProducts(String vendorId) async {
    final page = await client.product.searchProducts(
      ProductSearchInput(
        vendorId: UuidValue.fromString(vendorId),
        pagination: PaginationInput(page: 1, pageSize: 100),
      ),
    );

    final products = <Product>[];
    for (final product in page.items) {
      final vendorProduct = await vendor_mapper.VendorProductMapper.fromApiProduct(
        product,
        vendorId: vendorId,
      );
      products.add(VendorProductMapper.toConsumerProduct(vendorProduct));
    }
    return products;
  }

  ShopListing _toListing(ShopListingSummary shop) {
    return ShopListing(
      vendorId: shop.vendorId.toString(),
      businessName: shop.businessName,
      locality: shop.locality,
      tags: shop.tags,
      logoUrl: shop.logoUrl,
      bannerUrl: shop.bannerUrl,
      productCount: shop.productCount,
      averageRating: shop.averageRating,
    );
  }
}
