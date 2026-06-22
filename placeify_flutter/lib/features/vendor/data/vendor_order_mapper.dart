import 'package:placeify_client/placeify_client.dart' as api;

import '../../cart/data/product_id_codec.dart';
import '../domain/enums/delivery_stage.dart' as domain;
import '../domain/enums/order_status.dart' as domain;
import '../domain/models/delivery_update.dart';
import '../domain/models/vendor_order.dart';

abstract final class VendorOrderMapper {
  static VendorOrder fromShopOrder(
    api.VendorShopOrder shopOrder, {
    required String vendorId,
  }) {
    final firstItem = shopOrder.items.first;
    final productName = shopOrder.itemCount > 1
        ? '${firstItem.productName} + ${shopOrder.itemCount - 1} more'
        : firstItem.productName;
    final quantity = shopOrder.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    return VendorOrder(
      id: shopOrder.orderId.toString(),
      orderNumber: shopOrder.orderNumber,
      vendorId: vendorId,
      productId: ProductIdCodec.fromDatabaseId(firstItem.productId),
      productName: productName,
      quantity: quantity,
      totalAmount: shopOrder.vendorTotal,
      status: mapOrderStatus(shopOrder.status),
      customerName: shopOrder.customerName,
      orderedAt: shopOrder.placedAt,
      orderPaymentStatus: shopOrder.orderPaymentStatus,
    );
  }

  static domain.OrderStatus mapOrderStatus(api.OrderStatus status) {
    return switch (status) {
      api.OrderStatus.pending => domain.OrderStatus.pending,
      // Legacy paid-but-unaccepted orders stay pending until vendor accepts.
      api.OrderStatus.confirmed => domain.OrderStatus.pending,
      api.OrderStatus.accepted => domain.OrderStatus.accepted,
      api.OrderStatus.rejected => domain.OrderStatus.rejected,
      api.OrderStatus.processing => domain.OrderStatus.processing,
      api.OrderStatus.shipped => domain.OrderStatus.shipped,
      api.OrderStatus.delivered => domain.OrderStatus.delivered,
      api.OrderStatus.cancelled => domain.OrderStatus.cancelled,
      api.OrderStatus.autoCancelled => domain.OrderStatus.cancelled,
    };
  }

  static domain.DeliveryStage mapDeliveryStage(api.DeliveryStage stage) {
    return switch (stage) {
      api.DeliveryStage.orderPlaced => domain.DeliveryStage.orderPlaced,
      api.DeliveryStage.packed => domain.DeliveryStage.packed,
      api.DeliveryStage.shipped => domain.DeliveryStage.shipped,
      api.DeliveryStage.outForDelivery => domain.DeliveryStage.outForDelivery,
      api.DeliveryStage.delivered => domain.DeliveryStage.delivered,
    };
  }

  static api.DeliveryStage toApiDeliveryStage(domain.DeliveryStage stage) {
    return switch (stage) {
      domain.DeliveryStage.orderPlaced => api.DeliveryStage.orderPlaced,
      domain.DeliveryStage.packed => api.DeliveryStage.packed,
      domain.DeliveryStage.shipped => api.DeliveryStage.shipped,
      domain.DeliveryStage.outForDelivery => api.DeliveryStage.outForDelivery,
      domain.DeliveryStage.delivered => api.DeliveryStage.delivered,
    };
  }

  static DeliveryUpdate fromDeliveryUpdate(api.OrderDeliveryUpdate update) {
    return DeliveryUpdate(
      id: update.id?.toString() ?? '${update.orderId}-${update.stage.name}',
      orderId: update.orderId.toString(),
      stage: mapDeliveryStage(update.stage),
      note: update.note ?? '',
      updatedAt: update.createdAt,
      photoProofPath: update.photoUrl,
    );
  }
}
