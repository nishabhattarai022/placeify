import 'package:placeify_client/placeify_client.dart';

import 'profile_mock_data.dart';

/// Maps [UserDashboard] API rows into Nisha profile stat cells.
abstract final class ProfileDashboardMapper {
  static const emptyStats = [
    ProfileStat(value: '0', label: 'Orders'),
    ProfileStat(value: '0', label: 'Wishlist'),
    ProfileStat(value: '0', label: 'AR Tries'),
    ProfileStat(value: '0', label: 'Refunds'),
  ];

  static List<ProfileStat> stats(UserDashboard dashboard) => [
    ProfileStat(
      value: '${dashboard.orderCounts.activeOrders}',
      label: 'Orders',
    ),
    ProfileStat(value: '${dashboard.wishlistCount}', label: 'Wishlist'),
    ProfileStat(
      value: '${dashboard.arSessionCount}',
      label: 'AR Tries',
    ),
    ProfileStat(value: '${dashboard.refundCount}', label: 'Refunds'),
  ];

  /// Nisha profile header: Orders, Wishlist, Refunds (3 cells).
  static List<ProfileStat> headerStats(UserDashboard dashboard) => [
    ProfileStat(
      value: '${dashboard.orderCounts.activeOrders}',
      label: 'Orders',
    ),
    ProfileStat(value: '${dashboard.wishlistCount}', label: 'Wishlist'),
    ProfileStat(value: '${dashboard.refundCount}', label: 'Refunds'),
  ];

  static const emptyHeaderStats = [
    ProfileStat(value: '0', label: 'Orders'),
    ProfileStat(value: '0', label: 'Wishlist'),
    ProfileStat(value: '0', label: 'Refunds'),
  ];
}
