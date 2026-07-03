import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/pagination_helper.dart';
import '../../shared/placeify_exception.dart';
import 'catalog_seed.dart';

/// Product catalog queries with search, filter, and pagination.
class CatalogRepository {
  Future<List<Category>> listCategories(Session session) async {
    final rows = await Category.db.find(
      session,
      orderBy: (row) => row.name,
    );
    final byName = {for (final row in rows) row.name: row};
    return [
      for (final name in CatalogSeed.defaultCategoryNames)
        if (byName[name] != null) byName[name]!,
    ];
  }

  Future<ProductPage> searchProducts(
    Session session,
    ProductSearchInput input,
  ) async {
    final paging = PaginationHelper.resolve(input.pagination);
    final query = input.query?.trim().toLowerCase();

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

    final where = _productSearchWhere(
      categoryId: categoryId,
      vendorId: input.vendorId,
      minPrice: input.minPrice,
      maxPrice: input.maxPrice,
      query: query,
    );

    final total = await Product.db.count(session, where: where);

    final items = await Product.db.find(
      session,
      where: where,
      include: Product.include(
        vendor: Vendor.include(),
        category: Category.include(),
      ),
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

  Future<Product?> getProduct(Session session, int productId) {
    return Product.db.findById(
      session,
      productId,
      include: Product.include(
        vendor: Vendor.include(),
        category: Category.include(),
      ),
    );
  }

  WhereExpressionBuilder<ProductTable> _productSearchWhere({
    int? categoryId,
    UuidValue? vendorId,
    double? minPrice,
    double? maxPrice,
    String? query,
  }) {
    return (row) {
      var expression = row.status.equals(ProductStatus.active);
      if (categoryId != null) {
        expression = expression & row.categoryId.equals(categoryId);
      }
      if (vendorId != null) {
        expression = expression & row.vendorId.equals(vendorId);
      }
      if (minPrice != null) {
        expression = expression & (row.price >= minPrice);
      }
      if (maxPrice != null) {
        expression = expression & (row.price <= maxPrice);
      }
      if (query != null && query.isNotEmpty) {
        final pattern = '%$query%';
        expression = expression &
            (row.name.ilike(pattern) | row.description.ilike(pattern));
      }
      return expression;
    };
  }

  Future<Product> requireActiveProduct(Session session, int productId) async {
    final product = await getProduct(session, productId);
    if (product == null || product.status != ProductStatus.active) {
      throw PlaceifyException(message: 'Product not found.', code: 'PRODUCT_NOT_FOUND');
    }
    return product;
  }
}
