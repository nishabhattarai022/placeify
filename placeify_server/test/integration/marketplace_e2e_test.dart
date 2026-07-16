import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/modules/product/product_repository.dart';
import 'package:placeify_server/src/modules/admin/admin_moderation_repository.dart';
import 'package:placeify_server/src/modules/checkout/checkout_repository.dart';
import 'package:placeify_server/src/modules/payment/payment_repository.dart';
import 'package:placeify_server/src/modules/vendor/stores/vendor_delivery_store.dart';
import 'package:placeify_server/src/modules/vendor/stores/vendor_order_store.dart';
import 'package:placeify_server/src/modules/vendor/vendor_repository.dart';
import 'package:serverpod/serverpod.dart' hide Order;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_test/serverpod_test.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

Future<({TestSessionBuilder session, User user})> _authUser(
  TestSessionBuilder sessionBuilder,
  Session setupSession, {
  required String email,
  required String name,
  UserRole role = UserRole.consumer,
  UserAccountStatus status = UserAccountStatus.approved,
  bool seedVendorDocuments = false,
}) async {
  final authUser = await AuthUsers().create(setupSession);
  final user = await User.db.insertRow(
    setupSession,
    User(
      authUserId: authUser.id,
      email: email,
      name: name,
      role: role,
      status: status,
      phone: '9800000001',
      address: 'Kathmandu',
    ),
  );
  if (seedVendorDocuments) {
    for (final type in [
      VendorDocumentType.businessLicense,
      VendorDocumentType.governmentId,
    ]) {
      await VendorDocument.db.insertRow(
        setupSession,
        VendorDocument(
          userId: user.id!,
          documentType: type,
          fileUrl: 'https://example.com/$type.pdf',
        ),
      );
    }
  }
  await setupSession.close();

  return (
    session: sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        authUser.id.toString(),
        {},
      ),
    ),
    user: user,
  );
}

Future<({TestSessionBuilder session, User user})> _seedApprovedVendor(
  TestSessionBuilder sessionBuilder,
  Session setup,
  String suffix,
) async {
  final auth = await AuthUsers().create(setup);
  final user = await User.db.insertRow(
    setup,
    User(
      authUserId: auth.id,
      email: 'vendor-$suffix@example.com',
      name: 'Vendor $suffix',
      role: UserRole.vendor,
      status: UserAccountStatus.approved,
    ),
  );
  await Vendor.db.insertRow(
    setup,
    Vendor(
      userId: user.id!,
      shopName: 'Shop $suffix',
      description: 'Test shop',
      businessAddress: 'Kathmandu',
    ),
  );
  await setup.close();

  return (
    session: sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        auth.id.toString(),
        {},
      ),
    ),
    user: user,
  );
}

void main() {
  withServerpod('Marketplace end-to-end', (sessionBuilder, endpoints) {
    late VendorStore vendorStore;
    late AdminModerationStore moderationStore;
    late CatalogRepository catalog;
    late CheckoutStore checkoutStore;
    late VendorOrderStore orderStore;
    late VendorDeliveryStore deliveryStore;
    late PaymentStore paymentStore;

    setUp(() {
      vendorStore = VendorStore();
      moderationStore = AdminModerationStore();
      catalog = CatalogRepository();
      checkoutStore = CheckoutStore();
      orderStore = VendorOrderStore();
      deliveryStore = VendorDeliveryStore();
      paymentStore = PaymentStore(vendorStore: vendorStore);
    });

    test('1 register → shop → pending → approve → upload → catalog', () async {
      final setup = sessionBuilder.build();
      final applicant = await _authUser(
        sessionBuilder,
        setup,
        email: 'e2e-applicant@example.com',
        name: 'E2E Applicant',
        seedVendorDocuments: true,
      );

      await vendorStore.createShop(
        applicant.session.build(),
        'E2E Shop',
        description: 'Awaiting approval',
        phone: '9800000010',
        address: 'Kathmandu',
        city: 'Kathmandu',
        country: 'Nepal',
        shopCategory: 'Furniture',
      );

      final pending = await User.db.findById(
        applicant.session.build(),
        applicant.user.id!,
      );
      expect(pending!.role, UserRole.consumer);
      expect(pending.status, UserAccountStatus.pending);

      final adminSetup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        adminSetup,
        email: 'e2e-admin@example.com',
        name: 'E2E Admin',
        role: UserRole.admin,
      );
      await moderationStore.approveVendor(
        admin.session.build(),
        applicant.user.id!,
      );

      final category = await Category.db.insertRow(
        applicant.session.build(),
        Category(name: 'chairs-e2e-${DateTime.now().microsecondsSinceEpoch}'),
      );

      final product = await vendorStore.createProduct(
        applicant.session.build(),
        'E2E Chair',
        'Catalog visible chair',
        3200,
        categoryId: category.id,
        materials: 'Wood',
        widthCm: 45,
        depthCm: 50,
        heightCm: 90,
        careInstructions: 'Wipe clean',
      );

      final highlights = await catalog.marketplaceHighlights(
        applicant.session.build(),
      );
      expect(highlights.recentProducts.map((p) => p.id), contains(product.id));

      final search = await catalog.searchProducts(
        applicant.session.build(),
        ProductSearchInput(query: 'E2E Chair'),
      );
      expect(search.items.map((p) => p.id), contains(product.id));
    });

    test('2 discounted product appears in offer feed', () async {
      final setup = sessionBuilder.build();
      final vendor = await _seedApprovedVendor(sessionBuilder, setup, 'offer');
      final session = vendor.session.build();

      final category = await Category.db.insertRow(
        session,
        Category(name: 'offer-${DateTime.now().microsecondsSinceEpoch}'),
      );

      final offer = await Product.db.insertRow(
        session,
        Product(
          vendorId: (await Vendor.db.findFirstRow(
            session,
            where: (row) => row.userId.equals(vendor.user.id!),
          ))!
              .id!,
          categoryId: category.id,
          name: 'Discount Sofa',
          description: 'Offer item',
          price: 10000,
          discountPrice: 7000,
          isOffer: true,
          materials: 'Fabric',
          widthCm: 200,
          depthCm: 90,
          heightCm: 85,
          careInstructions: 'Vacuum',
          status: ProductStatus.active,
        ),
      );

      final highlights = await catalog.marketplaceHighlights(session);
      expect(highlights.offerProducts.map((p) => p.id), contains(offer.id));
    });

    test('3 featured product appears in featured feed', () async {
      final setup = sessionBuilder.build();
      final vendor = await _seedApprovedVendor(sessionBuilder, setup, 'featured');
      final session = vendor.session.build();

      final featured = await Product.db.insertRow(
        session,
        Product(
          vendorId: (await Vendor.db.findFirstRow(
            session,
            where: (row) => row.userId.equals(vendor.user.id!),
          ))!
              .id!,
          name: 'Featured Lamp',
          description: 'Featured item',
          price: 1500,
          featured: true,
          materials: 'Metal',
          widthCm: 20,
          depthCm: 20,
          heightCm: 50,
          careInstructions: 'Dust',
          status: ProductStatus.active,
        ),
      );

      final highlights = await catalog.marketplaceHighlights(session);
      expect(highlights.featuredProducts.map((p) => p.id), contains(featured.id));
    });

    test('4 vendor delete removes product from all catalog surfaces', () async {
      final setup = sessionBuilder.build();
      final vendor = await _seedApprovedVendor(sessionBuilder, setup, 'delete');
      final session = vendor.session.build();

      final product = await Product.db.insertRow(
        session,
        Product(
          vendorId: (await Vendor.db.findFirstRow(
            session,
            where: (row) => row.userId.equals(vendor.user.id!),
          ))!
              .id!,
          name: 'Delete Me Table',
          description: 'Will be soft-deleted',
          price: 4500,
          isOffer: true,
          featured: true,
          materials: 'Wood',
          widthCm: 120,
          depthCm: 60,
          heightCm: 75,
          careInstructions: 'Wipe',
          status: ProductStatus.active,
        ),
      );

      final before = await catalog.marketplaceHighlights(session);
      expect(before.recentProducts.map((p) => p.id), contains(product.id));

      await vendorStore.deleteProduct(session, product.id!);

      final highlights = await catalog.marketplaceHighlights(session);
      expect(highlights.recentProducts.map((p) => p.id), isNot(contains(product.id)));
      expect(highlights.featuredProducts.map((p) => p.id), isNot(contains(product.id)));
      expect(highlights.offerProducts.map((p) => p.id), isNot(contains(product.id)));

      final search = await catalog.searchProducts(
        session,
        ProductSearchInput(query: 'Delete Me'),
      );
      expect(search.items, isEmpty);
      expect(await catalog.getProduct(session, product.id!), isNull);
    });

    test('5 vendor restore makes product visible again', () async {
      final setup = sessionBuilder.build();
      final vendor = await _seedApprovedVendor(sessionBuilder, setup, 'restore');
      final session = vendor.session.build();

      final product = await Product.db.insertRow(
        session,
        Product(
          vendorId: (await Vendor.db.findFirstRow(
            session,
            where: (row) => row.userId.equals(vendor.user.id!),
          ))!
              .id!,
          name: 'Restore Chair',
          description: 'Soft deleted then restored',
          price: 2200,
          materials: 'Wood',
          widthCm: 45,
          depthCm: 50,
          heightCm: 90,
          careInstructions: 'Wipe',
          status: ProductStatus.active,
        ),
      );

      await vendorStore.deleteProduct(session, product.id!);
      expect(
        (await catalog.marketplaceHighlights(session)).recentProducts,
        isEmpty,
      );

      await vendorStore.restoreProduct(session, product.id!);
      final highlights = await catalog.marketplaceHighlights(session);
      expect(highlights.recentProducts.map((p) => p.id), contains(product.id));
    });

    test('6 checkout notifies vendor of new order', () async {
      final setup = sessionBuilder.build();
      final vendor = await _seedApprovedVendor(sessionBuilder, setup, 'notify-v');
      final vendorSession = vendor.session.build();
      final vendorRow = await Vendor.db.findFirstRow(
        vendorSession,
        where: (row) => row.userId.equals(vendor.user.id!),
      );

      final product = await Product.db.insertRow(
        vendorSession,
        Product(
          vendorId: vendorRow!.id!,
          name: 'Notify Chair',
          description: 'Order notification test',
          price: 1800,
          materials: 'Wood',
          widthCm: 45,
          depthCm: 50,
          heightCm: 90,
          careInstructions: 'Wipe',
          status: ProductStatus.active,
        ),
      );

      final customerSetup = sessionBuilder.build();
      final customer = await _authUser(
        sessionBuilder,
        customerSetup,
        email: 'e2e-customer@example.com',
        name: 'E2E Customer',
      );
      final customerSession = customer.session.build();

      final cart = await Cart.db.insertRow(
        customerSession,
        Cart(userId: customer.user.id!),
      );
      await CartItem.db.insertRow(
        customerSession,
        CartItem(
          cartId: cart.id!,
          productId: product.id!,
          quantity: 1,
          unitPrice: product.price,
        ),
      );

      final checkout = await checkoutStore.checkout(
        customerSession,
        CheckoutRequest(
          shippingAddress: 'Kathmandu, Nepal',
          paymentMethod: PaymentMethod.cod,
        ),
      );

      final notifications = await InAppNotification.db.find(
        customerSession,
        where: (row) => row.userId.equals(vendor.user.id!),
      );
      expect(notifications, isNotEmpty);
      expect(notifications.first.type, InAppNotificationType.orderPlaced);
      expect(notifications.first.referenceId, checkout.order.id);
    });

    test('7 vendor accept notifies customer', () async {
      final setup = sessionBuilder.build();
      final vendor = await _seedApprovedVendor(sessionBuilder, setup, 'accept');
      final vendorSession = vendor.session.build();
      final vendorRow = await Vendor.db.findFirstRow(
        vendorSession,
        where: (row) => row.userId.equals(vendor.user.id!),
      );

      final product = await Product.db.insertRow(
        vendorSession,
        Product(
          vendorId: vendorRow!.id!,
          name: 'Accept Chair',
          description: 'Accept notification test',
          price: 2100,
          materials: 'Wood',
          widthCm: 45,
          depthCm: 50,
          heightCm: 90,
          careInstructions: 'Wipe',
          status: ProductStatus.active,
        ),
      );

      final customerSetup = sessionBuilder.build();
      final customer = await _authUser(
        sessionBuilder,
        customerSetup,
        email: 'e2e-accept-customer@example.com',
        name: 'Accept Customer',
      );
      final customerSession = customer.session.build();

      final cart = await Cart.db.insertRow(
        customerSession,
        Cart(userId: customer.user.id!),
      );
      await CartItem.db.insertRow(
        customerSession,
        CartItem(
          cartId: cart.id!,
          productId: product.id!,
          quantity: 1,
          unitPrice: product.price,
        ),
      );

      final checkout = await checkoutStore.checkout(
        customerSession,
        CheckoutRequest(
          shippingAddress: 'Kathmandu, Nepal',
          paymentMethod: PaymentMethod.cod,
        ),
      );

      await orderStore.acceptShopOrder(vendorSession, checkout.order.id!);

      final notifications = await InAppNotification.db.find(
        customerSession,
        where: (row) => row.userId.equals(customer.user.id!),
      );
      expect(
        notifications.any((n) => n.type == InAppNotificationType.orderAccepted),
        isTrue,
      );
    });

    test('8 delivery timeline advances packed → delivered', () async {
      final setup = sessionBuilder.build();
      final vendor = await _seedApprovedVendor(sessionBuilder, setup, 'delivery');
      final vendorSession = vendor.session.build();
      final vendorRow = await Vendor.db.findFirstRow(
        vendorSession,
        where: (row) => row.userId.equals(vendor.user.id!),
      );

      final product = await Product.db.insertRow(
        vendorSession,
        Product(
          vendorId: vendorRow!.id!,
          name: 'Delivery Desk',
          description: 'Delivery timeline test',
          price: 5500,
          materials: 'Wood',
          widthCm: 120,
          depthCm: 60,
          heightCm: 75,
          careInstructions: 'Wipe',
          status: ProductStatus.active,
        ),
      );

      final customerSetup = sessionBuilder.build();
      final customer = await _authUser(
        sessionBuilder,
        customerSetup,
        email: 'e2e-delivery-customer@example.com',
        name: 'Delivery Customer',
      );
      final customerSession = customer.session.build();

      final cart = await Cart.db.insertRow(
        customerSession,
        Cart(userId: customer.user.id!),
      );
      await CartItem.db.insertRow(
        customerSession,
        CartItem(
          cartId: cart.id!,
          productId: product.id!,
          quantity: 1,
          unitPrice: product.price,
        ),
      );

      final checkout = await checkoutStore.checkout(
        customerSession,
        CheckoutRequest(
          shippingAddress: 'Kathmandu, Nepal',
          paymentMethod: PaymentMethod.cod,
        ),
      );
      final orderId = checkout.order.id!;
      await orderStore.acceptShopOrder(vendorSession, orderId);

      for (final stage in [
        DeliveryStage.packed,
        DeliveryStage.shipped,
        DeliveryStage.outForDelivery,
        DeliveryStage.delivered,
      ]) {
        await deliveryStore.submitDeliveryUpdate(vendorSession, orderId, stage);
      }

      final timeline = await deliveryStore.listDeliveryUpdates(
        vendorSession,
        orderId,
      );
      expect(
        timeline.map((u) => u.stage),
        containsAll([
          DeliveryStage.orderPlaced,
          DeliveryStage.packed,
          DeliveryStage.shipped,
          DeliveryStage.outForDelivery,
          DeliveryStage.delivered,
        ]),
      );

      final order = await Order.db.findById(vendorSession, orderId);
      expect(order!.deliveryStatus, OrderDeliveryStatus.delivered);
    });

    test('9 vendor payment update records payment history', () async {
      final setup = sessionBuilder.build();
      final vendor = await _seedApprovedVendor(sessionBuilder, setup, 'payment');
      final vendorSession = vendor.session.build();
      final vendorRow = await Vendor.db.findFirstRow(
        vendorSession,
        where: (row) => row.userId.equals(vendor.user.id!),
      );

      final product = await Product.db.insertRow(
        vendorSession,
        Product(
          vendorId: vendorRow!.id!,
          name: 'Payment Chair',
          description: 'Payment history test',
          price: 3000,
          materials: 'Wood',
          widthCm: 45,
          depthCm: 50,
          heightCm: 90,
          careInstructions: 'Wipe',
          status: ProductStatus.active,
        ),
      );

      final customerSetup = sessionBuilder.build();
      final customer = await _authUser(
        sessionBuilder,
        customerSetup,
        email: 'e2e-payment-customer@example.com',
        name: 'Payment Customer',
      );
      final customerSession = customer.session.build();

      final cart = await Cart.db.insertRow(
        customerSession,
        Cart(userId: customer.user.id!),
      );
      await CartItem.db.insertRow(
        customerSession,
        CartItem(
          cartId: cart.id!,
          productId: product.id!,
          quantity: 1,
          unitPrice: product.price,
        ),
      );

      final checkout = await checkoutStore.checkout(
        customerSession,
        CheckoutRequest(
          shippingAddress: 'Kathmandu, Nepal',
          paymentMethod: PaymentMethod.cod,
        ),
      );
      final orderId = checkout.order.id!;
      await orderStore.acceptShopOrder(vendorSession, orderId);

      await paymentStore.updateOrderPaymentStatus(
        vendorSession,
        orderId,
        PaymentTransactionStatus.paid,
        note: 'COD received at door',
      );

      final history = await paymentStore.listUpdatesForOrder(
        vendorSession,
        orderId,
      );
      expect(history, isNotEmpty);
      expect(history.last.note, contains('COD received'));
    });

    test('10 unapproved vendor product never appears in catalog', () async {
      final setup = sessionBuilder.build();
      final auth = await AuthUsers().create(setup);
      final pendingUser = await User.db.insertRow(
        setup,
        User(
          authUserId: auth.id,
          email: 'e2e-pending@example.com',
          name: 'Pending Vendor',
          role: UserRole.consumer,
          status: UserAccountStatus.pending,
        ),
      );
      final pendingVendor = await Vendor.db.insertRow(
        setup,
        Vendor(
          userId: pendingUser.id!,
          shopName: 'Pending E2E Shop',
          description: 'Not approved',
          businessAddress: 'Kathmandu',
        ),
      );
      await Product.db.insertRow(
        setup,
        Product(
          vendorId: pendingVendor.id!,
          name: 'Hidden E2E Product',
          description: 'Should not appear',
          price: 999,
          materials: 'Wood',
          widthCm: 40,
          depthCm: 40,
          heightCm: 80,
          careInstructions: 'Wipe',
          status: ProductStatus.active,
        ),
      );
      await setup.close();

      final highlights = await catalog.marketplaceHighlights(
        sessionBuilder.build(),
      );
      expect(highlights.recentProducts, isEmpty);
      expect(highlights.featuredProducts, isEmpty);
      expect(highlights.offerProducts, isEmpty);

      final search = await catalog.searchProducts(
        sessionBuilder.build(),
        ProductSearchInput(query: 'Hidden E2E'),
      );
      expect(search.items, isEmpty);
    });
  });
}
