import 'dart:typed_data';

import 'package:serverpod/serverpod.dart' hide Order;

import '../../../generated/protocol.dart';
import '../../../shared/session_service.dart';
import '../../marketplace/marketplace_events.dart';
import '../../order/order_lifecycle_store.dart';
import 'vendor_access_guard.dart';
import 'vendor_order_support.dart';

typedef VendorDeliveryImagePersister =
    Future<String> Function(
      Session session,
      ByteData fileData,
      String fileName, {
      required bool removeBackground,
    });

/// Vendor delivery stage updates and proof uploads.
class VendorDeliveryStore {
  VendorDeliveryStore({
    VendorAccessGuard? access,
    MarketplaceEventDispatcher? events,
    VendorDeliveryImagePersister? persistImage,
  }) : _access = access ?? VendorAccessGuard(),
       _events = events ?? marketplaceEventDispatcher,
       _persistImage = persistImage;

  final VendorAccessGuard _access;
  final MarketplaceEventDispatcher _events;
  final VendorDeliveryImagePersister? _persistImage;

  Future<List<OrderDeliveryUpdate>> listDeliveryUpdates(
    Session session,
    int orderId,
  ) async {
    final vendor = await _access.requireOwnedVendor(session);
    await VendorOrderSupport.assertVendorOwnsOrder(
      session,
      vendor.id!,
      orderId,
    );
    return VendorOrderSupport.deliveryUpdatesFor(session, vendor.id!, orderId);
  }

  Future<OrderDeliveryUpdate> submitDeliveryUpdate(
    Session session,
    int orderId,
    DeliveryStage stage, {
    String? note,
    String? photoUrl,
  }) async {
    final vendor = await _access.requireOwnedVendor(session);
    final user = await SessionService.requireUser(session);
    final order = await VendorOrderSupport.requireMutableVendorOrder(
      session,
      vendor.id!,
      orderId,
    );

    if (order.status == OrderStatus.pending ||
        order.status == OrderStatus.confirmed) {
      throw PlaceifyException(
        message: 'Accept the order before posting delivery updates.',
        code: 'ORDER_NOT_ACCEPTED',
      );
    }

    if (order.status == OrderStatus.rejected ||
        order.status == OrderStatus.cancelled ||
        order.status == OrderStatus.autoCancelled ||
        order.status == OrderStatus.returnRequested ||
        order.status == OrderStatus.refunded) {
      throw PlaceifyException(
        message: 'Delivery updates are not available for this order.',
        code: 'INVALID_ORDER_STATUS',
      );
    }

    if (order.deliveryStatus == OrderDeliveryStatus.delivered) {
      throw PlaceifyException(
        message: 'This order is already delivered.',
        code: 'ORDER_ALREADY_DELIVERED',
      );
    }

    final nextDeliveryStatus = OrderLifecycleStore.deliveryStatusForStage(
      stage,
    );
    if (nextDeliveryStatus == null) {
      throw PlaceifyException(
        message: 'This delivery stage cannot be applied.',
        code: 'INVALID_DELIVERY_STAGE',
      );
    }

    if (!OrderLifecycleStore.canAdvanceDeliveryStatus(
      order.deliveryStatus,
      nextDeliveryStatus,
    )) {
      throw PlaceifyException(
        message: 'Delivery status can only move forward one step at a time.',
        code: 'INVALID_DELIVERY_STAGE',
      );
    }

    final existing = await VendorOrderSupport.deliveryUpdatesFor(
      session,
      vendor.id!,
      orderId,
    );
    final expected = VendorOrderSupport.nextDeliveryStage(existing);
    if (expected == null) {
      throw PlaceifyException(
        message: 'All delivery stages are complete.',
        code: 'DELIVERY_COMPLETE',
      );
    }

    if (stage != expected) {
      throw PlaceifyException(
        message:
            'Updates must advance one stage at a time. Next stage: ${VendorOrderSupport.stageLabel(expected)}.',
        code: 'INVALID_DELIVERY_STAGE',
      );
    }

    if (existing.any((update) => update.stage == stage)) {
      throw PlaceifyException(
        message: 'This delivery stage was already recorded.',
        code: 'DUPLICATE_DELIVERY_STAGE',
      );
    }

    Order? updatedOrder;
    OrderDeliveryUpdate? update;
    await session.db.transaction((transaction) async {
      update = await OrderDeliveryUpdate.db.insertRow(
        session,
        OrderDeliveryUpdate(
          orderId: orderId,
          vendorId: vendor.id!,
          stage: stage,
          note: note?.trim(),
          photoUrl: photoUrl?.trim(),
        ),
        transaction: transaction,
      );

      updatedOrder = await OrderLifecycleStore.updateOrderWithVersion(
        session,
        order,
        (current) => current.copyWith(
          deliveryStatus: nextDeliveryStatus,
          status: OrderLifecycleStore.orderStatusForDelivery(
            nextDeliveryStatus,
          ),
        ),
        transaction: transaction,
      );

      await OrderLifecycleStore.appendHistory(
        session,
        orderId,
        statusType: OrderStatusHistoryType.delivery,
        previousStatus: order.deliveryStatus?.name,
        newStatus: nextDeliveryStatus.name,
        changedByUserId: user.id,
        note: note?.trim(),
        transaction: transaction,
      );

      final nextOrderStatus = OrderLifecycleStore.orderStatusForDelivery(
        nextDeliveryStatus,
      );
      if (order.status != nextOrderStatus) {
        await OrderLifecycleStore.appendHistory(
          session,
          orderId,
          statusType: OrderStatusHistoryType.order,
          previousStatus: order.status.name,
          newStatus: nextOrderStatus.name,
          changedByUserId: user.id,
          note: note?.trim(),
          transaction: transaction,
        );
      }
    });

    if (updatedOrder != null) {
      await _events.dispatch(
        session,
        DeliveryUpdatedEvent(
          order: updatedOrder!,
          stage: stage,
          vendorId: vendor.id!,
        ),
      );
    }

    return update!;
  }

  Future<String> uploadDeliveryProof(
    Session session,
    ByteData fileData,
    String fileName,
  ) async {
    await _access.requireOwnedVendor(session);
    final persist = _persistImage;
    if (persist == null) {
      throw PlaceifyException(
        message: 'Delivery proof upload is not configured.',
        code: 'UPLOAD_NOT_CONFIGURED',
      );
    }
    return persist(
      session,
      fileData,
      fileName,
      removeBackground: false,
    );
  }
}
