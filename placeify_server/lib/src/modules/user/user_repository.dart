import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../ar/ar_repository.dart';
import '../refund/refund_repository.dart';
import '../wishlist/wishlist_repository.dart';

class UserProfileStore {
  UserProfileStore({
    WishlistStore? wishlistStore,
    ArSessionStore? arSessionStore,
    RefundStore? refundStore,
  })  : _wishlistStore = wishlistStore ?? WishlistStore(),
        _arSessionStore = arSessionStore ?? ArSessionStore(),
        _refundStore = refundStore ?? RefundStore();

  final WishlistStore _wishlistStore;
  final ArSessionStore _arSessionStore;
  final RefundStore _refundStore;

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
          phone: phone,
          address: address,
          role: UserRole.consumer,
        ),
      );
    }

    return User.db.updateRow(
      session,
      existing.copyWith(
        name: name,
        phone: phone,
        address: address,
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

  Future<UserDashboard> buildDashboard(Session session, User user) async {
    final userId = user.id!;

    final orderCount = await Order.db.count(
      session,
      where: (order) => order.userId.equals(userId),
    );

    final wishlistCount = await _wishlistStore.countForUser(session, userId);
    final arSessionCount = await _arSessionStore.countForUser(session, userId);
    final refundCount = await _refundStore.countForUser(session, userId);
    final cartItemCount = await _countCartItems(session, userId);

    return UserDashboard(
      profile: user,
      orderCount: orderCount,
      wishlistCount: wishlistCount,
      cartItemCount: cartItemCount,
      arSessionCount: arSessionCount,
      refundCount: refundCount,
    );
  }
}
