import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/features/vendor/domain/enums/delivery_stage.dart';
import 'package:placeify/features/vendor/domain/enums/notification_type.dart';
import 'package:placeify/features/vendor/domain/enums/order_status.dart';
import 'package:placeify/features/vendor/domain/models/delivery_update.dart';
import 'package:placeify/features/vendor/domain/enums/payment_status.dart';
import 'package:placeify/features/vendor/domain/models/vendor_metric.dart';
import 'package:placeify/features/vendor/domain/models/vendor_notification.dart';
import 'package:placeify/features/vendor/domain/models/vendor_order.dart';
import 'package:placeify/features/vendor/domain/models/vendor_payout.dart';
import 'package:placeify/features/vendor/domain/models/vendor_product.dart';
import 'package:placeify/features/vendor/domain/models/vendor_operating_day.dart';
import 'package:placeify/features/vendor/domain/models/vendor_profile.dart';
import 'package:placeify/features/vendor/domain/models/vendor_social_links.dart';
import 'package:placeify/features/vendor/domain/models/vendor_stats.dart';

/// Seed data for mock vendor repositories and legacy dashboard widgets.
abstract final class VendorMockConfig {
  static const demoVendorId = 'demo-vendor';

  static const revenue = 8400.0;

  static const metrics = [
    VendorMetric(
      label: 'Orders',
      value: '47',
      trendLabel: '+12%',
      trendColor: AppColors.sage,
      iconPath: 'assets/icons/ic_trending_up.svg',
    ),
    VendorMetric(
      label: 'Products',
      value: '23',
      trendLabel: 'Active',
      trendColor: AppColors.sage,
      iconPath: 'assets/icons/ic_check_circle.svg',
    ),
  ];

  static const topProducts = [
    TopProductStat(
      name: 'Harmony Chair',
      iconPath: 'assets/icons/ic_sofa.svg',
      revenue: 'NPR 4.2k',
      progressFraction: 0.78,
      barColor: AppColors.accent,
    ),
    TopProductStat(
      name: 'Brixon Chair',
      iconPath: 'assets/icons/ic_sofa.svg',
      revenue: 'NPR 2.8k',
      progressFraction: 0.52,
      barColor: AppColors.sage,
    ),
    TopProductStat(
      name: 'Astra Chair',
      iconPath: 'assets/icons/ic_chair.svg',
      revenue: 'NPR 2.1k',
      progressFraction: 0.38,
      barColor: AppColors.bark,
    ),
  ];

  /// Normalized 7-day revenue sparkline (oldest → newest).
  static const revenueSeries = [0.38, 0.52, 0.33, 0.68, 0.58, 0.75, 1.0];

  /// @deprecated Use [revenueSeries].
  static const barHeights = revenueSeries;

  static var profile = VendorProfile(
    id: demoVendorId,
    businessName: 'Harmony Home Furnishings',
    email: 'vendor@placeify.demo',
    phone: '+977 9800000000',
    address: 'Lazimpat, Kathmandu',
    tags: const ['Chairs', 'Tables'],
    schedule: defaultVendorWeekSchedule(),
    socialLinks: const VendorSocialLinks(
      instagram: 'harmonyhome.np',
      facebook: 'harmonyhomefurnishings',
      website: 'https://harmonyhome.np',
    ),
    bio:
        'Curated modern furniture and decor for Nepali homes. Custom orders welcome.',
    bannerUrl: null,
    createdAt: DateTime(2025, 11, 1),
  );

  static const stats = VendorStats(
    revenue: revenue,
    orderCount: 47,
    productCount: 23,
    viewCount: 1280,
    conversionRate: 0.036,
    periodLabel: 'Last 30 days',
    averageRating: 4.67,
    responseRate: 0.67,
  );

  static final products = [
    VendorProduct(
      id: 'p1',
      vendorId: demoVendorId,
      name: 'Harmony Chair',
      sku: 'HH-CHR-001',
      price: 12500,
      stock: 18,
      imageUrls: const [],
      categoryId: 'chairs',
      createdAt: DateTime(2025, 12, 10),
      warrantyNote: '2-year limited warranty',
      shippingNote: 'Ships in 5–7 business days',
    ),
    VendorProduct(
      id: 'p2',
      vendorId: demoVendorId,
      name: 'Brixon Chair',
      sku: 'HH-CHR-002',
      price: 9800,
      stock: 12,
      imageUrls: const [],
      categoryId: 'chairs',
      createdAt: DateTime(2026, 1, 5),
    ),
    VendorProduct(
      id: 'p3',
      vendorId: demoVendorId,
      name: 'Astra Chair',
      sku: 'HH-CHR-003',
      price: 11200,
      stock: 9,
      imageUrls: const [],
      categoryId: 'chairs',
      createdAt: DateTime(2026, 2, 20),
    ),
    VendorProduct(
      id: 'p4',
      vendorId: demoVendorId,
      name: 'Odin Desk',
      sku: 'HH-TBL-001',
      price: 28500,
      stock: 6,
      imageUrls: const [],
      categoryId: 'tables',
      createdAt: DateTime(2026, 3, 8),
    ),
    VendorProduct(
      id: 'p5',
      vendorId: demoVendorId,
      name: 'Luna Sofa',
      sku: 'HH-SOF-001',
      price: 42000,
      stock: 4,
      imageUrls: const [],
      categoryId: 'sofas',
      isActive: false,
      createdAt: DateTime(2026, 3, 22),
    ),
    VendorProduct(
      id: 'p6',
      vendorId: demoVendorId,
      name: 'Nordic Lamp',
      sku: 'HH-LGT-001',
      price: 4500,
      stock: 22,
      imageUrls: const [],
      categoryId: 'lights',
      createdAt: DateTime(2026, 4, 2),
    ),
    VendorProduct(
      id: 'p7',
      vendorId: demoVendorId,
      name: 'Oslo Bed',
      sku: 'HH-BED-001',
      price: 56000,
      stock: 3,
      imageUrls: const [],
      categoryId: 'beds',
      createdAt: DateTime(2026, 4, 18),
    ),
    VendorProduct(
      id: 'p8',
      vendorId: demoVendorId,
      name: 'Ceramic Vase Set',
      sku: 'HH-DEC-001',
      price: 3200,
      stock: 15,
      imageUrls: const [],
      categoryId: 'decor',
      isActive: false,
      createdAt: DateTime(2026, 5, 1),
    ),
  ];

  static final orders = [
    VendorOrder(
      id: 'vo1',
      orderNumber: '4821',
      vendorId: demoVendorId,
      productId: 'p3',
      productName: 'Astra Chair',
      quantity: 2,
      totalAmount: 22400,
      status: OrderStatus.pending,
      customerName: 'Riya Sharma',
      orderedAt: DateTime(2026, 6, 10, 9, 15),
    ),
    VendorOrder(
      id: 'vo4',
      orderNumber: '4822',
      vendorId: demoVendorId,
      productId: 'p1',
      productName: 'Harmony Chair',
      quantity: 1,
      totalAmount: 12500,
      status: OrderStatus.pending,
      customerName: 'Priya Karki',
      orderedAt: DateTime(2026, 6, 9, 14, 30),
    ),
    VendorOrder(
      id: 'vo5',
      orderNumber: '4818',
      vendorId: demoVendorId,
      productId: 'p2',
      productName: 'Brixon Chair',
      quantity: 2,
      totalAmount: 19600,
      status: OrderStatus.accepted,
      customerName: 'Anisha Joshi',
      orderedAt: DateTime(2026, 6, 8, 11, 0),
    ),
    VendorOrder(
      id: 'vo6',
      orderNumber: '4817',
      vendorId: demoVendorId,
      productId: 'p3',
      productName: 'Astra Chair',
      quantity: 3,
      totalAmount: 33600,
      status: OrderStatus.processing,
      customerName: 'Samir Thapa',
      orderedAt: DateTime(2026, 6, 7, 16, 45),
    ),
    VendorOrder(
      id: 'vo2',
      orderNumber: '4820',
      vendorId: demoVendorId,
      productId: 'p2',
      productName: 'Brixon Chair',
      quantity: 1,
      totalAmount: 9800,
      status: OrderStatus.shipped,
      customerName: 'Anisha Joshi',
      orderedAt: DateTime(2026, 6, 5, 10, 20),
    ),
    VendorOrder(
      id: 'vo3',
      orderNumber: '4819',
      vendorId: demoVendorId,
      productId: 'p1',
      productName: 'Harmony Chair',
      quantity: 4,
      totalAmount: 50000,
      status: OrderStatus.delivered,
      customerName: 'Samir Thapa',
      orderedAt: DateTime(2026, 5, 28, 13, 10),
    ),
    VendorOrder(
      id: 'vo7',
      orderNumber: '4816',
      vendorId: demoVendorId,
      productId: 'p2',
      productName: 'Brixon Chair',
      quantity: 1,
      totalAmount: 9800,
      status: OrderStatus.delivered,
      customerName: 'Riya Sharma',
      orderedAt: DateTime(2026, 5, 20, 9, 0),
    ),
    VendorOrder(
      id: 'vo8',
      orderNumber: '4815',
      vendorId: demoVendorId,
      productId: 'p3',
      productName: 'Astra Chair',
      quantity: 1,
      totalAmount: 11200,
      status: OrderStatus.cancelled,
      customerName: 'Priya Karki',
      orderedAt: DateTime(2026, 5, 18, 15, 30),
    ),
    VendorOrder(
      id: 'vo9',
      orderNumber: '4814',
      vendorId: demoVendorId,
      productId: 'p1',
      productName: 'Harmony Chair',
      quantity: 2,
      totalAmount: 25000,
      status: OrderStatus.rejected,
      customerName: 'Dev Raj',
      orderedAt: DateTime(2026, 5, 12, 8, 45),
    ),
  ];

  static final deliveryUpdates = [
    DeliveryUpdate(
      id: 'du1',
      orderId: 'vo5',
      stage: DeliveryStage.orderPlaced,
      note: 'Order confirmed by vendor.',
      updatedAt: DateTime(2026, 6, 8, 11, 30),
    ),
    DeliveryUpdate(
      id: 'du2',
      orderId: 'vo6',
      stage: DeliveryStage.orderPlaced,
      note: 'Order accepted and queued for packing.',
      updatedAt: DateTime(2026, 6, 7, 17, 0),
    ),
    DeliveryUpdate(
      id: 'du3',
      orderId: 'vo6',
      stage: DeliveryStage.packed,
      note: 'Items packed and ready for dispatch.',
      updatedAt: DateTime(2026, 6, 8, 9, 15),
    ),
    DeliveryUpdate(
      id: 'du4',
      orderId: 'vo2',
      stage: DeliveryStage.orderPlaced,
      note: 'Order placed and accepted.',
      updatedAt: DateTime(2026, 6, 5, 10, 45),
    ),
    DeliveryUpdate(
      id: 'du5',
      orderId: 'vo2',
      stage: DeliveryStage.packed,
      note: 'Packed with protective wrapping.',
      updatedAt: DateTime(2026, 6, 6, 8, 0),
    ),
    DeliveryUpdate(
      id: 'du6',
      orderId: 'vo2',
      stage: DeliveryStage.shipped,
      note: 'Handed to courier — tracking #PKT-8821.',
      updatedAt: DateTime(2026, 6, 7, 14, 20),
    ),
    DeliveryUpdate(
      id: 'du7',
      orderId: 'vo3',
      stage: DeliveryStage.orderPlaced,
      note: 'Order received.',
      updatedAt: DateTime(2026, 5, 28, 13, 30),
    ),
    DeliveryUpdate(
      id: 'du8',
      orderId: 'vo3',
      stage: DeliveryStage.packed,
      note: 'Packed for delivery.',
      updatedAt: DateTime(2026, 5, 29, 10, 0),
    ),
    DeliveryUpdate(
      id: 'du9',
      orderId: 'vo3',
      stage: DeliveryStage.shipped,
      note: 'Shipped from warehouse.',
      updatedAt: DateTime(2026, 5, 30, 9, 45),
    ),
    DeliveryUpdate(
      id: 'du10',
      orderId: 'vo3',
      stage: DeliveryStage.outForDelivery,
      note: 'Out for delivery in Kathmandu.',
      updatedAt: DateTime(2026, 5, 31, 11, 0),
    ),
    DeliveryUpdate(
      id: 'du11',
      orderId: 'vo3',
      stage: DeliveryStage.delivered,
      note: 'Delivered and signed by customer.',
      updatedAt: DateTime(2026, 6, 1, 16, 30),
    ),
    DeliveryUpdate(
      id: 'du12',
      orderId: 'vo7',
      stage: DeliveryStage.orderPlaced,
      note: 'Order received.',
      updatedAt: DateTime(2026, 5, 20, 9, 30),
    ),
    DeliveryUpdate(
      id: 'du13',
      orderId: 'vo7',
      stage: DeliveryStage.packed,
      note: 'Packed for delivery.',
      updatedAt: DateTime(2026, 5, 21, 10, 0),
    ),
    DeliveryUpdate(
      id: 'du14',
      orderId: 'vo7',
      stage: DeliveryStage.shipped,
      note: 'Shipped from warehouse.',
      updatedAt: DateTime(2026, 5, 22, 9, 0),
    ),
    DeliveryUpdate(
      id: 'du15',
      orderId: 'vo7',
      stage: DeliveryStage.outForDelivery,
      note: 'Courier en route.',
      updatedAt: DateTime(2026, 5, 23, 11, 30),
    ),
    DeliveryUpdate(
      id: 'du16',
      orderId: 'vo7',
      stage: DeliveryStage.delivered,
      note: 'Delivered successfully.',
      updatedAt: DateTime(2026, 5, 24, 14, 0),
    ),
  ];

  static final notifications = [
    VendorNotification(
      id: 'n1',
      type: NotificationType.order,
      title: 'New order received',
      body: 'Order #4821 for 2× Astra Chair is awaiting confirmation.',
      createdAt: DateTime(2026, 6, 10, 9, 30),
      relatedId: 'vo1',
    ),
    VendorNotification(
      id: 'n2',
      type: NotificationType.order,
      title: 'Order accepted reminder',
      body: 'Order #4822 from Priya Karki is still pending your response.',
      createdAt: DateTime(2026, 6, 9, 16, 45),
      relatedId: 'vo4',
    ),
    VendorNotification(
      id: 'n3',
      type: NotificationType.order,
      title: 'Order shipped',
      body: 'Order #4820 for Brixon Chair has been marked as shipped.',
      isRead: true,
      createdAt: DateTime(2026, 6, 5, 11, 0),
      relatedId: 'vo2',
    ),
    VendorNotification(
      id: 'n4',
      type: NotificationType.payment,
      title: 'Payout processed',
      body: 'NPR 42,000 has been transferred to your account.',
      isRead: true,
      createdAt: DateTime(2026, 5, 10, 14, 0),
      relatedId: 'pay1',
    ),
    VendorNotification(
      id: 'n5',
      type: NotificationType.payment,
      title: 'Payout pending',
      body: 'NPR 18,500 payout is queued for the next transfer cycle.',
      createdAt: DateTime(2026, 6, 8, 10, 15),
      relatedId: 'pay2',
    ),
    VendorNotification(
      id: 'n6',
      type: NotificationType.payment,
      title: 'Payment received',
      body: 'Customer payment confirmed for Order #4819.',
      createdAt: DateTime(2026, 5, 28, 15, 30),
      relatedId: 'vo3',
    ),
    VendorNotification(
      id: 'n7',
      type: NotificationType.product,
      title: 'Low stock alert',
      body: 'Astra Chair is down to 9 units.',
      createdAt: DateTime(2026, 6, 7, 11, 15),
      relatedId: 'p3',
    ),
    VendorNotification(
      id: 'n8',
      type: NotificationType.product,
      title: 'Product approved',
      body: 'Harmony Chair listing is now live in the catalog.',
      isRead: true,
      createdAt: DateTime(2026, 6, 1, 9, 0),
      relatedId: 'p1',
    ),
    VendorNotification(
      id: 'n9',
      type: NotificationType.product,
      title: 'Listing inactive',
      body: 'Odin 75 has been deactivated due to missing images.',
      createdAt: DateTime(2026, 5, 22, 13, 40),
      relatedId: 'p4',
    ),
    VendorNotification(
      id: 'n10',
      type: NotificationType.system,
      title: 'Profile verification complete',
      body: 'Your vendor profile has been verified. You can now receive orders.',
      isRead: true,
      createdAt: DateTime(2026, 4, 20, 10, 0),
    ),
    VendorNotification(
      id: 'n11',
      type: NotificationType.system,
      title: 'Scheduled maintenance',
      body: 'Placeify vendor portal will be offline Jun 12, 2–4 AM NPT.',
      createdAt: DateTime(2026, 6, 6, 8, 0),
    ),
    VendorNotification(
      id: 'n12',
      type: NotificationType.system,
      title: 'New feature: payment updates',
      body: 'You can now manually update payment status from the Payments tab.',
      createdAt: DateTime(2026, 5, 30, 12, 0),
    ),
  ];

  static final payouts = [
    VendorPayout(
      id: 'pay1',
      amount: 42000,
      status: PaymentStatus.paid,
      paidAt: DateTime(2026, 5, 10),
      reference: 'PO-20260510-001',
    ),
    VendorPayout(
      id: 'pay2',
      amount: 18500,
      status: PaymentStatus.pending,
      reference: 'PO-20260520-002',
    ),
  ];

  static final Map<String, VendorProfile> _approvedProfiles = {};

  /// Registers a vendor profile after admin approval (dynamic vendor IDs).
  static void registerApprovedProfile(VendorProfile profile) {
    _approvedProfiles[profile.id] = profile;
  }

  static bool isKnownVendor(String vendorId) => vendorId == demoVendorId;

  static VendorProfile? profileFor(String vendorId) {
    final approved = _approvedProfiles[vendorId];
    if (approved != null) return approved;
    return isKnownVendor(vendorId) ? profile : null;
  }

  static VendorProfile? updateProfile(VendorProfile updated) {
    if (_approvedProfiles.containsKey(updated.id)) {
      _approvedProfiles[updated.id] = updated;
      return updated;
    }
    if (!isKnownVendor(updated.id)) return null;
    profile = updated;
    return profile;
  }

  static VendorStats statsFor(String vendorId) {
    if (!isKnownVendor(vendorId)) {
      return const VendorStats(
        revenue: 0,
        orderCount: 0,
        productCount: 0,
        viewCount: 0,
        conversionRate: 0,
        periodLabel: 'Last 30 days',
        averageRating: 0,
        responseRate: 0,
      );
    }
    return stats;
  }

  static List<VendorOrder> ordersFor(String vendorId, {int limit = 20}) {
    if (!isKnownVendor(vendorId)) return [];
    return orders.take(limit).toList();
  }

  static VendorOrder? orderById(String vendorId, String orderId) {
    if (!isKnownVendor(vendorId)) return null;
    for (final order in orders) {
      if (order.id == orderId) return order;
    }
    return null;
  }

  static VendorOrder? updateOrderStatus(String orderId, OrderStatus status) {
    final index = orders.indexWhere((order) => order.id == orderId);
    if (index < 0) return null;

    final updated = orders[index].copyWith(status: status);
    orders[index] = updated;
    return updated;
  }

  static List<DeliveryUpdate> deliveryUpdatesFor(String orderId) {
    return deliveryUpdates
        .where((update) => update.orderId == orderId)
        .toList()
      ..sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
  }

  static int _stageIndex(DeliveryStage stage) =>
      DeliveryStage.values.indexOf(stage);

  static DeliveryStage? nextDeliveryStage(String orderId) {
    final existing = deliveryUpdatesFor(orderId);
    if (existing.isEmpty) return DeliveryStage.orderPlaced;

    var maxIndex = -1;
    for (final update in existing) {
      final index = _stageIndex(update.stage);
      if (index > maxIndex) maxIndex = index;
    }

    final nextIndex = maxIndex + 1;
    if (nextIndex >= DeliveryStage.values.length) return null;
    return DeliveryStage.values[nextIndex];
  }

  static OrderStatus _statusForStage(DeliveryStage stage) {
    return switch (stage) {
      DeliveryStage.orderPlaced => OrderStatus.accepted,
      DeliveryStage.packed => OrderStatus.processing,
      DeliveryStage.shipped => OrderStatus.shipped,
      DeliveryStage.outForDelivery => OrderStatus.shipped,
      DeliveryStage.delivered => OrderStatus.delivered,
    };
  }

  static DeliveryUpdate? submitDeliveryUpdate({
    required String vendorId,
    required String orderId,
    required DeliveryStage stage,
    String? note,
    String? photoProofPath,
  }) {
    if (!isKnownVendor(vendorId)) return null;

    final order = orderById(vendorId, orderId);
    if (order == null) return null;

    if (order.status == OrderStatus.pending) return null;
    if (order.status == OrderStatus.rejected ||
        order.status == OrderStatus.cancelled ||
        order.status == OrderStatus.delivered) {
      return null;
    }

    final expected = nextDeliveryStage(orderId);
    if (expected == null || stage != expected) return null;

    if (deliveryUpdates.any(
      (update) => update.orderId == orderId && update.stage == stage,
    )) {
      return null;
    }

    final update = DeliveryUpdate(
      id: 'du${deliveryUpdates.length + 1}',
      orderId: orderId,
      stage: stage,
      note: note?.trim() ?? '',
      updatedAt: DateTime.now(),
      photoProofPath: photoProofPath,
    );
    deliveryUpdates.add(update);
    updateOrderStatus(orderId, _statusForStage(stage));
    return update;
  }

  static List<VendorNotification> notificationsFor(String vendorId) {
    if (!isKnownVendor(vendorId)) return [];
    return notifications;
  }

  static List<VendorPayout> payoutsFor(String vendorId) {
    if (!isKnownVendor(vendorId)) return [];
    return payouts;
  }

  static List<VendorProduct> productsFor(String vendorId) {
    if (!isKnownVendor(vendorId)) return [];
    return products;
  }

  static List<double> revenueSeriesFor(String vendorId) {
    if (!isKnownVendor(vendorId)) {
      return List<double>.filled(revenueSeries.length, 0);
    }
    return revenueSeries;
  }

  static List<TopProductStat> topProductsFor(String vendorId) {
    if (!isKnownVendor(vendorId)) return [];
    return topProducts;
  }

  static VendorProduct? productById(String productId) {
    for (final product in products) {
      if (product.id == productId) return product;
    }
    return null;
  }

  static int deleteProducts(List<String> productIds) {
    final ids = productIds.toSet();
    final before = products.length;
    products.removeWhere((product) => ids.contains(product.id));
    return before - products.length;
  }

  static VendorProduct upsertProduct(VendorProduct product) {
    final index = products.indexWhere((entry) => entry.id == product.id);
    if (index >= 0) {
      products[index] = product;
    } else {
      products.add(product);
    }
    return product;
  }

  static String nextProductId() => 'p${products.length + 1}';
}
