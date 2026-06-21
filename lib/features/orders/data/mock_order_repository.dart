import 'package:placeify/features/home/data/mock_product_repository.dart';
import 'package:placeify/features/home/domain/models/product.dart';
import 'package:placeify/features/orders/domain/enums/consumer_order_status.dart';
import 'package:placeify/features/orders/domain/enums/payment_status.dart';
import 'package:placeify/features/orders/domain/models/order.dart';
import 'package:placeify/features/orders/domain/models/order_item.dart';
import 'package:placeify/features/orders/domain/models/order_status_update.dart';
import 'package:placeify/features/orders/domain/repositories/order_repository.dart';

/// Mock consumer orders for [demoUserId] (12 seeded orders).
class MockOrderRepository implements OrderRepository {
  MockOrderRepository();

  static const demoUserId = 'demo-user';

  static const _deliveryAddress =
      '42 Lazimpat Road, Apartment 3B, Kathmandu 44600, Nepal';

  static const _deliveryFee = 250.0;

  static final List<Order> _orders = _seedOrders();

  @override
  Future<List<Order>> getOrders(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final orders = _orders.where((order) => order.userId == userId).toList()
      ..sort((a, b) => b.placedAt.compareTo(a.placedAt));
    return orders;
  }

  @override
  Future<Order?> getOrderById(String userId, String orderId) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    try {
      return _orders.firstWhere(
        (order) => order.userId == userId && order.id == orderId,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Order> cancelOrder(
    String userId,
    String orderId,
    String reason,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final index = _orders.indexWhere(
      (order) => order.userId == userId && order.id == orderId,
    );
    if (index < 0) {
      throw StateError('Order not found');
    }

    final order = _orders[index];
    if (!order.isCancellable) {
      throw StateError('Order cannot be cancelled');
    }

    final updated = order.copyWith(
      status: ConsumerOrderStatus.cancelled,
      cancellationReason: reason,
      paymentStatus: order.paymentStatus == PaymentStatus.paid
          ? PaymentStatus.refunded
          : order.paymentStatus,
      statusHistory: [
        ...order.statusHistory,
        OrderStatusUpdate(
          status: ConsumerOrderStatus.cancelled,
          timestamp: DateTime.now(),
          note: reason,
        ),
      ],
    );
    _orders[index] = updated;
    return updated;
  }

  @override
  Future<Order> requestReturn(
    String userId,
    String orderId,
    String reason,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final index = _orders.indexWhere(
      (order) => order.userId == userId && order.id == orderId,
    );
    if (index < 0) {
      throw StateError('Order not found');
    }

    final order = _orders[index];
    if (!order.isDelivered) {
      throw StateError('Only delivered orders can be returned');
    }

    final updated = order.copyWith(
      status: ConsumerOrderStatus.returnRequested,
      returnReason: reason,
      statusHistory: [
        ...order.statusHistory,
        OrderStatusUpdate(
          status: ConsumerOrderStatus.returnRequested,
          timestamp: DateTime.now(),
          note: reason,
        ),
      ],
    );
    _orders[index] = updated;
    return updated;
  }

  /// Snapshot helper — reads [MockProductRepository] catalog at seed time.
  static OrderItem orderItemFromProduct(
    Product product, {
    int quantity = 1,
    String? selectedColor,
  }) {
    final dims = product.dimensions;
    return OrderItem(
      productId: product.id,
      productName: product.name,
      productImageUrl: product.imageUrl,
      brandName: product.brand,
      sku: product.sku,
      unitPrice: product.originalPrice ?? product.price,
      discountedPrice: product.isOnSale ? product.price : null,
      quantity: quantity,
      selectedColor: selectedColor,
      dimensions: {
        'H': '${dims.heightCm.toInt()}cm',
        'W': '${dims.widthCm.toInt()}cm',
        'D': '${dims.depthCm.toInt()}cm',
      },
    );
  }

  static Product _requireProduct(String id) {
    for (final product in MockProductRepository.products) {
      if (product.id == id) return product;
    }
    throw StateError('Seed product $id not found');
  }

  static List<OrderItem> _items(List<({String id, int qty, String? color})> specs) {
    return specs
        .map(
          (spec) => orderItemFromProduct(
            _requireProduct(spec.id),
            quantity: spec.qty,
            selectedColor: spec.color,
          ),
        )
        .toList();
  }

  static ({double subtotal, double discount, double total}) _totals(
    List<OrderItem> items,
  ) {
    final subtotal = items.fold<double>(0, (sum, item) => sum + item.lineTotal);
    final undiscounted = items.fold<double>(
      0,
      (sum, item) => sum + item.unitPrice * item.quantity,
    );
    final discount = (undiscounted - subtotal).clamp(0.0, double.infinity);
    return (
      subtotal: subtotal,
      discount: discount,
      total: subtotal + _deliveryFee,
    );
  }

  static const _lifecycle = <ConsumerOrderStatus>[
    ConsumerOrderStatus.placed,
    ConsumerOrderStatus.confirmed,
    ConsumerOrderStatus.packed,
    ConsumerOrderStatus.dispatched,
    ConsumerOrderStatus.inTransit,
    ConsumerOrderStatus.outForDelivery,
    ConsumerOrderStatus.delivered,
  ];

  static const _stageOffsets = <Duration>[
    Duration.zero,
    Duration(hours: 2),
    Duration(hours: 22),
    Duration(days: 1),
    Duration(hours: 18),
    Duration(days: 1),
    Duration(hours: 5),
  ];

  static const _stageNotes = <String>[
    'Order received',
    'Vendor confirmed your order',
    'Items packed and ready to ship',
    'Handed to courier partner',
    'Package in transit to Kathmandu hub',
    'Out for delivery in your area',
    'Delivered successfully',
  ];

  static List<OrderStatusUpdate> _linearHistory(
    DateTime placedAt,
    ConsumerOrderStatus target,
  ) {
    final targetIndex = _lifecycle.indexOf(target);
    if (targetIndex < 0) {
      throw ArgumentError('Unsupported lifecycle status: $target');
    }

    var timestamp = placedAt;
    final history = <OrderStatusUpdate>[];
    for (var i = 0; i <= targetIndex; i++) {
      if (i > 0) {
        timestamp = timestamp.add(_stageOffsets[i]);
      }
      history.add(
        OrderStatusUpdate(
          status: _lifecycle[i],
          timestamp: timestamp,
          note: _stageNotes[i],
        ),
      );
    }
    return history;
  }

  static List<OrderStatusUpdate> _statusHistory({
    required DateTime placedAt,
    required ConsumerOrderStatus status,
    String? cancellationReason,
    String? returnReason,
  }) {
    return switch (status) {
      ConsumerOrderStatus.cancelled => [
          OrderStatusUpdate(
            status: ConsumerOrderStatus.placed,
            timestamp: placedAt,
            note: _stageNotes[0],
          ),
          OrderStatusUpdate(
            status: ConsumerOrderStatus.confirmed,
            timestamp: placedAt.add(const Duration(hours: 3)),
            note: _stageNotes[1],
          ),
          OrderStatusUpdate(
            status: ConsumerOrderStatus.cancelled,
            timestamp: placedAt.add(const Duration(days: 1, hours: 4)),
            note: cancellationReason ?? 'Order cancelled',
          ),
        ],
      ConsumerOrderStatus.returnRequested => [
          ..._linearHistory(placedAt, ConsumerOrderStatus.delivered),
          OrderStatusUpdate(
            status: ConsumerOrderStatus.returnRequested,
            timestamp: placedAt.add(const Duration(days: 12)),
            note: returnReason ?? 'Return requested by customer',
          ),
        ],
      ConsumerOrderStatus.returned => [
          ..._linearHistory(placedAt, ConsumerOrderStatus.delivered),
          OrderStatusUpdate(
            status: ConsumerOrderStatus.returnRequested,
            timestamp: placedAt.add(const Duration(days: 12)),
            note: returnReason ?? 'Return requested by customer',
          ),
          OrderStatusUpdate(
            status: ConsumerOrderStatus.returned,
            timestamp: placedAt.add(const Duration(days: 16)),
            note: 'Return completed and refund processed',
          ),
        ],
      _ => _linearHistory(placedAt, status),
    };
  }

  static String? _trackingNumber(ConsumerOrderStatus status) {
    return switch (status) {
      ConsumerOrderStatus.dispatched ||
      ConsumerOrderStatus.inTransit ||
      ConsumerOrderStatus.outForDelivery =>
        'TRK-NP-7849231',
      _ => null,
    };
  }

  static Order _order({
    required String id,
    required String orderNumber,
    required String vendorId,
    required String vendorName,
    required ConsumerOrderStatus status,
    required List<OrderItem> items,
    required DateTime placedAt,
    DateTime? estimatedDelivery,
    DateTime? deliveredAt,
    PaymentStatus paymentStatus = PaymentStatus.paid,
    String paymentMethod = 'Card ending in 4242',
    String? cancellationReason,
    String? returnReason,
    String? trackingOverride,
  }) {
    final totals = _totals(items);
    final history = _statusHistory(
      placedAt: placedAt,
      status: status,
      cancellationReason: cancellationReason,
      returnReason: returnReason,
    );
    final tracking =
        trackingOverride ?? _trackingNumber(status);

    return Order(
      id: id,
      orderNumber: orderNumber,
      userId: demoUserId,
      vendorId: vendorId,
      vendorName: vendorName,
      status: status,
      items: items,
      statusHistory: history,
      placedAt: placedAt,
      estimatedDelivery: estimatedDelivery,
      deliveredAt: deliveredAt,
      trackingNumber: tracking,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      subtotal: totals.subtotal,
      deliveryFee: _deliveryFee,
      discount: totals.discount,
      total: totals.total,
      deliveryAddress: _deliveryAddress,
      cancellationReason: cancellationReason,
      returnReason: returnReason,
    );
  }

  static List<Order> _seedOrders() {
    const woodcraft = (id: 'vendor-woodcraft', name: 'Woodcraft Nepal');
    const urbanNest = (id: 'vendor-urban-nest', name: 'Urban Nest');
    const artisan = (id: 'vendor-artisan-home', name: 'Artisan Home');

    // 1 — placed (just placed, pending confirmation)
    final o1Items = _items([(id: 'p4', qty: 1, color: 'Forest green')]);
    final o1Placed = DateTime(2026, 6, 21, 10, 30);
    final o1 = _order(
      id: 'ord-012',
      orderNumber: 'ORD-2026-0012',
      vendorId: woodcraft.id,
      vendorName: woodcraft.name,
      status: ConsumerOrderStatus.placed,
      items: o1Items,
      placedAt: o1Placed,
      estimatedDelivery: o1Placed.add(const Duration(days: 5)),
      paymentStatus: PaymentStatus.pending,
      paymentMethod: 'Cash on delivery',
    );

    // 2 — confirmed
    final o2Items = _items([(id: 'p6', qty: 1, color: 'Sage')]);
    final o2Placed = DateTime(2026, 6, 20, 14, 15);
    final o2 = _order(
      id: 'ord-011',
      orderNumber: 'ORD-2026-0011',
      vendorId: urbanNest.id,
      vendorName: urbanNest.name,
      status: ConsumerOrderStatus.confirmed,
      items: o2Items,
      placedAt: o2Placed,
      estimatedDelivery: o2Placed.add(const Duration(days: 4)),
    );

    // 3 — inTransit (profile badge count = 1)
    final o3Items = _items([
      (id: 'p1', qty: 1, color: 'Sage'),
      (id: 'p3', qty: 1, color: null),
      (id: 'p5', qty: 2, color: 'Natural oak'),
    ]);
    final o3Placed = DateTime(2026, 6, 16, 9, 0);
    final o3 = _order(
      id: 'ord-010',
      orderNumber: 'ORD-2026-0010',
      vendorId: woodcraft.id,
      vendorName: woodcraft.name,
      status: ConsumerOrderStatus.inTransit,
      items: o3Items,
      placedAt: o3Placed,
      estimatedDelivery: DateTime(2026, 6, 23),
      trackingOverride: 'TRK-NP-7849231',
    );

    // 4 — outForDelivery
    final o4Items = _items([
      (id: 'p2', qty: 1, color: null),
      (id: 'p10', qty: 1, color: 'Linen white'),
    ]);
    final o4Placed = DateTime(2026, 6, 14, 11, 45);
    final o4 = _order(
      id: 'ord-009',
      orderNumber: 'ORD-2026-0009',
      vendorId: urbanNest.id,
      vendorName: urbanNest.name,
      status: ConsumerOrderStatus.outForDelivery,
      items: o4Items,
      placedAt: o4Placed,
      estimatedDelivery: DateTime(2026, 6, 22),
      trackingOverride: 'TRK-NP-5529104',
    );

    // 5 — outForDelivery
    final o5Items = _items([
      (id: 'p5', qty: 1, color: null),
      (id: 'p6', qty: 1, color: 'Walnut'),
    ]);
    final o5Placed = DateTime(2026, 6, 12, 16, 20);
    final o5 = _order(
      id: 'ord-008',
      orderNumber: 'ORD-2026-0008',
      vendorId: artisan.id,
      vendorName: artisan.name,
      status: ConsumerOrderStatus.outForDelivery,
      items: o5Items,
      placedAt: o5Placed,
      estimatedDelivery: DateTime(2026, 6, 21),
      trackingOverride: 'TRK-NP-3318847',
    );

    // 6 — delivered (within last 30 days)
    final o6Items = _items([(id: 'p3', qty: 1, color: 'Charcoal')]);
    final o6Placed = DateTime(2026, 6, 5, 8, 30);
    final o6Delivered = DateTime(2026, 6, 10, 15, 10);
    final o6 = _order(
      id: 'ord-007',
      orderNumber: 'ORD-2026-0007',
      vendorId: woodcraft.id,
      vendorName: woodcraft.name,
      status: ConsumerOrderStatus.delivered,
      items: o6Items,
      placedAt: o6Placed,
      estimatedDelivery: o6Delivered,
      deliveredAt: o6Delivered,
      trackingOverride: 'TRK-NP-1190042',
    );

    // 7 — delivered (within last 30 days)
    final o7Items = _items([
      (id: 'p11', qty: 1, color: null),
      (id: 'p12', qty: 1, color: 'Oak'),
      (id: 'p13', qty: 2, color: null),
      (id: 'p14', qty: 1, color: 'Walnut'),
    ]);
    final o7Placed = DateTime(2026, 5, 28, 13, 0);
    final o7Delivered = DateTime(2026, 6, 2, 11, 30);
    final o7 = _order(
      id: 'ord-006',
      orderNumber: 'ORD-2026-0006',
      vendorId: urbanNest.id,
      vendorName: urbanNest.name,
      status: ConsumerOrderStatus.delivered,
      items: o7Items,
      placedAt: o7Placed,
      estimatedDelivery: o7Delivered,
      deliveredAt: o7Delivered,
      trackingOverride: 'TRK-NP-6672108',
    );

    // 8 — delivered (within last 30 days)
    final o8Items = _items([
      (id: 'p15', qty: 1, color: 'Brass'),
      (id: 'p16', qty: 2, color: null),
    ]);
    final o8Placed = DateTime(2026, 5, 25, 10, 15);
    final o8Delivered = DateTime(2026, 5, 30, 14, 45);
    final o8 = _order(
      id: 'ord-005',
      orderNumber: 'ORD-2026-0005',
      vendorId: artisan.id,
      vendorName: artisan.name,
      status: ConsumerOrderStatus.delivered,
      items: o8Items,
      placedAt: o8Placed,
      estimatedDelivery: o8Delivered,
      deliveredAt: o8Delivered,
      trackingOverride: 'TRK-NP-9044551',
    );

    // 9 — cancelled
    const cancelReason = 'Found a better price elsewhere';
    final o9Items = _items([
      (id: 'p1', qty: 1, color: null),
      (id: 'p2', qty: 1, color: 'Ivory'),
    ]);
    final o9Placed = DateTime(2026, 6, 8, 17, 40);
    final o9 = _order(
      id: 'ord-004',
      orderNumber: 'ORD-2026-0004',
      vendorId: woodcraft.id,
      vendorName: woodcraft.name,
      status: ConsumerOrderStatus.cancelled,
      items: o9Items,
      placedAt: o9Placed,
      paymentStatus: PaymentStatus.refunded,
      cancellationReason: cancelReason,
    );

    // 10 — returnRequested
    const returnReason = 'Item arrived with minor scratches';
    final o10Items = _items([(id: 'p4', qty: 1, color: 'Forest green')]);
    final o10Placed = DateTime(2026, 5, 20, 9, 30);
    final o10Delivered = DateTime(2026, 6, 1, 16, 0);
    final o10 = _order(
      id: 'ord-003',
      orderNumber: 'ORD-2026-0003',
      vendorId: urbanNest.id,
      vendorName: urbanNest.name,
      status: ConsumerOrderStatus.returnRequested,
      items: o10Items,
      placedAt: o10Placed,
      estimatedDelivery: o10Delivered,
      deliveredAt: o10Delivered,
      trackingOverride: 'TRK-NP-2287719',
      returnReason: returnReason,
    );

    // 11 — delivered (2–3 months ago)
    final o11Items = _items([
      (id: 'p7', qty: 1, color: null),
      (id: 'p8', qty: 1, color: 'Espresso'),
      (id: 'p9', qty: 1, color: 'Cloud grey'),
    ]);
    final o11Placed = DateTime(2026, 4, 1, 12, 0);
    final o11Delivered = DateTime(2026, 4, 8, 10, 30);
    final o11 = _order(
      id: 'ord-002',
      orderNumber: 'ORD-2026-0002',
      vendorId: woodcraft.id,
      vendorName: woodcraft.name,
      status: ConsumerOrderStatus.delivered,
      items: o11Items,
      placedAt: o11Placed,
      estimatedDelivery: o11Delivered,
      deliveredAt: o11Delivered,
      trackingOverride: 'TRK-NP-4410093',
    );

    // 12 — delivered (2–3 months ago)
    final o12Items = _items([
      (id: 'p17', qty: 1, color: 'Terracotta'),
      (id: 'p18', qty: 1, color: null),
    ]);
    final o12Placed = DateTime(2026, 3, 20, 15, 45);
    final o12Delivered = DateTime(2026, 3, 28, 13, 15);
    final o12 = _order(
      id: 'ord-001',
      orderNumber: 'ORD-2026-0001',
      vendorId: artisan.id,
      vendorName: artisan.name,
      status: ConsumerOrderStatus.delivered,
      items: o12Items,
      placedAt: o12Placed,
      estimatedDelivery: o12Delivered,
      deliveredAt: o12Delivered,
      trackingOverride: 'TRK-NP-7733001',
      paymentMethod: 'Cash on delivery',
    );

    final orders = [
      o1,
      o2,
      o3,
      o4,
      o5,
      o6,
      o7,
      o8,
      o9,
      o10,
      o11,
      o12,
    ];

    assert(orders.length == 12);
    assert(
      orders.where((o) => o.status == ConsumerOrderStatus.inTransit).length == 1,
    );
    assert(
      orders.where((o) => o.status == ConsumerOrderStatus.outForDelivery).length ==
          2,
    );
    assert(orders.where((o) => o.isDelivered).length == 5);
    assert(
      orders.where((o) => o.status == ConsumerOrderStatus.cancelled).length == 1,
    );
    assert(
      orders.where((o) => o.status == ConsumerOrderStatus.returnRequested).length ==
          1,
    );
    assert(
      orders.where((o) => o.status == ConsumerOrderStatus.placed).length == 1,
    );
    assert(
      orders.where((o) => o.status == ConsumerOrderStatus.confirmed).length == 1,
    );

    return orders;
  }
}
