import 'package:placeify_flutter/features/orders/domain/enums/consumer_order_status.dart';
import 'package:placeify_flutter/features/orders/domain/enums/order_list_filter.dart';
import 'package:placeify_flutter/features/orders/domain/enums/payment_status.dart';

/// User-facing copy for the consumer orders feature.
abstract final class OrderStrings {
  // — List screen —
  static const myOrdersTitle = 'My Orders';
  static const myOrdersItalicLine = 'deliveries & returns';
  static const profileMenuTitle = 'My Orders';

  static const filterSheetTitle = 'Filter by';
  static const filterSheetSubtitle = 'Choose which orders to show';

  static String ordersCountSubtitle(int count) =>
      count == 1 ? '1 order' : '$count orders';

  static const searchHint = 'Search by order ID or vendor';
  static String noSearchResults(String query) => 'No results for "$query"';
  static const noSearchResultsSubtitle =
      'Try a different order ID or vendor name.';

  static String ordersSubtitle(int count, int inTransit) {
    final orderPart = count == 1 ? '1 order' : '$count orders';
    if (inTransit <= 0) return orderPart;
    final transitPart =
        inTransit == 1 ? '1 in transit' : '$inTransit in transit';
    return '$orderPart · $transitPart';
  }

  static String filterLabel(OrderListFilter filter) => switch (filter) {
        OrderListFilter.all => 'All',
        OrderListFilter.active => 'Active',
        OrderListFilter.delivered => 'Delivered',
        OrderListFilter.cancelled => 'Cancelled',
        OrderListFilter.returns => 'Returns',
      };

  static String statusLabel(ConsumerOrderStatus status) => status.label;

  static String paymentStatusLabel(PaymentStatus status) => status.label;

  // — Empty states —
  static String emptyTitle(OrderListFilter filter) => switch (filter) {
        OrderListFilter.all => 'No orders yet',
        OrderListFilter.active => 'No active orders',
        OrderListFilter.delivered => 'No delivered orders',
        OrderListFilter.cancelled => 'No cancelled orders',
        OrderListFilter.returns => 'No returns',
      };

  static String emptySubtitle(OrderListFilter filter) => switch (filter) {
        OrderListFilter.all =>
          'When you place an order, it will show up here.',
        OrderListFilter.active =>
          'Orders on the way or being prepared will appear here.',
        OrderListFilter.delivered =>
          'Delivered orders from the last few months show here.',
        OrderListFilter.cancelled =>
          'Cancelled orders are kept here for your records.',
        OrderListFilter.returns =>
          'Return requests and completed returns appear here.',
      };

  static const emptyCta = 'Browse furniture';

  // — Detail screen —
  static const orderDetailTitle = 'Order details';
  static const vendorSectionTitle = 'Sold by';
  static const timelineSectionTitle = 'Order progress';
  static const notificationsSectionTitle = 'Updates';
  static const itemsSectionTitle = 'Items';
  static const summarySectionTitle = 'Order summary';
  static const addressSectionTitle = 'Delivery address';
  static const subtotalLabel = 'Subtotal';
  static const deliveryFeeLabel = 'Delivery';
  static const discountLabel = 'Discount';
  static const totalLabel = 'Total';
  static const paymentMethodLabel = 'Payment method';
  static const viewProductAction = 'View product';
  static const placedOnPrefix = 'Placed on';

  // — Tracking screen —
  static const trackingTitle = 'Track order';
  static const trackingNumberLabel = 'Tracking number';
  static const estimatedDeliveryLabel = 'Estimated delivery';
  static const lastUpdatedLabel = 'Last updated';
  static const trackingCopiedToast = 'Tracking number copied';
  static const contactCourierAction = 'Contact courier';
  static const contactVendorAction = 'Contact vendor';
  static const contactCourierToast = 'Courier contact coming soon';
  static const contactVendorToast = 'Vendor contact coming soon';

  // — Card & quick actions —
  static const trackAction = 'Track order';
  static const reorderAction = 'Reorder';
  static const leaveReviewAction = 'Leave review';
  static const viewReturnAction = 'View return';
  static const cancelAction = 'Cancel order';
  static const requestReturnAction = 'Request return';
  static const contactSupportAction = 'Contact support';
  static const quickActionsTitle = 'Quick actions';
  static String moreItemsLabel(int count) => '+$count more';

  // — Cancel / return sheets —
  static const cancelSheetTitle = 'Cancel order?';
  static const cancelSheetSubtitle =
      'Tell us why you are cancelling. This cannot be undone.';
  static const returnSheetTitle = 'Request a return?';
  static const returnSheetSubtitle =
      'We will review your request and get back to you shortly.';
  static const reasonLabel = 'Reason';
  static const confirmCancel = 'Cancel order';
  static const confirmReturn = 'Submit return request';
  static const keepOrder = 'Keep order';

  static const cancelReasonChangedMind = 'Changed my mind';
  static const cancelReasonWrongItem = 'Ordered wrong item';
  static const cancelReasonFoundBetter = 'Found a better price';
  static const cancelReasonDeliveryTooLong = 'Delivery taking too long';
  static const cancelReasonOther = 'Other';

  static const returnReasonDamaged = 'Item arrived damaged';
  static const returnReasonNotAsDescribed = 'Not as described';
  static const returnReasonWrongItem = 'Wrong item received';
  static const returnReasonQuality = 'Quality not as expected';
  static const returnReasonOther = 'Other';

  static const cancelReasons = [
    cancelReasonChangedMind,
    cancelReasonWrongItem,
    cancelReasonFoundBetter,
    cancelReasonDeliveryTooLong,
    cancelReasonOther,
  ];

  static const returnReasons = [
    returnReasonDamaged,
    returnReasonNotAsDescribed,
    returnReasonWrongItem,
    returnReasonQuality,
    returnReasonOther,
  ];

  // — Toasts —
  static const reorderSuccess = 'Items added to cart';
  static const cancelSuccess = 'Order cancelled';
  static const returnSuccess = 'Return request submitted';
  static const cancelFailed = 'Could not cancel order';
  static const returnFailed = 'Could not submit return request';
}
