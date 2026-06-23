import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../../marketplace/marketplace_events.dart';
import '../../product/product_pricing.dart';

/// Product create/update pricing normalization and marketplace events.
class VendorProductStore {
  VendorProductStore({MarketplaceEventDispatcher? events})
      : _events = events ?? marketplaceEventDispatcher;

  final MarketplaceEventDispatcher _events;

  Product withPricing({
    required Product product,
    required double listPrice,
    double? discountPrice,
    double? discountPercentage,
    bool? featured,
  }) {
    final normalized = ProductPricing.normalizeDiscounts(
      listPrice: listPrice,
      discountPrice: discountPrice,
      discountPercentage: discountPercentage,
    );
    final priced = product.copyWith(
      price: listPrice,
      discountPrice: normalized.discountPrice,
      discountPercentage: normalized.discountPercentage,
      featured: featured ?? product.featured,
    );
    return priced.copyWith(isOffer: ProductPricing.hasActiveOffer(priced));
  }

  Future<void> dispatchProductEvents(
    Session session,
    Product product,
    UuidValue vendorId, {
    required bool created,
  }) async {
    if (created) {
      await _events.dispatch(
        session,
        ProductCreatedEvent(product: product, vendorId: vendorId),
      );
    }
    if (ProductPricing.hasActiveOffer(product)) {
      await _events.dispatch(
        session,
        DiscountActivatedEvent(product: product, vendorId: vendorId),
      );
    }
  }
}
