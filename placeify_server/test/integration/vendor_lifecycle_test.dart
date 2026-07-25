import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/modules/admin/admin_moderation_repository.dart';
import 'package:placeify_server/src/modules/checkout/checkout_repository.dart';
import 'package:placeify_server/src/modules/vendor/stores/vendor_delivery_store.dart';
import 'package:placeify_server/src/modules/vendor/stores/vendor_order_store.dart';
import 'package:placeify_server/src/modules/vendor/vendor_repository.dart';
import 'package:placeify_server/src/shared/placeify_exception.dart';
import 'package:serverpod/serverpod.dart' hide Order;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_test/serverpod_test.dart';
import 'package:test/test.dart';

import '../integration/test_tools/serverpod_test_tools.dart';

Future<({TestSessionBuilder session, User user})> _authUser(
  TestSessionBuilder sessionBuilder,
  Session setupSession, {
  String email = 'user@example.com',
  String name = 'Test User',
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
    await _seedVendorDocuments(setupSession, user.id!);
  }
  await setupSession.close();

  final session = sessionBuilder.copyWith(
    authentication: AuthenticationOverride.authenticationInfo(
      authUser.id.toString(),
      {},
    ),
  );

  return (session: session, user: user);
}

Future<void> _seedVendorDocuments(Session session, UuidValue userId) async {
  for (final type in [
    VendorDocumentType.businessLicense,
    VendorDocumentType.governmentId,
  ]) {
    await VendorDocument.db.insertRow(
      session,
      VendorDocument(
        userId: userId,
        documentType: type,
        fileUrl: 'https://example.com/$type.pdf',
      ),
    );
  }
}

void main() {
  withServerpod('Vendor lifecycle', (sessionBuilder, endpoints) {
    late VendorStore vendorStore;
    late VendorOrderStore orderStore;
    late VendorDeliveryStore deliveryStore;
    late AdminModerationStore moderationStore;
    late CheckoutStore checkoutStore;

    setUp(() {
      vendorStore = VendorStore();
      orderStore = VendorOrderStore();
      deliveryStore = VendorDeliveryStore();
      moderationStore = AdminModerationStore();
      checkoutStore = CheckoutStore();
    });

    test('application stays consumer until admin approval', () async {
      final setup = sessionBuilder.build();
      final applicant = await _authUser(
        sessionBuilder,
        setup,
        email: 'applicant@example.com',
        name: 'Applicant',
        status: UserAccountStatus.approved,
        seedVendorDocuments: true,
      );

      final vendor = await vendorStore.createShop(
        applicant.session.build(),
        'Pending Shop',
        description: 'Awaiting approval',
        phone: '9800000002',
        address: 'Lalitpur',
        city: 'Lalitpur',
        country: 'Nepal',
        shopCategory: 'Furniture',
      );

      expect(vendor.shopName, 'Pending Shop');

      final refreshed = await User.db.findById(
        applicant.session.build(),
        applicant.user.id!,
      );
      expect(refreshed!.role, UserRole.consumer);
      expect(refreshed.status, UserAccountStatus.pending);

      await expectLater(
        vendorStore.requireOwnedVendor(applicant.session.build()),
        throwsA(
          predicate<PlaceifyException>(
            (error) => error.code == 'VENDOR_NOT_APPROVED',
          ),
        ),
      );
    });

    test('full vendor order flow after admin approval', () async {
      final setup = sessionBuilder.build();

      final applicant = await _authUser(
        sessionBuilder,
        setup,
        email: 'vendor-flow@example.com',
        name: 'Vendor Flow',
        seedVendorDocuments: true,
      );

      final applicantSession = applicant.session.build();
      final createdVendor = await vendorStore.createShop(
        applicantSession,
        'Approved Shop',
        description: 'Ready for business',
        phone: '9800000003',
        address: 'Bhaktapur',
        city: 'Bhaktapur',
        country: 'Nepal',
        shopCategory: 'Furniture',
      );

      final adminSetup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        adminSetup,
        email: 'admin-flow@example.com',
        name: 'Admin Flow',
        role: UserRole.admin,
      );

      await moderationStore.approveVendor(
        admin.session.build(),
        applicant.user.id!,
      );

      final approvedUser = await User.db.findById(
        applicant.session.build(),
        applicant.user.id!,
      );
      expect(approvedUser!.role, UserRole.vendor);
      expect(approvedUser.status, UserAccountStatus.approved);

      final category = await Category.db.insertRow(
        applicant.session.build(),
        Category(name: 'chairs-${DateTime.now().microsecondsSinceEpoch}'),
      );

      final product = await vendorStore.createProduct(
        applicant.session.build(),
        'Oak Chair',
        'Solid oak dining chair',
        2500,
        categoryId: category.id,
        materials: 'Oak',
        widthCm: 45,
        depthCm: 50,
        heightCm: 90,
        careInstructions: 'Wipe with dry cloth',
        warranty: '1 year structural warranty',
      );

      expect(product.price, 2500);
      expect(product.isOffer, isFalse);

      final customerSetup = sessionBuilder.build();
      final customer = await _authUser(
        sessionBuilder,
        customerSetup,
        email: 'customer-flow@example.com',
        name: 'Customer Flow',
      );

      final cart = await Cart.db.insertRow(
        customer.session.build(),
        Cart(userId: customer.user.id!),
      );
      await CartItem.db.insertRow(
        customer.session.build(),
        CartItem(
          cartId: cart.id!,
          productId: product.id!,
          quantity: 1,
          unitPrice: product.price,
        ),
      );

      final checkout = await checkoutStore.checkout(
        customer.session.build(),
        CheckoutRequest(
          shippingAddress: 'Kathmandu, Nepal',
          paymentMethod: PaymentMethod.cashOnDelivery,
        ),
      );

      final orderId = checkout.order.id!;
      final accepted = await orderStore.acceptShopOrder(
        applicant.session.build(),
        orderId,
      );
      expect(accepted.status, OrderStatus.accepted);

      final stages = [
        DeliveryStage.packed,
        DeliveryStage.shipped,
        DeliveryStage.outForDelivery,
        DeliveryStage.delivered,
      ];

      for (final stage in stages) {
        await deliveryStore.submitDeliveryUpdate(
          applicant.session.build(),
          orderId,
          stage,
        );
      }

      final completed = await orderStore.getShopOrder(
        applicant.session.build(),
        orderId,
      );
      expect(completed.status, OrderStatus.delivered);

      final orderRow = await Order.db.findById(
        applicant.session.build(),
        orderId,
      );
      expect(orderRow!.deliveryStatus, OrderDeliveryStatus.delivered);
      expect(createdVendor.id, isNotNull);
    });

    test('rejects skipping delivery stages', () async {
      final setup = sessionBuilder.build();
      final vendorAuth = await _authUser(
        sessionBuilder,
        setup,
        email: 'delivery-guard@example.com',
        name: 'Delivery Guard',
        role: UserRole.vendor,
      );

      final vendor = await Vendor.db.insertRow(
        setup,
        Vendor(
          userId: vendorAuth.user.id!,
          shopName: 'Delivery Guard Shop',
          description: 'Test',
          businessAddress: 'Kathmandu',
        ),
      );

      final customerAuth = await AuthUsers().create(setup);
      final customer = await User.db.insertRow(
        setup,
        User(
          authUserId: customerAuth.id,
          email: 'buyer@example.com',
          name: 'Buyer',
          role: UserRole.consumer,
        ),
      );

      final category = await Category.db.insertRow(
        setup,
        Category(name: 'test-${DateTime.now().microsecondsSinceEpoch}'),
      );
      final product = await Product.db.insertRow(
        setup,
        Product(
          vendorId: vendor.id!,
          categoryId: category.id,
          name: 'Desk',
          description: 'Test desk',
          price: 5000,
          materials: 'Wood',
          widthCm: 100,
          depthCm: 60,
          heightCm: 75,
          careInstructions: 'Dust weekly',
          status: ProductStatus.active,
        ),
      );

      final order = await Order.db.insertRow(
        setup,
        Order(
          userId: customer.id!,
          status: OrderStatus.accepted,
          paymentStatus: OrderPaymentStatus.unpaid,
          totalAmount: 5000,
          shippingAddress: 'Kathmandu',
        ),
      );
      await OrderItem.db.insertRow(
        setup,
        OrderItem(
          orderId: order.id!,
          productId: product.id!,
          vendorId: vendor.id!,
          quantity: 1,
          unitPrice: 5000,
        ),
      );
      await OrderDeliveryUpdate.db.insertRow(
        setup,
        OrderDeliveryUpdate(
          orderId: order.id!,
          vendorId: vendor.id!,
          stage: DeliveryStage.orderPlaced,
        ),
      );

      await setup.close();

      await expectLater(
        deliveryStore.submitDeliveryUpdate(
          vendorAuth.session.build(),
          order.id!,
          DeliveryStage.shipped,
        ),
        throwsA(
          predicate<PlaceifyException>(
            (error) => error.code == 'INVALID_DELIVERY_STAGE',
          ),
        ),
      );
    });

    test('approved vendor can persist store visibility via isOpen', () async {
      final setup = sessionBuilder.build();

      final applicant = await _authUser(
        sessionBuilder,
        setup,
        email: 'visibility-${DateTime.now().microsecondsSinceEpoch}@example.com',
        name: 'Visibility Vendor',
        seedVendorDocuments: true,
      );

      final createdVendor = await vendorStore.createShop(
        applicant.session.build(),
        'Visibility Shop',
        description: 'Store visibility test',
        phone: '9800000099',
        address: 'Kathmandu',
        city: 'Kathmandu',
        country: 'Nepal',
        shopCategory: 'Furniture',
      );

      final adminSetup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        adminSetup,
        email: 'admin-vis-${DateTime.now().microsecondsSinceEpoch}@example.com',
        name: 'Admin Visibility',
        role: UserRole.admin,
      );

      await moderationStore.approveVendor(
        admin.session.build(),
        applicant.user.id!,
      );

      final closed = await vendorStore.updateMyProfile(
        applicant.session.build(),
        VendorProfileUpdateInput(isOpen: false),
      );
      expect(closed.isOpen, isFalse);

      final hiddenRow = await Vendor.db.findById(
        applicant.session.build(),
        createdVendor.id!,
      );
      expect(hiddenRow!.isOpen, isFalse);

      final reopened = await vendorStore.updateMyProfile(
        applicant.session.build(),
        VendorProfileUpdateInput(isOpen: true),
      );
      expect(reopened.isOpen, isTrue);
    });

    test('closed shop hidden from consumer listApprovedShops', () async {
      final setup = sessionBuilder.build();

      final applicant = await _authUser(
        sessionBuilder,
        setup,
        email: 'hidden-${DateTime.now().microsecondsSinceEpoch}@example.com',
        name: 'Hidden Shop Vendor',
        seedVendorDocuments: true,
      );

      final createdVendor = await vendorStore.createShop(
        applicant.session.build(),
        'Hidden From Customers',
        description: 'Should disappear when store visibility is off',
        phone: '9800000088',
        address: 'Kathmandu',
        city: 'Kathmandu',
        country: 'Nepal',
        shopCategory: 'Furniture',
      );

      final adminSetup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        adminSetup,
        email: 'admin-hidden-${DateTime.now().microsecondsSinceEpoch}@example.com',
        name: 'Admin Hidden',
        role: UserRole.admin,
      );

      await moderationStore.approveVendor(
        admin.session.build(),
        applicant.user.id!,
      );

      final visibleListings = await vendorStore.listApprovedShops(
        applicant.session.build(),
      );
      expect(
        visibleListings.any((shop) => shop.vendorId == createdVendor.id),
        isTrue,
      );

      await vendorStore.updateMyProfile(
        applicant.session.build(),
        VendorProfileUpdateInput(isOpen: false),
      );

      final hiddenListings = await vendorStore.listApprovedShops(
        applicant.session.build(),
      );
      expect(
        hiddenListings.any((shop) => shop.vendorId == createdVendor.id),
        isFalse,
      );

      final shopProfile = await vendorStore.getShopProfile(
        applicant.session.build(),
        createdVendor.id!,
      );
      expect(shopProfile, isNull);
    });
  });
}
