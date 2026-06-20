/// User-facing copy for the consumer Shops tab and vendor storefront screens.
abstract final class ShopStrings {
  static const eyebrow = 'LOCAL SHOPS';
  static const titleLine1 = 'Shop';

  static const searchHint = 'Search shops by name or category';
  static const emptyShopsTitle = 'No shops found';
  static const emptyShopsSubtitle = 'Try a different search term';
  static const emptyProductsTitle = 'No products yet';
  static const emptyProductsSubtitle = 'This shop has not listed any items';

  static const breadcrumbShops = 'Shops';
  static const sortSheetTitle = 'Sort by';
  static const sortSheetSubtitle = 'Choose how items are ordered';
  static const sortFeatured = 'Featured';
  static const sortPriceLowHigh = 'Price: Low to High';
  static const sortPriceHighLow = 'Price: High to Low';
  static const sortNameAsc = 'Name: A to Z';

  static const productCountLabel = 'items';
  static const soldByPrefix = 'Sold by';
  static const establishedLabel = 'Est.';
  static const ratingLabel = 'rating';

  // Search empty state
  static String emptySearch(String q) => 'No shops match "$q" yet';
  static const emptySearchCta = 'Clear search';

  // Error state
  static const errorTitle = 'Could not load shops';
  static const errorCta = 'Try again';
}
