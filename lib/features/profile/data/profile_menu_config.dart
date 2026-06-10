import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../vendor/domain/enums/vendor_status.dart';

/// Profile screen layout constants and menu definitions.
abstract final class ProfileMenuConfig {
  static const String avatarAsset =
      'assets/images/splash/pexels-blackcurrant-great-2016663774-35378675.jpg';

  static const double sheetTopRadius = 28;
  static const double avatarSize = 100;
  static const double headerOverlap = 0;

  static const int ordersCount = 12;
  static const int wishlistCount = 8;
  static const int arTriesCount = 24;
  static const int refundsCount = 2;
}

enum ProfileMenuRoute {
  orders,
  wishlist,
  augmentedReality,
  refund,
  notifications,
  password,
  vendor,
  signOut,
}

class ProfileMenuItemData {
  const ProfileMenuItemData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.route,
    this.badge,
    this.isDanger = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final ProfileMenuRoute route;
  final String? badge;
  final bool isDanger;
}

abstract final class ProfileMenuItems {
  static const List<ProfileMenuItemData> accountOverview = [
    ProfileMenuItemData(
      title: 'My Orders',
      subtitle: '12 orders · 1 in transit',
      icon: Icons.inventory_2_outlined,
      iconColor: AppColors.sage,
      backgroundColor: AppColors.sageBg,
      route: ProfileMenuRoute.orders,
      badge: '1',
    ),
    ProfileMenuItemData(
      title: 'Wishlist',
      subtitle: '8 saved items',
      icon: Icons.star_border_rounded,
      iconColor: AppColors.coral,
      backgroundColor: AppColors.coralBg,
      route: ProfileMenuRoute.wishlist,
    ),
    ProfileMenuItemData(
      title: 'Augmented Reality',
      subtitle: 'Preview furniture in your space',
      icon: Icons.view_in_ar_outlined,
      iconColor: AppColors.lavender,
      backgroundColor: AppColors.lavenderBg,
      route: ProfileMenuRoute.augmentedReality,
    ),
    ProfileMenuItemData(
      title: 'Refund & Returns',
      subtitle: 'NPR 45.00 pending · 2 active',
      icon: Icons.paid_outlined,
      iconColor: AppColors.lavender,
      backgroundColor: AppColors.lavenderBg,
      route: ProfileMenuRoute.refund,
    ),
    ProfileMenuItemData(
      title: 'Notifications',
      subtitle: 'Manage alerts & reminders',
      icon: Icons.notifications_outlined,
      iconColor: AppColors.accent,
      backgroundColor: AppColors.accentBg,
      route: ProfileMenuRoute.notifications,
    ),
    ProfileMenuItemData(
      title: 'Change Password',
      subtitle: 'Last changed 3 months ago',
      icon: Icons.lock_outline_rounded,
      iconColor: AppColors.coral,
      backgroundColor: AppColors.coralBg,
      route: ProfileMenuRoute.password,
    ),
  ];

  static const ProfileMenuItemData signOut = ProfileMenuItemData(
    title: 'Sign Out',
    subtitle: 'See you next time',
    icon: Icons.logout_rounded,
    iconColor: AppColors.rust,
    backgroundColor: Color(0x1A9B4A2A),
    route: ProfileMenuRoute.signOut,
    isDanger: true,
  );

  static ProfileMenuItemData vendorTile(VendorStatus status) {
    return switch (status) {
      VendorStatus.none => const ProfileMenuItemData(
          title: 'Become a Vendor',
          subtitle: 'Start selling on Placeify',
          icon: Icons.storefront_outlined,
          iconColor: AppColors.vendorForest,
          backgroundColor: AppColors.vendorForestBg,
          route: ProfileMenuRoute.vendor,
        ),
      VendorStatus.pending => const ProfileMenuItemData(
          title: 'Become a Vendor',
          subtitle: 'Application under review',
          icon: Icons.storefront_outlined,
          iconColor: AppColors.vendorForest,
          backgroundColor: AppColors.vendorForestBg,
          route: ProfileMenuRoute.vendor,
          badge: 'Pending',
        ),
      VendorStatus.approved => const ProfileMenuItemData(
          title: 'Vendor Dashboard',
          subtitle: 'Manage orders & products',
          icon: Icons.storefront_outlined,
          iconColor: AppColors.vendorForest,
          backgroundColor: AppColors.vendorForestBg,
          route: ProfileMenuRoute.vendor,
          badge: 'Live',
        ),
      VendorStatus.suspended => const ProfileMenuItemData(
          title: 'Vendor Account',
          subtitle: 'Contact support',
          icon: Icons.storefront_outlined,
          iconColor: AppColors.textMuted,
          backgroundColor: AppColors.creamDark,
          route: ProfileMenuRoute.vendor,
          badge: 'Suspended',
        ),
    };
  }
}
