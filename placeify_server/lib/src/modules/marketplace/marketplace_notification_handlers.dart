import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../notification/order_notification_service.dart';
import 'marketplace_events.dart';

Future<void> marketplaceNotificationHandler(
  Session session,
  MarketplaceEvent event,
) async {
  switch (event) {
    case OrderPlacedEvent():
      await OrderNotificationService.notifyVendorNewOrder(
        session,
        order: event.order,
        vendorId: event.vendorId,
        customerName: event.customerName,
        itemCount: event.itemCount,
      );

    case CustomerOrderPlacedEvent():
      await OrderNotificationService.notifyCustomerOrderPlaced(
        session,
        order: event.order,
      );

    case OrderAcceptedEvent():
      await OrderNotificationService.notifyOrderAccepted(
        session,
        order: event.order,
        vendorId: event.vendorId,
      );

    case OrderRejectedEvent():
      session.log(
        'OrderRejectedEvent received '
        'orderId=${event.order.id} reason=${event.reason}',
        level: LogLevel.info,
      );

      await OrderNotificationService.notifyOrderRejected(
        session,
        order: event.order,
        reason: event.reason,
      );

    case DeliveryUpdatedEvent():
      await OrderNotificationService.notifyDeliveryStage(
        session,
        order: event.order,
        stage: event.stage,
        vendorId: event.vendorId,
      );

    case OrderDeliveredEvent():
      break;

    case OrderCancelledForVendorEvent():
      await OrderNotificationService.notifyVendorOrderCancelled(
        session,
        order: event.order,
        vendorId: event.vendorId,
        reason: event.reason,
      );

    case PaymentStatusChangedEvent():
      await OrderNotificationService.notifyPaymentStatus(
        session,
        order: event.order,
        status: event.status,
        vendorId: event.vendorId,
      );

    case OrderAutoCancelledEvent():
      await OrderNotificationService.notifyOrderAutoCancelled(
        session,
        order: event.order,
      );

    case ProductCreatedEvent():
      await OrderNotificationService.notifyConsumersNewProduct(
        session,
        product: event.product,
        vendorName: await _vendorName(session, event.vendorId),
      );

    case DiscountActivatedEvent():
      await OrderNotificationService.notifyConsumersSpecialOffer(
        session,
        product: event.product,
        vendorName: await _vendorName(session, event.vendorId),
      );
  }
}

Future<String> _vendorName(
  Session session,
  UuidValue vendorId,
) async {
  final vendor = await Vendor.db.findById(
    session,
    vendorId,
  );

  return vendor?.shopName ?? 'A vendor';
}
