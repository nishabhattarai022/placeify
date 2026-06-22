/// Static copy and form options for profile sub-screens.
abstract final class ProfileRefundReasons {
  static const selectPlaceholder = 'Select a reason';

  static const options = [
    selectPlaceholder,
    'Colour / finish mismatch',
    'Damaged during delivery',
    'Wrong item received',
    'Does not fit the space',
    'Quality not as expected',
    'Changed my mind',
  ];
}

/// UI metadata for notification preference toggles (field keys match API).
abstract final class ProfileNotificationFields {
  static const rows = <({String field, String title, String subtitle})>[
    (
      field: 'orderUpdates',
      title: 'Order Updates',
      subtitle: 'Shipping, delivery & confirmations',
    ),
    (
      field: 'refundStatus',
      title: 'Refund Status',
      subtitle: 'Updates on your return requests',
    ),
    (
      field: 'arReminders',
      title: 'AR Reminders',
      subtitle: "Items you tried in AR but didn't buy",
    ),
    (
      field: 'priceDropAlerts',
      title: 'Price Drop Alerts',
      subtitle: 'Wishlist items on sale',
    ),
    (
      field: 'vendorMessages',
      title: 'Vendor Messages',
      subtitle: 'Replies to your customisation requests',
    ),
    (
      field: 'promotions',
      title: 'Promotions & Offers',
      subtitle: 'Deals, new arrivals & seasonal sales',
    ),
  ];
}
