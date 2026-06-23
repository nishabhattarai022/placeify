import 'package:placeify_flutter/features/shops/data/serverpod_consumer_shop_repository.dart';
import 'package:placeify_flutter/features/shops/data/vendor_product_mapper.dart';
import 'package:placeify_flutter/features/shops/domain/models/shop_listing.dart';
import 'package:placeify_flutter/features/shops/domain/repositories/consumer_shop_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../home/domain/models/product.dart';
import '../../../home/presentation/providers/catalog_provider.dart';

part 'consumer_shop_provider.g.dart';

@Riverpod(keepAlive: true)
ConsumerShopRepository consumerShopRepository(Ref ref) {
  return const ServerpodConsumerShopRepository();
}

@riverpod
Future<List<ShopListing>> consumerShops(Ref ref, String query) async {
  final repo = ref.watch(consumerShopRepositoryProvider);
  return repo.listShops(query: query.isEmpty ? null : query);
}

@riverpod
Future<ShopListing?> shopListing(Ref ref, String vendorId) async {
  final repo = ref.watch(consumerShopRepositoryProvider);
  return repo.getShop(vendorId);
}

@riverpod
Future<List<Product>> shopProducts(Ref ref, String vendorId) async {
  final repo = ref.watch(consumerShopRepositoryProvider);
  return repo.getShopProducts(vendorId);
}

@riverpod
Future<Product?> shopProductByConsumerId(Ref ref, String consumerId) async {
  final parsed = VendorProductMapper.parseConsumerProductId(consumerId);
  if (parsed == null) return null;

  final products = await ref.watch(shopProductsProvider(parsed.vendorId).future);
  for (final product in products) {
    if (product.id == consumerId) return product;
  }
  return null;
}

@riverpod
Future<Product?> resolvedProduct(Ref ref, String id) async {
  if (VendorProductMapper.isShopProductId(id)) {
    final shopProduct = await ref.watch(shopProductByConsumerIdProvider(id).future);
    if (shopProduct != null) return shopProduct;
  }

  final catalogHit = ref.watch(catalogIndexProvider).value?[id];
  if (catalogHit != null) return catalogHit;

  if (VendorProductMapper.isShopProductId(id)) {
    final parsed = VendorProductMapper.parseConsumerProductId(id);
    if (parsed != null) {
      final base = ref.watch(catalogIndexProvider).value?[parsed.productId];
      if (base != null) {
        return base.copyWith(id: id, vendorId: parsed.vendorId);
      }
      final detail = await ref.watch(productDetailProvider(parsed.productId).future);
      if (detail != null) {
        return detail.copyWith(id: id, vendorId: parsed.vendorId);
      }
    }
  }

  return ref.watch(productDetailProvider(id).future);
}
