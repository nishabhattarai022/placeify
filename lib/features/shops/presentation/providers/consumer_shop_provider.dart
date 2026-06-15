import 'package:placeify/core/providers/shared_preferences_provider.dart';
import 'package:placeify/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify/features/home/domain/models/product.dart';
import 'package:placeify/features/shops/data/mock_consumer_shop_repository.dart';
import 'package:placeify/features/shops/domain/models/shop_listing.dart';
import 'package:placeify/features/shops/domain/repositories/consumer_shop_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'consumer_shop_provider.g.dart';

@Riverpod(keepAlive: true)
Future<ConsumerShopRepository> consumerShopRepository(Ref ref) async {
  final authRepo = await ref.watch(authRepositoryProvider.future);
  final prefs = ref.watch(sharedPreferencesProvider);
  return MockConsumerShopRepository(authRepo, prefs);
}

@riverpod
Future<List<ShopListing>> consumerShops(Ref ref, String query) async {
  final repo = await ref.watch(consumerShopRepositoryProvider.future);
  return repo.listShops(query: query.isEmpty ? null : query);
}

@riverpod
Future<ShopListing?> shopListing(Ref ref, String vendorId) async {
  final repo = await ref.watch(consumerShopRepositoryProvider.future);
  return repo.getShop(vendorId);
}

@riverpod
Future<List<Product>> shopProducts(Ref ref, String vendorId) async {
  final repo = await ref.watch(consumerShopRepositoryProvider.future);
  return repo.getShopProducts(vendorId);
}
