import 'package:flutter/foundation.dart';
import 'package:placeify_client/placeify_client.dart' hide Product;

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
    // #region agent log
    debugPrint(
      '[ShopAPI] listApprovedShops request query=${query ?? "(none)"} '
      'serverUrl=$serverUrl',
    );
    // #endregion
    try {
      final shops = await client.product.listApprovedShops(query: query);
      // #region agent log
      debugPrint(
        '[ShopAPI] listApprovedShops success status=200 count=${shops.length}',
      );
      for (final shop in shops) {
        debugPrint(
          '[ShopAPI] shop vendorId=${shop.vendorId} '
          'name="${shop.businessName}" products=${shop.productCount} '
          'locality="${shop.locality}"',
        );
      }
      // #endregion
      return shops.map(_toListing).toList();
    } catch (error, stackTrace) {
      _logApiError('listApprovedShops', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<ShopListing?> getShop(String vendorId) async {
    // #region agent log
    debugPrint('[ShopAPI] getShopProfile request vendorId=$vendorId');
    // #endregion
    try {
      final profile = await client.product.getShopProfile(
        UuidValue.fromString(vendorId),
      );
      if (profile == null) {
        debugPrint(
          '[ShopAPI] getShopProfile response status=200 body=null '
          '(vendor not visible or not found)',
        );
        return null;
      }

      debugPrint(
        '[ShopAPI] getShopProfile success status=200 '
        'name="${profile.businessName}" products=${profile.totalProducts}',
      );

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
    } catch (error, stackTrace) {
      _logApiError('getShopProfile', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<Product>> getShopProducts(String vendorId) async {
    // #region agent log
    debugPrint('[ShopAPI] searchProducts request vendorId=$vendorId');
    // #endregion
    try {
      final page = await client.product.searchProducts(
        ProductSearchInput(
          vendorId: UuidValue.fromString(vendorId),
          pagination: PaginationInput(page: 1, pageSize: 100),
        ),
      );

      debugPrint(
        '[ShopAPI] searchProducts success status=200 '
        'count=${page.items.length} total=${page.total}',
      );

      final products = <Product>[];
      for (final product in page.items) {
        final vendorProduct =
            await vendor_mapper.VendorProductMapper.fromApiProduct(
              product,
              vendorId: vendorId,
            );
        products.add(VendorProductMapper.toConsumerProduct(vendorProduct));
      }
      return products;
    } catch (error, stackTrace) {
      _logApiError('searchProducts', error, stackTrace);
      rethrow;
    }
  }

  void _logApiError(String endpoint, Object error, StackTrace stackTrace) {
    if (error is ServerpodClientException) {
      debugPrint(
        '[ShopAPI] $endpoint FAILED '
        'statusCode=${error.statusCode} message="${error.message}"',
      );
    } else {
      debugPrint('[ShopAPI] $endpoint FAILED error=$error');
    }
    debugPrint('[ShopAPI] $endpoint stackTrace=$stackTrace');
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
