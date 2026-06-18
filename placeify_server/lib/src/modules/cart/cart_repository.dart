import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/session_service.dart';
import '../product/product_repository.dart';

class CartStore {
  CartStore({CatalogRepository? productRepository})
      : _productRepository = productRepository ?? CatalogRepository();

  final CatalogRepository _productRepository;

  Future<List<CartItem>> listItems(Session session) async {
    final cart = await SessionService.requireCart(session);
    return CartItem.db.find(
      session,
      where: (row) => row.cartId.equals(cart.id!),
      include: CartItem.include(
        product: Product.include(
          vendor: Vendor.include(),
          category: Category.include(),
        ),
      ),
      orderBy: (row) => row.id,
    );
  }

  Future<CartItem> addItem(
    Session session,
    int productId, {
    int quantity = 1,
  }) async {
    if (quantity < 1) {
      throw PlaceifyException(
        message: 'Quantity must be at least 1.',
        code: 'INVALID_QUANTITY',
      );
    }

    final product = await _productRepository.requireActiveProduct(
      session,
      productId,
    );
    final cart = await SessionService.requireCart(session);

    final existing = await CartItem.db.findFirstRow(
      session,
      where: (row) =>
          row.cartId.equals(cart.id!) & row.productId.equals(productId),
    );

    if (existing != null) {
      return CartItem.db.updateRow(
        session,
        existing.copyWith(quantity: existing.quantity + quantity),
      );
    }

    return CartItem.db.insertRow(
      session,
      CartItem(
        cartId: cart.id!,
        productId: productId,
        quantity: quantity,
        unitPrice: product.price,
      ),
    );
  }

  Future<CartItem> updateQuantity(
    Session session,
    int productId,
    int quantity,
  ) async {
    if (quantity < 1) {
      throw PlaceifyException(
        message: 'Quantity must be at least 1.',
        code: 'INVALID_QUANTITY',
      );
    }

    final cart = await SessionService.requireCart(session);
    final existing = await _requireItem(session, cart.id!, productId);
    return CartItem.db.updateRow(
      session,
      existing.copyWith(quantity: quantity),
    );
  }

  Future<void> removeItem(Session session, int productId) async {
    final cart = await SessionService.requireCart(session);
    final existing = await CartItem.db.findFirstRow(
      session,
      where: (row) =>
          row.cartId.equals(cart.id!) & row.productId.equals(productId),
    );
    if (existing == null) return;
    await CartItem.db.deleteRow(session, existing);
  }

  Future<void> clear(Session session) async {
    final cart = await SessionService.requireCart(session);
    await CartItem.db.deleteWhere(
      session,
      where: (row) => row.cartId.equals(cart.id!),
    );
  }

  Future<CartItem> _requireItem(
    Session session,
    int cartId,
    int productId,
  ) async {
    final item = await CartItem.db.findFirstRow(
      session,
      where: (row) =>
          row.cartId.equals(cartId) & row.productId.equals(productId),
    );
    if (item == null) {
      throw PlaceifyException(
        message: 'Cart item not found.',
        code: 'CART_ITEM_NOT_FOUND',
      );
    }
    return item;
  }
}
