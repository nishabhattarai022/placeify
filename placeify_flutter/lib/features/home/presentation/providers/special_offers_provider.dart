import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/discounted_products.dart';
import '../../data/special_offer_mapper.dart';
import 'catalog_provider.dart';

part 'special_offers_provider.g.dart';

@riverpod
Future<List<DiscountedProduct>> specialOffers(Ref ref) async {
  try {
    final repo = ref.watch(catalogRepositoryProvider);
    final offers = await repo.listSpecialOffers();
    if (offers.isEmpty) return discountedProducts;

    final mapped = <DiscountedProduct>[];
    for (final offer in offers) {
      mapped.add(await SpecialOfferMapper.toUi(offer));
    }
    return mapped;
  } catch (_) {
    return discountedProducts;
  }
}
