import 'package:placeify_flutter/features/shops/data/serverpod_consumer_shop_repository.dart';
import 'package:placeify_flutter/features/shops/domain/models/shop_listing.dart';
import 'package:placeify_flutter/features/shops/domain/repositories/consumer_shop_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../home/domain/models/product.dart';

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
