enum RefundStatus { underReview, refunded }

class ProfileStat {
  const ProfileStat({required this.value, required this.label});

  final String value;
  final String label;
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
