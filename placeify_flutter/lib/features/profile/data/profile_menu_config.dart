import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../vendor/domain/constants/vendor_strings.dart';
import '../../vendor/domain/enums/vendor_status.dart';

/// Profile screen layout constants and menu definitions.
abstract final class ProfileMenuConfig {
  static const String avatarAsset =
      'assets/images/splash/pexels-blackcurrant-great-2016663774-35378675.jpg';

  static const double sheetTopRadius = 28;
  static const double avatarSize = 100;
  static const double headerOverlap = 0;

  static const int wishlistCount = 8;
  static const int arTriesCount = 24;
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
    this.badgeBackgroundColor = AppColors.rust,
    this.badgeForegroundColor = Colors.white,
    this.isDanger = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final ProfileMenuRoute route;
  final String? badge;
  final Color badgeBackgroundColor;
  final Color badgeForegroundColor;
  final bool isDanger;
}

abstract final class ProfileMenuItems {
  static const List<ProfileMenuItemData> accountOverview = [
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
      subtitle: 'View refund requests',
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
          title: VendorStrings.becomeVendorTitle,
          subtitle: VendorStrings.becomeVendorSubtitle,
          icon: Icons.store_outlined,
          iconColor: AppColors.vendorForest,
          backgroundColor: AppColors.vendorForestBg,
          route: ProfileMenuRoute.vendor,
        ),
      VendorStatus.pending => const ProfileMenuItemData(
          title: VendorStrings.applicationPendingTitle,
          subtitle: VendorStrings.applicationPendingSubtitle,
          icon: Icons.hourglass_top_outlined,
          iconColor: AppColors.vendorForest,
          backgroundColor: AppColors.vendorForestBg,
          route: ProfileMenuRoute.vendor,
        ),
      VendorStatus.approved => const ProfileMenuItemData(
          title: VendorStrings.vendorDashboardTitle,
          subtitle: VendorStrings.vendorDashboardSubtitle,
          icon: Icons.dashboard_outlined,
          iconColor: AppColors.vendorForest,
          backgroundColor: AppColors.vendorForestBg,
          route: ProfileMenuRoute.vendor,
          badge: VendorStrings.activeBadge,
          badgeBackgroundColor: AppColors.sage,
        ),
      VendorStatus.suspended => const ProfileMenuItemData(
          title: VendorStrings.storeSuspendedTitle,
          subtitle: VendorStrings.storeSuspendedSubtitle,
          icon: Icons.block_outlined,
          iconColor: AppColors.textMuted,
          backgroundColor: AppColors.creamDark,
          route: ProfileMenuRoute.vendor,
        ),
    };
  }
}
