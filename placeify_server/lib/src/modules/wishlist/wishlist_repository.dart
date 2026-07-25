import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/pagination_helper.dart';
import '../../shared/session_service.dart';
import '../product/product_catalog_policy.dart';
import '../product/product_repository.dart';

class WishlistStore {
  WishlistStore({CatalogRepository? productRepository})
    : _productRepository = productRepository ?? CatalogRepository();

  final CatalogRepository _productRepository;

  Future<int> countForUser(Session session, UuidValue userId) {
    return WishlistItem.db.count(
      session,
      where: (row) => row.userId.equals(userId),
    );
  }

  Future<WishlistPage> listItems(
    Session session, {
    PaginationInput? pagination,
  }) async {
    final user = await SessionService.requireUser(session);
    final paging = PaginationHelper.resolve(pagination);

    final total = await countForUser(session, user.id!);
    final items = await WishlistItem.db.find(
      session,
      where: (row) => row.userId.equals(user.id!),
      include: WishlistItem.include(
        product: Product.include(
          vendor: Vendor.include(user: User.include()),
          category: Category.include(),
        ),
      ),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: paging.pageSize,
      offset: paging.offset,
    );

    final visible = items
        .where((item) {
          final product = item.product;
          if (product == null) return false;
          return ProductCatalogPolicy.isConsumerVisibleProduct(
            product,
            vendorUser: product.vendor?.user,
            vendor: product.vendor,
          );
        })
        .toList(growable: false);

    return WishlistPage(
      items: visible,
      total: total,
      page: paging.page,
      pageSize: paging.pageSize,
    );
  }

  Future<WishlistItem> addItem(Session session, int productId) async {
    await _productRepository.requireActiveProduct(session, productId);
    final user = await SessionService.requireUser(session);

    final existing = await WishlistItem.db.findFirstRow(
      session,
      where: (row) =>
          row.userId.equals(user.id!) & row.productId.equals(productId),
    );
    if (existing != null) return existing;

    return WishlistItem.db.insertRow(
      session,
      WishlistItem(
        userId: user.id!,
        productId: productId,
      ),
    );
  }

  Future<void> removeItem(Session session, int productId) async {
    final user = await SessionService.requireUser(session);
    final existing = await WishlistItem.db.findFirstRow(
      session,
      where: (row) =>
          row.userId.equals(user.id!) & row.productId.equals(productId),
    );
    if (existing == null) return;
    await WishlistItem.db.deleteRow(session, existing);
  }

  Future<bool> toggleItem(Session session, int productId) async {
    final user = await SessionService.requireUser(session);
    final existing = await WishlistItem.db.findFirstRow(
      session,
      where: (row) =>
          row.userId.equals(user.id!) & row.productId.equals(productId),
    );
    if (existing != null) {
      await WishlistItem.db.deleteRow(session, existing);
      return false;
    }
    await addItem(session, productId);
    return true;
  }

  Future<bool> isWishlisted(Session session, int productId) async {
    final user = await SessionService.requireUser(session);
    final existing = await WishlistItem.db.findFirstRow(
      session,
      where: (row) =>
          row.userId.equals(user.id!) & row.productId.equals(productId),
    );
    return existing != null;
  }
}
