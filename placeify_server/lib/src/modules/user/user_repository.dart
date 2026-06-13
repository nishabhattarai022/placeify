import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../ar/ar_repository.dart';
import '../wishlist/wishlist_repository.dart';

class UserProfileStore {
  UserProfileStore({
    WishlistStore? wishlistStore,
    ArSessionStore? arSessionStore,
  })  : _wishlistStore = wishlistStore ?? WishlistStore(),
        _arSessionStore = arSessionStore ?? ArSessionStore();

  final WishlistStore _wishlistStore;
  final ArSessionStore _arSessionStore;

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

  Future<UserDashboard> buildDashboard(Session session, User user) async {
    final userId = user.id!;

    final orderCount = await Order.db.count(
      session,
      where: (order) => order.userId.equals(userId),
    );

    final wishlistCount = await _wishlistStore.countForUser(session, userId);
    final arSessionCount = await _arSessionStore.countForUser(session, userId);

    return UserDashboard(
      profile: user,
      orderCount: orderCount,
      wishlistCount: wishlistCount,
      arSessionCount: arSessionCount,
      refundCount: 0,
    );
  }
}
