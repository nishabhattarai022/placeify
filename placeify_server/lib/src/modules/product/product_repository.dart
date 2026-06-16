import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/pagination_helper.dart';
import '../../shared/placeify_exception.dart';

/// Product catalog queries with search, filter, and pagination.
class CatalogRepository {
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

    final all = await Product.db.find(
      session,
      where: (row) {
        var expression = row.status.equals(ProductStatus.active);
        if (categoryId != null) {
          expression = expression & row.categoryId.equals(categoryId);
        }
        return expression;
      },
      include: Product.include(
        vendor: Vendor.include(),
        category: Category.include(),
      ),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
    );

    final filtered = all.where((product) {
      if (input.minPrice != null && product.price < input.minPrice!) {
        return false;
      }
      if (input.maxPrice != null && product.price > input.maxPrice!) {
        return false;
      }
      if (query != null && query.isNotEmpty) {
        final haystack =
            '${product.name} ${product.description}'.toLowerCase();
        if (!haystack.contains(query)) return false;
      }
      return true;
    }).toList();

    final slice = filtered
        .skip(paging.offset)
        .take(paging.pageSize)
        .toList(growable: false);

    return ProductPage(
      items: slice,
      total: filtered.length,
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

  Future<Product> requireActiveProduct(Session session, int productId) async {
    final product = await getProduct(session, productId);
    if (product == null || product.status != ProductStatus.active) {
      throw PlaceifyException(
        'Product not found or is no longer available.',
        code: 'PRODUCT_NOT_FOUND',
      );
    }
    return product;
  }
}
