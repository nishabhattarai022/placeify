import 'package:placeify_server/src/generated/user.dart';
import 'package:serverpod/serverpod.dart' hide Order;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_test/serverpod_test.dart';

import 'package:placeify_server/src/generated/protocol.dart';
import 'serverpod_test_tools.dart';

typedef AuthenticatedTestSession = TestSessionBuilder;

/// Auth session without a Placeify profile row (for backfill tests).
Future<AuthenticatedTestSession> createAuthSessionOnly(
  TestSessionBuilder sessionBuilder,
) async {
  final setupSession = sessionBuilder.build();
  final authUser = await AuthUsers().create(setupSession);
  await setupSession.close();

  return sessionBuilder.copyWith(
    authentication: AuthenticationOverride.authenticationInfo(
      authUser.id.toString(),
      {},
    ),
  );
}

/// Creates an authenticated test session with a Placeify user profile.
Future<({AuthenticatedTestSession session, User profile})>
    createAuthenticatedUser(
  TestSessionBuilder sessionBuilder,
  dynamic endpoints, {
  String name = 'Test User',
}) async {
  final setupSession = sessionBuilder.build();
  final authUser = await AuthUsers().create(setupSession);
  await setupSession.close();

  final authenticated = sessionBuilder.copyWith(
    authentication: AuthenticationOverride.authenticationInfo(
      authUser.id.toString(),
      {},
    ),
  );

  await endpoints.user.updateProfile(
    authenticated,
    name,
  );

  final profile = await endpoints.user.getCurrentUser(authenticated) as User;
  if (profile.id == null) {
    throw StateError('Expected Placeify user profile after updateProfile.');
  }

  return (session: authenticated, profile: profile);
}

/// Inserts an approved vendor shop and active product for integration tests.
Future<({Vendor vendor, Product product})> seedProductForUser(
  Session session,
  User user,
) async {
  final vendorAuth = await AuthUsers().create(session);
  final vendorUser = await User.db.insertRow(
    session,
    User(
      authUserId: vendorAuth.id,
      email: 'vendor-seed-${DateTime.now().microsecondsSinceEpoch}@test.com',
      name: 'Seed Vendor',
      role: UserRole.vendor,
      status: UserAccountStatus.approved,
    ),
  );

  final vendor = await Vendor.db.insertRow(
    session,
    Vendor(
      userId: vendorUser.id!,
      shopName: 'Test Shop ${DateTime.now().microsecondsSinceEpoch}',
      description: 'Integration test vendor',
    ),
  );

  final category = await Category.db.insertRow(
    session,
    Category(
      name: 'test-${DateTime.now().microsecondsSinceEpoch}',
      description: 'Test category',
    ),
  );

  final product = await Product.db.insertRow(
    session,
    Product(
      vendorId: vendor.id!,
      categoryId: category.id,
      name: 'Test Chair',
      description: 'Integration test product',
      price: 199,
      status: ProductStatus.active,
    ),
  );

  return (vendor: vendor, product: product);
}

/// Inserts an order with one line item for [user].
Future<Order> seedOrderForUser(
  Session session,
  User user,
  Product product,
) async {
  final order = await Order.db.insertRow(
    session,
    Order(
      userId: user.id!,
      status: OrderStatus.delivered,
      totalAmount: product.price,
      shippingAddress: 'Kathmandu, Nepal',
    ),
  );

  await OrderItem.db.insertRow(
    session,
    OrderItem(
      orderId: order.id!,
      productId: product.id!,
      vendorId: product.vendorId,
      quantity: 1,
      unitPrice: product.price,
    ),
  );

  return order;
}
