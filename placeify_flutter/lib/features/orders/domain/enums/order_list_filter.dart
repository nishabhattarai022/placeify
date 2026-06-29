import 'package:flutter/material.dart';

import '../constants/order_strings.dart';

/// List filter for [MyOrdersScreen].
enum OrderListFilter {
  all,
  active,
  delivered,
  cancelled,
  returns,
}

extension OrderListFilterMeta on OrderListFilter {
  String get menuLabel => OrderStrings.filterLabel(this);

  String get barLabel => switch (this) {
    OrderListFilter.all => 'All orders',
    OrderListFilter.active => 'Active orders',
    OrderListFilter.delivered => 'Delivered',
    OrderListFilter.cancelled => 'Cancelled',
    OrderListFilter.returns => 'Returns',
  };

  IconData get icon => switch (this) {
    OrderListFilter.all => Icons.inventory_2_outlined,
    OrderListFilter.active => Icons.local_shipping_outlined,
    OrderListFilter.delivered => Icons.check_circle_outline_rounded,
    OrderListFilter.cancelled => Icons.cancel_outlined,
    OrderListFilter.returns => Icons.assignment_return_outlined,
  };
}
