import 'package:placeify_server/src/generated/protocol.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'package:placeify_server/src/modules/notification/in_app_notification_store.dart';
import 'package:placeify_server/src/modules/notification/order_notification_service.dart';

void main() {
  withServerpod('Order lifecycle notifications', (sessionBuilder, endpoints) {
    test('new order persists a vendor in-app notification', () async {
      final setupSession = sessionBuilder.build();

      final vendorAuth = await AuthUsers().create(setupSession);
      final customerAuth = await AuthUsers().create(setupSession);

      final vendorUser = await User.db.insertRow(
        setupSession,
        User(
          authUserId: vendorAuth.id,
          email: 'vendor@example.com',
          name: 'Vendor Shop',
          role: UserRole.vendor,
          status: UserAccountStatus.approved,
        ),
      );

      final customerUser = await User.db.insertRow(
        setupSession,
        User(
          authUserId: customerAuth.id,
          email: 'customer@example.com',
          name: 'Rosika G',
          role: UserRole.consumer,
          status: UserAccountStatus.approved,
        ),
      );

      final vendor = await Vendor.db.insertRow(
        setupSession,
        Vendor(
          userId: vendorUser.id!,
          shopName: 'Test Shop',
          description: 'Test',
          businessAddress: 'Kathmandu',
        ),
      );

      final order = await Order.db.insertRow(
        setupSession,
        Order(
          userId: customerUser.id!,
          status: OrderStatus.pending,
          totalAmount: 2500,
          shippingAddress: 'Kathmandu',
          autoExpiresAt: DateTime.now().add(const Duration(days: 30)),
        ),
      );

      await OrderNotificationService.notifyVendorNewOrder(
        setupSession,
        order: order,
        vendorId: vendor.id!,
        customerName: customerUser.name,
        itemCount: 2,
      );

      final notifications = await InAppNotification.db.find(
        setupSession,
        where: (row) => row.userId.equals(vendorUser.id!),
      );

      expect(notifications, hasLength(1));
      expect(notifications.first.type, InAppNotificationType.orderPlaced);
      expect(notifications.first.message, contains('Rosika G'));
      expect(notifications.first.referenceId, order.id);
      expect(notifications.first.isRead, isFalse);

      await setupSession.close();
    });
  });
}
