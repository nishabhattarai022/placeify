import 'package:flutter/material.dart';

/// Sidebar destinations for the user dashboard shell.
enum UserDashboardNav {
  dashboard,
  orders,
  cart,
  wishlist,
  refund,
  notifications,
  profile,
  settings,
  tryMe,
}

extension UserDashboardNavX on UserDashboardNav {
  String get label => switch (this) {
        UserDashboardNav.dashboard => 'Dashboard',
        UserDashboardNav.orders => 'Orders',
        UserDashboardNav.cart => 'Cart',
        UserDashboardNav.wishlist => 'Wishlist',
        UserDashboardNav.refund => 'Refund & Return',
        UserDashboardNav.notifications => 'Notifications',
        UserDashboardNav.profile => 'Profile',
        UserDashboardNav.settings => 'Settings',
        UserDashboardNav.tryMe => 'Try Me',
      };

  IconData get icon => switch (this) {
        UserDashboardNav.dashboard => Icons.dashboard_outlined,
        UserDashboardNav.orders => Icons.receipt_long_outlined,
        UserDashboardNav.cart => Icons.shopping_cart_outlined,
        UserDashboardNav.wishlist => Icons.favorite_border_rounded,
        UserDashboardNav.refund => Icons.assignment_return_outlined,
        UserDashboardNav.notifications => Icons.notifications_outlined,
        UserDashboardNav.profile => Icons.person_outline_rounded,
        UserDashboardNav.settings => Icons.settings_outlined,
        UserDashboardNav.tryMe => Icons.view_in_ar_outlined,
      };

  String get routePath => switch (this) {
        UserDashboardNav.dashboard => '/user/dashboard',
        UserDashboardNav.orders => '/profile/orders',
        UserDashboardNav.cart => '/cart',
        UserDashboardNav.wishlist => '/bookmarks',
        UserDashboardNav.refund => '/profile/refund',
        UserDashboardNav.notifications => '/profile/notifications',
        UserDashboardNav.profile => '/profile',
        UserDashboardNav.settings => '/profile/settings',
        UserDashboardNav.tryMe => '/profile/augmented-reality',
      };

  String get pageTitle => switch (this) {
        UserDashboardNav.dashboard => 'Dashboard',
        UserDashboardNav.orders => 'Orders',
        UserDashboardNav.cart => 'Cart',
        UserDashboardNav.wishlist => 'Wishlist',
        UserDashboardNav.refund => 'Refund & Return',
        UserDashboardNav.notifications => 'Notifications',
        UserDashboardNav.profile => 'Profile',
        UserDashboardNav.settings => 'Settings',
        UserDashboardNav.tryMe => 'Try Me',
      };

}

UserDashboardNav? userDashboardNavForPath(String location) {
  for (final item in UserDashboardNav.values) {
    if (location == item.routePath ||
        location.startsWith('${item.routePath}/')) {
      return item;
    }
  }
  return null;
}
