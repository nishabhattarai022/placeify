import 'package:flutter_test/flutter_test.dart';
import 'package:placeify_client/placeify_client.dart';
import 'package:placeify_flutter/features/orders/domain/enums/order_list_filter.dart';
import 'package:placeify_flutter/features/orders/domain/order_count_display.dart';

void main() {
  final counts = UserOrderCounts(
    totalOrders: 35,
    activeOrders: 30,
    cancelledOrders: 5,
    deliveredOrders: 20,
    inProgressOrders: 8,
    returnOrders: 2,
  );

  test('profile and all-orders title use activeOrders excluding cancelled', () {
    expect(
      orderListTitleCountFor(filter: OrderListFilter.all, counts: counts),
      30,
    );
    expect(counts.activeOrders, 30);
    expect(counts.totalOrders - counts.cancelledOrders, 30);
  });

  test('cancelled filter shows cancelledOrders only', () {
    expect(
      orderListTitleCountFor(filter: OrderListFilter.cancelled, counts: counts),
      5,
    );
  });

  test('delivered and in-progress filters use dedicated backend counters', () {
    expect(
      orderListTitleCountFor(
        filter: OrderListFilter.delivered,
        counts: counts,
      ),
      20,
    );
    expect(
      orderListTitleCountFor(filter: OrderListFilter.active, counts: counts),
      8,
    );
    expect(
      orderListTitleCountFor(filter: OrderListFilter.returns, counts: counts),
      2,
    );
  });
}
