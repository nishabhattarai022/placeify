import 'package:placeify_client/placeify_client.dart';

import 'enums/order_list_filter.dart';

/// Maps backend [UserOrderCounts] to the number shown in list headers.
int orderListTitleCountFor({
  required OrderListFilter filter,
  required UserOrderCounts counts,
}) {
  return switch (filter) {
    OrderListFilter.all => counts.activeOrders,
    OrderListFilter.active => counts.inProgressOrders,
    OrderListFilter.delivered => counts.deliveredOrders,
    OrderListFilter.cancelled => counts.cancelledOrders,
    OrderListFilter.returns => counts.returnOrders,
  };
}
