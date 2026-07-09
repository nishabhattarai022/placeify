import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/pagination_helper.dart';
import '../../shared/placeify_exception.dart';
import 'product_catalog_policy.dart';
import 'product_pricing.dart';

/// Product catalog queries with search, filter, and pagination.
class CatalogRepository {
  ProductInclude _productInclude() {
    return Product.include(
      vendor: Vendor.include(user: User.include()),
      category: Category.include(),
    );
  }

  Future<List<Category>> listCategories(Session session) {
    return Category.db.find(
      session,
      orderBy: (row) => row.name,
    );
  }

  Future<ProductPage> searchProducts(
    Session session,
    ProductSearchInput input,
  ) async {
    final paging = PaginationHelper.resolve(input.pagination);
    final query = input.query?.trim().toLowerCase();
    final approvedVendorIds = await ProductCatalogPolicy.approvedVendorIds(
      session,
    );

    if (approvedVendorIds.isEmpty) {
      return ProductPage(
        items: [],
        total: 0,
        page: paging.page,
        pageSize: paging.pageSize,
      );
    }

    int? categoryId;
    if (input.categoryName != null && input.categoryName!.trim().isNotEmpty) {
      final category = await Category.db.findFirstRow(
        session,
        where: (row) => row.name.equals(input.categoryName!.trim().toLowerCase()),
      );
      categoryId = category?.id;
      if (categoryId == null) {
        return ProductPage(
          items: [],
          total: 0,
          page: paging.page,
          pageSize: paging.pageSize,
        );
      }
    }

    if (input.vendorId != null && !approvedVendorIds.contains(input.vendorId)) {
      return ProductPage(
        items: [],
        total: 0,
        page: paging.page,
        pageSize: paging.pageSize,
      );
    }

    final where = ProductCatalogPolicy.consumerVisibleWhere(
      approvedVendorIds: approvedVendorIds,
      categoryId: categoryId,
      vendorId: input.vendorId,
      minPrice: input.minPrice,
      maxPrice: input.maxPrice,
      query: query,
      featuredOnly: input.featuredOnly ? true : null,
    );

    if (input.offersOnly) {
      final candidates = await Product.db.find(
        session,
        where: where,
        include: _productInclude(),
        orderBy: (row) => row.createdAt,
        orderDescending: true,
        limit: 500,
      );
      final offers = candidates.where(ProductPricing.hasActiveOffer).toList()
        ..sort((a, b) {
          final compare = _discountFraction(b).compareTo(_discountFraction(a));
          if (compare != 0) return compare;
          return b.createdAt.compareTo(a.createdAt);
        });
      final pageItems = offers
          .skip(paging.offset)
          .take(paging.pageSize)
          .toList(growable: false);
      return ProductPage(
        items: pageItems,
        total: offers.length,
        page: paging.page,
        pageSize: paging.pageSize,
      );
    }

    final total = await Product.db.count(session, where: where);

    final items = await Product.db.find(
      session,
      where: where,
      include: _productInclude(),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: paging.pageSize,
      offset: paging.offset,
    );

    return ProductPage(
      items: items,
      total: total,
      page: paging.page,
      pageSize: paging.pageSize,
    );
  }

  Future<MarketplaceHighlights> marketplaceHighlights(Session session) async {
    final approvedVendorIds = await ProductCatalogPolicy.approvedVendorIds(
      session,
    );
    if (approvedVendorIds.isEmpty) {
      return MarketplaceHighlights(
        recentProducts: [],
        featuredProducts: [],
        offerProducts: [],
      );
    }

    final recentProducts = await Product.db.find(
      session,
      where: ProductCatalogPolicy.consumerVisibleWhere(
        approvedVendorIds: approvedVendorIds,
      ),
      include: _productInclude(),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: ProductCatalogPolicy.defaultRecentLimit,
    );

    final featuredProducts = await Product.db.find(
      session,
      where: ProductCatalogPolicy.consumerVisibleWhere(
        approvedVendorIds: approvedVendorIds,
        featuredOnly: true,
      ),
      include: _productInclude(),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: ProductCatalogPolicy.defaultFeaturedLimit,
    );

    final offerCandidates = await Product.db.find(
      session,
      where: ProductCatalogPolicy.consumerVisibleWhere(
        approvedVendorIds: approvedVendorIds,
      ),
      include: _productInclude(),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: ProductCatalogPolicy.defaultRecentLimit * 2,
    );
    final offerProducts = offerCandidates
        .where(ProductPricing.hasActiveOffer)
        .toList()
      ..sort((a, b) {
        final discountA = _discountFraction(a);
        final discountB = _discountFraction(b);
        final compare = discountB.compareTo(discountA);
        if (compare != 0) return compare;
        return b.createdAt.compareTo(a.createdAt);
      });
    final trimmedOffers = offerProducts
        .take(ProductCatalogPolicy.defaultOfferLimit)
        .toList(growable: false);

    return MarketplaceHighlights(
      recentProducts: recentProducts,
      featuredProducts: featuredProducts,
      offerProducts: trimmedOffers,
    );
  }

  double _discountFraction(Product product) {
    final listPrice = product.price;
    if (listPrice <= 0) return 0;
    final effective = ProductPricing.effectiveUnitPrice(product);
    if (effective >= listPrice) return 0;
    return (listPrice - effective) / listPrice;
  }

  Future<Product?> getProduct(Session session, int productId) async {
    final product = await Product.db.findById(
      session,
      productId,
      include: _productInclude(),
    );
    if (product == null) return null;

    final vendorUser = product.vendor?.user;
    if (!ProductCatalogPolicy.isConsumerVisibleProduct(
      product,
      vendorUser: vendorUser,
      vendor: product.vendor,
    )) {
      return null;
    }

    return product;
  }

  Future<Product> requireActiveProduct(Session session, int productId) async {
    final product = await getProduct(session, productId);
    if (product == null) {
      throw PlaceifyException(
        message: 'Product not found.',
        code: 'PRODUCT_NOT_FOUND',
      );
    }
    return product;
  }
}
