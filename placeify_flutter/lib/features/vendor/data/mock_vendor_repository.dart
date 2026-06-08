import 'package:flutter/material.dart';
import '../domain/models/order.dart';
import '../domain/models/vendor_metric.dart';

abstract final class MockVendorRepository {
  static const revenue = 8400.0;

  static const metrics = [
    VendorMetric(
      label: 'Orders',
      value: '47',
      trendLabel: '+12%',
      trendColor: Color(0xFF7A8C6E),
      iconPath: 'assets/icons/ic_trending_up.svg',
    ),
    VendorMetric(
      label: 'Products',
      value: '23',
      trendLabel: 'Active',
      trendColor: Color(0xFF7A8C6E),
      iconPath: 'assets/icons/ic_check_circle.svg',
    ),
  ];

  static final orders = [
    Order(
      id: 'o1',
      orderNumber: '4821',
      productName: 'Astra Chair',
      productSvgIconPath: 'assets/icons/ic_chair.svg',
      quantity: 2,
      date: DateTime(2026, 5, 15),
      status: OrderStatus.pending,
    ),
    Order(
      id: 'o2',
      orderNumber: '4820',
      productName: 'Brixon Chair',
      productSvgIconPath: 'assets/icons/ic_sofa.svg',
      quantity: 1,
      date: DateTime(2026, 5, 14),
      status: OrderStatus.shipped,
    ),
    Order(
      id: 'o3',
      orderNumber: '',
      productName: 'Custom Walnut Desk',
      productSvgIconPath: 'assets/icons/ic_table.svg',
      quantity: 1,
      date: DateTime(2026, 5, 14),
      status: OrderStatus.customRequest,
      requestMeta: 'Request · Anisha J.',
    ),
    Order(
      id: 'o4',
      orderNumber: '4819',
      productName: 'Odin 75',
      productSvgIconPath: 'assets/icons/ic_chair.svg',
      quantity: 4,
      date: DateTime(2026, 5, 13),
      status: OrderStatus.shipped,
    ),
  ];

  static const topProducts = [
    TopProductStat(
      name: 'Harmony Chair',
      iconPath: 'assets/icons/ic_sofa.svg',
      revenue: 'NPR 4.2k',
      progressFraction: 0.78,
      barColor: Color(0xFFC17F3C),
    ),
    TopProductStat(
      name: 'Brixon Chair',
      iconPath: 'assets/icons/ic_sofa.svg',
      revenue: 'NPR 2.8k',
      progressFraction: 0.52,
      barColor: Color(0xFF7A8C6E),
    ),
    TopProductStat(
      name: 'Astra Chair',
      iconPath: 'assets/icons/ic_chair.svg',
      revenue: 'NPR 2.1k',
      progressFraction: 0.38,
      barColor: Color(0xFF8B7355),
    ),
  ];

  static const barHeights = [0.38, 0.52, 0.33, 0.68, 0.58, 0.75, 1.0];
}
