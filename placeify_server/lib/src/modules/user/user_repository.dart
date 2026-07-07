import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../ar/ar_repository.dart';
import '../product/product_repository.dart';
import '../refund/refund_repository.dart';
import '../wishlist/wishlist_repository.dart';

class UserProfileStore {
  UserProfileStore({
    WishlistStore? wishlistStore,
    ArSessionStore? arSessionStore,
    RefundStore? refundStore,
    CatalogRepository? catalogStore,
  })  : _wishlistStore = wishlistStore ?? WishlistStore(),
        _arSessionStore = arSessionStore ?? ArSessionStore(),
        _refundStore = refundStore ?? RefundStore(),
        _catalogStore = catalogStore ?? CatalogRepository();

  final WishlistStore _wishlistStore;
  final ArSessionStore _arSessionStore;
  final RefundStore _refundStore;
  final CatalogRepository _catalogStore;

  Future<User?> findByAuthUserId(Session session, UuidValue authUserId) {
    return User.db.findFirstRow(
      session,
      where: (row) => row.authUserId.equals(authUserId),
    );
  }

  Future<User> upsertProfile(
    Session session,
    UuidValue authUserId,
    String name, {
    String? email,
    String? phone,
    String? address,
  }) async {
    final existing = await findByAuthUserId(session, authUserId);
    if (existing == null) {
      return User.db.insertRow(
        session,
        User(
          authUserId: authUserId,
          name: name,
          email: email?.trim().toLowerCase(),
          phone: phone,
          address: address,
          role: UserRole.consumer,
          status: UserAccountStatus.approved,
        ),
      );
    }

    return User.db.updateRow(
      session,
      existing.copyWith(
        name: name,
        email: email?.trim().toLowerCase() ?? existing.email,
        phone: phone,
        address: address,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<int> _countCartItems(Session session, UuidValue userId) async {
    final cart = await Cart.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(userId),
    );
    if (cart?.id == null) return 0;

    final items = await CartItem.db.find(
      session,
      where: (row) => row.cartId.equals(cart!.id!),
    );
    return items.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  /// Profile stat: orders that are not terminal failures (cancelled/rejected).
  Future<int> _countDashboardOrders(Session session, UuidValue userId) async {
    final excluded = await Order.db.count(
      session,
      where: (order) {
        return order.userId.equals(userId) &
            (order.status.equals(OrderStatus.cancelled) |
                order.status.equals(OrderStatus.autoCancelled) |
                order.status.equals(OrderStatus.rejected));
      },
    );

    final total = await Order.db.count(
      session,
      where: (order) => order.userId.equals(userId),
    );

    return total - excluded;
  }

  Future<UserDashboard> buildDashboard(Session session, User user) async {
    final userId = user.id!;

    final orderCount = await _countDashboardOrders(session, userId);

    final wishlistCount = await _wishlistStore.countForUser(session, userId);
    final arSessionCount = await _arSessionStore.countForUser(session, userId);
    final refundCount = await _refundStore.countForUser(session, userId);
    final cartItemCount = await _countCartItems(session, userId);
    final marketplace = await _catalogStore.marketplaceHighlights(session);

    return UserDashboard(
      profile: user,
      orderCount: orderCount,
      wishlistCount: wishlistCount,
      cartItemCount: cartItemCount,
      arSessionCount: arSessionCount,
      refundCount: refundCount,
      marketplace: marketplace,
    );
  }
}
