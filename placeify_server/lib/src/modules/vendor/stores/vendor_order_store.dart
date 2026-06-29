import 'package:serverpod/serverpod.dart' hide Order;

import '../../../generated/protocol.dart';
import '../../../shared/placeify_exception.dart';
import '../../../shared/session_service.dart';
import '../../marketplace/marketplace_events.dart';
import '../../order/order_lifecycle_store.dart';
import 'vendor_access_guard.dart';
import 'vendor_order_support.dart';

/// Vendor shop order listing, acceptance, and rejection.
class VendorOrderStore {
  VendorOrderStore({
    VendorAccessGuard? access,
    MarketplaceEventDispatcher? events,
  })  : _access = access ?? VendorAccessGuard(),
        _events = events ?? marketplaceEventDispatcher;

  final VendorAccessGuard _access;
  final MarketplaceEventDispatcher _events;

  Future<List<VendorShopOrder>> listShopOrders(
    Session session, {
    int limit = 50,
    int offset = 0,
    OrderStatus? status,
  }) async {
    final vendor = await _access.requireOwnedVendor(session);
    final orderItems =
        await VendorOrderSupport.loadVendorOrderItems(session, vendor.id!);
    final orders = VendorOrderSupport.groupVendorShopOrders(orderItems);

    final filtered = status == null
        ? orders
        : orders.where((order) => order.status == status).toList();

    final stages = await VendorOrderSupport.latestDeliveryStagesForOrders(
      session,
      vendor.id!,
      filtered.map((order) => order.orderId).toSet(),
    );

    final enriched = [
      for (final order in filtered)
        VendorOrderSupport.withDeliveryStage(
          order,
          stages[order.orderId],
        ),
    ];

    if (offset >= enriched.length) return [];
    final end = offset + limit;
    return enriched.sublist(
      offset,
      end > enriched.length ? enriched.length : end,
    );
  }

  Future<VendorShopOrder> getShopOrder(Session session, int orderId) async {
    final vendor = await _access.requireOwnedVendor(session);
    final orderItems = await OrderItem.db.find(
      session,
      where: (row) =>
          row.vendorId.equals(vendor.id!) & row.orderId.equals(orderId),
      include: OrderItem.include(
        order: Order.include(user: User.include()),
        product: Product.include(),
      ),
      orderBy: (row) => row.id,
    );

    if (orderItems.isEmpty) {
      throw PlaceifyException(
        message: 'Order not found.',
        code: 'ORDER_NOT_FOUND',
      );
    }

    final orders = VendorOrderSupport.groupVendorShopOrders(orderItems);
    if (orders.isEmpty) {
      throw PlaceifyException(
        message: 'Order not found.',
        code: 'ORDER_NOT_FOUND',
      );
    }

    final stages = await VendorOrderSupport.latestDeliveryStagesForOrders(
      session,
      vendor.id!,
      {orderId},
    );
    return VendorOrderSupport.withDeliveryStage(
      orders.first,
      stages[orderId],
    );
  }

  Future<VendorShopOrder> acceptShopOrder(Session session, int orderId) async {
    final vendor = await _access.requireOwnedVendor(session);
    final user = await SessionService.requireUser(session);
    final order = await VendorOrderSupport.requireMutableVendorOrder(
      session,
      vendor.id!,
      orderId,
    );

    if (order.status != OrderStatus.pending &&
        order.status != OrderStatus.confirmed) {
      throw PlaceifyException(
        message: 'Only pending orders can be accepted.',
        code: 'INVALID_ORDER_STATUS',
      );
    }

    Order? acceptedOrder;
    await session.db.transaction((transaction) async {
      acceptedOrder = await OrderLifecycleStore.updateOrderWithVersion(
        session,
        order,
        (current) => current.copyWith(
          status: OrderStatus.accepted,
          rejectionReason: null,
        ),
        transaction: transaction,
      );

      await OrderLifecycleStore.appendHistory(
        session,
        orderId,
        statusType: OrderStatusHistoryType.order,
        previousStatus: order.status.name,
        newStatus: OrderStatus.accepted.name,
        changedByUserId: user.id,
        transaction: transaction,
      );

      final existingUpdates = await OrderDeliveryUpdate.db.find(
        session,
        where: (row) =>
            row.orderId.equals(orderId) & row.vendorId.equals(vendor.id!),
        transaction: transaction,
      );
      if (existingUpdates.isEmpty) {
        await OrderDeliveryUpdate.db.insertRow(
          session,
          OrderDeliveryUpdate(
            orderId: orderId,
            vendorId: vendor.id!,
            stage: DeliveryStage.orderPlaced,
            note: 'Order confirmed by vendor.',
          ),
          transaction: transaction,
        );
      }
    });

    if (acceptedOrder != null) {
      await _events.dispatch(
        session,
        OrderAcceptedEvent(order: acceptedOrder!, vendorId: vendor.id!),
      );
    }

    return getShopOrder(session, orderId);
  }

  Future<VendorShopOrder> rejectShopOrder(
    Session session,
    int orderId,
    String reason,
  ) async {
    final vendor = await _access.requireOwnedVendor(session);
    final user = await SessionService.requireUser(session);
    final trimmedReason = reason.trim();
    if (trimmedReason.isEmpty) {
      throw PlaceifyException(
        message: 'A rejection reason is required.',
        code: 'INVALID_REJECTION_REASON',
      );
    }

    final order = await VendorOrderSupport.requireMutableVendorOrder(
      session,
      vendor.id!,
      orderId,
    );
    if (order.status != OrderStatus.pending &&
        order.status != OrderStatus.confirmed) {
      throw PlaceifyException(
        message: 'Only pending orders can be rejected.',
        code: 'INVALID_ORDER_STATUS',
      );
    }

    Order? rejectedOrder;
    await session.db.transaction((transaction) async {
      rejectedOrder = await OrderLifecycleStore.updateOrderWithVersion(
        session,
        order,
        (current) => current.copyWith(
          status: OrderStatus.rejected,
          rejectionReason: trimmedReason,
        ),
        transaction: transaction,
      );

      await OrderLifecycleStore.appendHistory(
        session,
        orderId,
        statusType: OrderStatusHistoryType.order,
        previousStatus: order.status.name,
        newStatus: OrderStatus.rejected.name,
        changedByUserId: user.id,
        note: trimmedReason,
        transaction: transaction,
      );
    });

    if (rejectedOrder != null) {
      await _events.dispatch(
        session,
        OrderRejectedEvent(
          order: rejectedOrder!,
          reason: trimmedReason,
          vendorId: vendor.id!,
        ),
      );
    }

    return getShopOrder(session, orderId);
  }
}
