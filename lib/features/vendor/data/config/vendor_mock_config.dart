import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/features/vendor/domain/enums/notification_type.dart';
import 'package:placeify/features/vendor/domain/enums/order_status.dart';
import 'package:placeify/features/vendor/domain/enums/payment_status.dart';
import 'package:placeify/features/vendor/domain/models/order.dart' as legacy;
import 'package:placeify/features/vendor/domain/models/vendor_metric.dart';
import 'package:placeify/features/vendor/domain/models/vendor_notification.dart';
import 'package:placeify/features/vendor/domain/models/vendor_order.dart';
import 'package:placeify/features/vendor/domain/models/vendor_payout.dart';
import 'package:placeify/features/vendor/domain/models/vendor_product.dart';
import 'package:placeify/features/vendor/domain/models/vendor_profile.dart';
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

  static final legacyOrders = [
    legacy.Order(
      id: 'o1',
      orderNumber: '4821',
      productName: 'Astra Chair',
      productSvgIconPath: 'assets/icons/ic_chair.svg',
      quantity: 2,
      date: DateTime(2026, 5, 15),
      status: legacy.OrderStatus.pending,
    ),
    legacy.Order(
      id: 'o2',
      orderNumber: '4820',
      productName: 'Brixon Chair',
      productSvgIconPath: 'assets/icons/ic_sofa.svg',
      quantity: 1,
      date: DateTime(2026, 5, 14),
      status: legacy.OrderStatus.shipped,
    ),
    legacy.Order(
      id: 'o3',
      orderNumber: '',
      productName: 'Custom Walnut Desk',
      productSvgIconPath: 'assets/icons/ic_table.svg',
      quantity: 1,
      date: DateTime(2026, 5, 14),
      status: legacy.OrderStatus.customRequest,
      requestMeta: 'Request · Anisha J.',
    ),
    legacy.Order(
      id: 'o4',
      orderNumber: '4819',
      productName: 'Odin 75',
      productSvgIconPath: 'assets/icons/ic_chair.svg',
      quantity: 4,
      date: DateTime(2026, 5, 13),
      status: legacy.OrderStatus.shipped,
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

  static final profile = VendorProfile(
    id: demoVendorId,
    businessName: 'Harmony Home Furnishings',
    email: 'vendor@placeify.demo',
    phone: '+977 9800000000',
    address: 'Lazimpat, Kathmandu',
    category: 'Furniture',
    createdAt: DateTime(2025, 11, 1),
  );

  static const stats = VendorStats(
    revenue: revenue,
    orderCount: 47,
    productCount: 23,
    viewCount: 1280,
    conversionRate: 0.036,
    periodLabel: 'Last 30 days',
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

  static final notifications = [
    VendorNotification(
      id: 'n1',
      type: NotificationType.order,
      title: 'New order received',
      body: 'Order #4821 for 2× Astra Chair is awaiting confirmation.',
      createdAt: DateTime(2026, 5, 15, 9, 30),
      relatedId: 'vo1',
    ),
    VendorNotification(
      id: 'n2',
      type: NotificationType.payment,
      title: 'Payout processed',
      body: 'NPR 42,000 has been transferred to your account.',
      isRead: true,
      createdAt: DateTime(2026, 5, 10, 14, 0),
      relatedId: 'pay1',
    ),
    VendorNotification(
      id: 'n3',
      type: NotificationType.product,
      title: 'Low stock alert',
      body: 'Astra Chair is down to 9 units.',
      createdAt: DateTime(2026, 5, 12, 11, 15),
      relatedId: 'p3',
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

  static bool isKnownVendor(String vendorId) => vendorId == demoVendorId;

  static VendorProfile? profileFor(String vendorId) =>
      isKnownVendor(vendorId) ? profile : null;

  static VendorStats statsFor(String vendorId) {
    if (!isKnownVendor(vendorId)) {
      return const VendorStats(
        revenue: 0,
        orderCount: 0,
        productCount: 0,
        viewCount: 0,
        conversionRate: 0,
        periodLabel: 'Last 30 days',
      );
    }
    return stats;
  }

  static List<VendorOrder> ordersFor(String vendorId, {int limit = 20}) {
    if (!isKnownVendor(vendorId)) return [];
    return orders.take(limit).toList();
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
}
