import 'package:flutter/foundation.dart';
import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../auth/domain/models/app_user.dart';

/// Temporary debug logs for profile/account backend wiring investigation.
abstract final class ProfileDebugLog {
  static void accountOverview({
    AppUser? user,
    UserDashboard? dashboard,
    int? ordersListLength,
    int? wishlistLocalCount,
    Object? dashboardError,
  }) {
    if (!kDebugMode) return;

    debugPrint('[PROFILE DEBUG] user: $user');
    debugPrint(
      '[PROFILE DEBUG] token: ${client.auth.isAuthenticated ? "exists" : "missing"}',
    );
    debugPrint('[PROFILE DEBUG] serverUrl: $serverUrl');

    if (dashboardError != null) {
      debugPrint('[PROFILE DEBUG] dashboard error: $dashboardError');
    } else if (dashboard != null) {
      debugPrint(
        '[PROFILE DEBUG] dashboard: orders=${dashboard.orderCounts.activeOrders} '
        'wishlist=${dashboard.wishlistCount} refunds=${dashboard.refundCount}',
      );
    } else {
      debugPrint('[PROFILE DEBUG] dashboard: null (signed out or loading)');
    }

    if (ordersListLength != null) {
      debugPrint('[PROFILE DEBUG] orders list length: $ordersListLength');
    }
    if (wishlistLocalCount != null) {
      debugPrint('[PROFILE DEBUG] wishlist local count: $wishlistLocalCount');
    }
  }
}
