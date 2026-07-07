import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import 'marketplace_notification_handlers.dart';

/// Base class for marketplace domain events.
sealed class MarketplaceEvent {
  const MarketplaceEvent();
}

final class OrderAcceptedEvent extends MarketplaceEvent {
  const OrderAcceptedEvent({
    required this.order,
    required this.vendorId,
  });

  final Order order;
  final UuidValue vendorId;
}

final class OrderRejectedEvent extends MarketplaceEvent {
  const OrderRejectedEvent({
    required this.order,
    required this.reason,
    required this.vendorId,
  });

  final Order order;
  final String reason;
  final UuidValue vendorId;
}

final class OrderDeliveredEvent extends MarketplaceEvent {
  const OrderDeliveredEvent({
    required this.order,
    required this.vendorId,
  });

  final Order order;
  final UuidValue vendorId;
}

final class OrderPlacedEvent extends MarketplaceEvent {
  const OrderPlacedEvent({
    required this.order,
    required this.vendorId,
    required this.customerName,
    required this.itemCount,
  });

  final Order order;
  final UuidValue vendorId;
  final String customerName;
  final int itemCount;
}

final class DeliveryUpdatedEvent extends MarketplaceEvent {
  const DeliveryUpdatedEvent({
    required this.order,
    required this.stage,
    required this.vendorId,
  });

  final Order order;
  final DeliveryStage stage;
  final UuidValue vendorId;
}

final class ProductCreatedEvent extends MarketplaceEvent {
  const ProductCreatedEvent({
    required this.product,
    required this.vendorId,
  });

  final Product product;
  final UuidValue vendorId;
}

final class DiscountActivatedEvent extends MarketplaceEvent {
  const DiscountActivatedEvent({
    required this.product,
    required this.vendorId,
  });

  final Product product;
  final UuidValue vendorId;
}

final class OrderCancelledForVendorEvent extends MarketplaceEvent {
  const OrderCancelledForVendorEvent({
    required this.order,
    required this.vendorId,
    required this.reason,
  });

  final Order order;
  final UuidValue vendorId;
  final String reason;
}

final class PaymentStatusChangedEvent extends MarketplaceEvent {
  const PaymentStatusChangedEvent({
    required this.order,
    required this.status,
    required this.vendorId,
  });

  final Order order;
  final OrderPaymentStatus status;
  final UuidValue vendorId;
}

final class CustomerOrderPlacedEvent extends MarketplaceEvent {
  const CustomerOrderPlacedEvent({required this.order});

  final Order order;
}

final class OrderAutoCancelledEvent extends MarketplaceEvent {
  const OrderAutoCancelledEvent({required this.order});

  final Order order;
}

typedef MarketplaceEventHandler = Future<void> Function(
  Session session,
  MarketplaceEvent event,
);

/// Dispatches domain events to registered handlers (notifications, analytics, etc.).
class MarketplaceEventDispatcher {
  MarketplaceEventDispatcher({List<MarketplaceEventHandler>? handlers})
      : _handlers = handlers ?? defaultHandlers;

  final List<MarketplaceEventHandler> _handlers;

  static List<MarketplaceEventHandler> get defaultHandlers => [
        marketplaceNotificationHandler,
      ];

  Future<void> dispatch(Session session, MarketplaceEvent event) async {
    for (final handler in _handlers) {
      await handler(session, event);
    }
  }
}

MarketplaceEventDispatcher marketplaceEventDispatcher =
    MarketplaceEventDispatcher();
