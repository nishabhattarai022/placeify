enum OrderStatus { processing, shipped, delivered, cancelled }

enum RefundStatus { underReview, refunded }

class ProfileStat {
  const ProfileStat({required this.value, required this.label});

  final String value;
  final String label;
}

class ProfileOrder {
  const ProfileOrder({
    required this.id,
    required this.orderNumber,
    required this.productName,
    required this.thumbEmoji,
    required this.dateLabel,
    required this.priceLabel,
    required this.statusLabel,
    required this.status,
    required this.dateDetail,
    this.hasArPreview = false,
    this.progressStep = 0,
    this.primaryAction,
    this.secondaryAction,
  });

  final String id;
  final String orderNumber;
  final String productName;
  final String thumbEmoji;
  final String dateLabel;
  final String priceLabel;
  final String statusLabel;
  final OrderStatus status;
  final String dateDetail;
  final bool hasArPreview;
  final int progressStep;
  final String? primaryAction;
  final String? secondaryAction;
}

class ProfileRefund {
  const ProfileRefund({
    required this.productName,
    required this.thumbEmoji,
    required this.reason,
    required this.amountLabel,
    required this.status,
    required this.isCompleted,
  });

  final String productName;
  final String thumbEmoji;
  final String reason;
  final String amountLabel;
  final RefundStatus status;
  final bool isCompleted;
}

class ProfileArSession {
  const ProfileArSession({
    required this.productId,
    required this.productName,
    required this.thumbEmoji,
    required this.room,
    required this.dateLabel,
    required this.durationLabel,
  });

  final String productId;
  final String productName;
  final String thumbEmoji;
  final String room;
  final String dateLabel;
  final String durationLabel;
}

class NotificationPref {
  const NotificationPref({
    required this.title,
    required this.subtitle,
    this.enabled = true,
  });

  final String title;
  final String subtitle;
  final bool enabled;
}

abstract final class ProfileMockData {
  static const stats = [
    ProfileStat(value: '12', label: 'Orders'),
    ProfileStat(value: '8', label: 'Wishlist'),
    ProfileStat(value: '24', label: 'AR Tries'),
    ProfileStat(value: '2', label: 'Refunds'),
  ];

  static const orderFilters = [
    'All (12)',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  static const orders = [
    ProfileOrder(
      id: 'o1',
      orderNumber: 'HC80700',
      productName: 'Harmony Chair',
      thumbEmoji: '🛋️',
      dateLabel: 'May 14, 2026',
      priceLabel: 'NPR 110.00',
      statusLabel: 'Shipped',
      status: OrderStatus.shipped,
      dateDetail: 'Expected May 20',
      hasArPreview: true,
      progressStep: 2,
      primaryAction: 'Need Help?',
      secondaryAction: 'Track Package',
    ),
    ProfileOrder(
      id: 'o2',
      orderNumber: 'LP01049',
      productName: 'Astra Chair × 2',
      thumbEmoji: '🪑',
      dateLabel: 'May 8, 2026',
      priceLabel: 'NPR 112.00',
      statusLabel: 'Delivered',
      status: OrderStatus.delivered,
      dateDetail: 'Delivered May 12',
      primaryAction: 'Return Item',
      secondaryAction: 'Leave Review',
    ),
    ProfileOrder(
      id: 'o3',
      orderNumber: 'NT33201',
      productName: 'Nordic Side Table',
      thumbEmoji: '🪞',
      dateLabel: 'May 17, 2026',
      priceLabel: 'NPR 78.00',
      statusLabel: 'Processing',
      status: OrderStatus.processing,
      dateDetail: 'Placed today',
      hasArPreview: true,
      primaryAction: 'Contact Vendor',
      secondaryAction: 'Cancel Order',
    ),
  ];

  static const activeRefunds = [
    ProfileRefund(
      productName: 'Astra Chair (1 unit)',
      thumbEmoji: '🪑',
      reason: 'Reason: Colour mismatch',
      amountLabel: 'NPR 28.00',
      status: RefundStatus.underReview,
      isCompleted: false,
    ),
    ProfileRefund(
      productName: 'Floor Lamp Oden',
      thumbEmoji: '💡',
      reason: 'Reason: Damaged in delivery',
      amountLabel: 'NPR 17.00',
      status: RefundStatus.underReview,
      isCompleted: false,
    ),
  ];

  static const completedRefunds = [
    ProfileRefund(
      productName: 'Brixon Lounge Chair',
      thumbEmoji: '🛋️',
      reason: 'Reason: Wrong size delivered',
      amountLabel: 'NPR 85.00',
      status: RefundStatus.refunded,
      isCompleted: true,
    ),
  ];

  static const refundOrderOptions = [
    'Harmony Chair — #HC80700',
    'Astra Chair × 2 — #LP01049',
    'Nordic Side Table — #NT33201',
  ];

  static const refundReasonOptions = [
    'Select a reason',
    'Colour / finish mismatch',
    'Damaged during delivery',
    'Wrong item received',
    'Does not fit the space',
    'Quality not as expected',
    'Changed my mind',
  ];

  static const arSessions = [
    ProfileArSession(
      productId: 'p4',
      productName: 'Harmony Chair',
      thumbEmoji: '🛋️',
      room: 'Living Room',
      dateLabel: 'May 16, 2026',
      durationLabel: '4m 32s in AR',
    ),
    ProfileArSession(
      productId: 'p1',
      productName: 'Astra Chair × 2',
      thumbEmoji: '🪑',
      room: 'Home Office',
      dateLabel: 'May 14, 2026',
      durationLabel: '2m 18s in AR',
    ),
    ProfileArSession(
      productId: 'p3',
      productName: 'Nordic Side Table',
      thumbEmoji: '🪞',
      room: 'Bedroom',
      dateLabel: 'May 12, 2026',
      durationLabel: '1m 44s in AR',
    ),
  ];

  static const notificationPrefs = [
    NotificationPref(
      title: 'Order Updates',
      subtitle: 'Shipping, delivery & confirmations',
    ),
    NotificationPref(
      title: 'Refund Status',
      subtitle: 'Updates on your return requests',
    ),
    NotificationPref(
      title: 'AR Reminders',
      subtitle: "Items you tried in AR but didn't buy",
    ),
    NotificationPref(
      title: 'Price Drop Alerts',
      subtitle: 'Wishlist items on sale',
      enabled: false,
    ),
    NotificationPref(
      title: 'Vendor Messages',
      subtitle: 'Replies to your customisation requests',
    ),
    NotificationPref(
      title: 'Promotions & Offers',
      subtitle: 'Deals, new arrivals & seasonal sales',
      enabled: false,
    ),
  ];
}
